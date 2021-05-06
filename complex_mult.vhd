library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- https://www.intel.com/content/www/us/en/programmable/support/support-resources/knowledge-base/solutions/rd11072012_614.html
entity complex_mult is
    generic (
        width : positive := 32);
    port (
        clk        : in std_logic;
        rst        : in std_logic;
        dataa_real : in std_logic_vector(width - 1 downto 0);
        dataa_imag : in std_logic_vector(width - 1 downto 0);
        datab_real : in std_logic_vector(width - 1 downto 0);
        datab_imag : in std_logic_vector(width - 1 downto 0);

        result_real : out std_logic_vector((width * 2) - 1 downto 0);
        result_imag : out std_logic_vector((width * 2) - 1 downto 0));
end complex_mult;

architecture BHV_PIPELINED of complex_mult is
    signal x_r_reg, x_i_reg, y_r_reg, y_i_reg : signed(width - 1 downto 0);
    signal x_r_reg_d, x_i_reg_d, y_i_reg_d    : signed(width - 1 downto 0);
    signal a1, a2, a3                         : signed(width downto 0);
    signal p1, p2, p3                         : signed((width * 2) downto 0);
begin
    process (clk, rst)
    begin
        if rst = '1' then
            x_r_reg   <= (others => '0');
            x_i_reg   <= (others => '0');
            y_r_reg   <= (others => '0');
            y_i_reg   <= (others => '0');
            x_r_reg_d <= (others => '0');
            x_i_reg_d <= (others => '0');
            y_i_reg_d <= (others => '0');
            a1        <= (others => '0');
            a2        <= (others => '0');
            a3        <= (others => '0');
            p1        <= (others => '0');
            p2        <= (others => '0');
            p3        <= (others => '0');
        elsif rising_edge(clk) then
            --stage 1
            x_r_reg <= signed(dataa_real);
            x_i_reg <= signed(dataa_imag);
            y_r_reg <= signed(datab_real);
            y_i_reg <= signed(datab_imag);

            -- stage 2
            a1 <= resize(x_r_reg, width + 1) - resize(x_i_reg, width + 1);
            a2 <= resize(y_r_reg, width + 1) - resize(y_i_reg, width + 1);
            a3 <= resize(y_r_reg, width + 1) + resize(y_i_reg, width + 1);
            -- preserve old registers for use in stage 3
            x_r_reg_d <= x_r_reg;
            x_i_reg_d <= x_i_reg;
            y_i_reg_d <= y_i_reg;

            -- stage 3
            p1 <= a1 * y_i_reg_d;
            p2 <= a2 * x_r_reg_d;
            p3 <= a3 * x_i_reg_d;
        end if;
    end process;

    result_real <= std_logic_vector(resize(p1 + p2, width * 2));
    result_imag <= std_logic_vector(resize(p1 + p3, width * 2));

end BHV_PIPELINED;