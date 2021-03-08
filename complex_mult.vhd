library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- https://www.intel.com/content/www/us/en/programmable/support/support-resources/knowledge-base/solutions/rd11072012_614.html
entity complex_mult is
    generic (
        width : positive := 32);
    port (
        clock      : in std_logic;
        dataa_real : in std_logic_vector(width - 1 downto 0);
        dataa_imag : in std_logic_vector(width - 1 downto 0);
        datab_real : in std_logic_vector(width - 1 downto 0);
        datab_imag : in std_logic_vector(width - 1 downto 0);

        result_real : out std_logic_vector((width * 2) - 1 downto 0);
        result_imag : out std_logic_vector((width * 2) - 1 downto 0));
end complex_mult;

architecture BHV of complex_mult is
    signal x_r_reg, x_i_reg, y_r_reg, y_i_reg : signed(width - 1 downto 0);
    signal a1, a2, a3                         : signed(width - 1 downto 0);
    signal p1, p2, p3                         : signed((width * 2) - 1 downto 0);
begin
    process (clock)
    begin
        if rising_edge(clock) then
            --stage 1
            x_r_reg <= signed(dataa_real);
            x_i_reg <= signed(dataa_imag);
            y_r_reg <= signed(datab_real);
            y_i_reg <= signed(datab_imag);

            -- stage 2
            a1 <= x_r_reg - x_i_reg;
            a2 <= y_r_reg - y_i_reg;
            a3 <= y_r_reg + y_i_reg;

            -- stage 3
            p1 <= a1 * y_i_reg;
            p2 <= a2 * x_r_reg;
            p3 <= a3 * x_i_reg;

            -- stage 4
            result_real <= std_logic_vector(p1 + p2);
            result_imag <= std_logic_vector(p1 + p3);
        end if;
    end process;

end BHV;