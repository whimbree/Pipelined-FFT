library ieee;
use ieee.std_logic_1164.all;

entity complex_reg is

    generic (
        width : positive := 8);
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        input_real  : in std_logic_vector(width - 1 downto 0);
        input_img   : in std_logic_vector(width - 1 downto 0);
        output_real : out std_logic_vector(width - 1 downto 0);
        output_img  : out std_logic_vector(width - 1 downto 0));

end complex_reg;

architecture ASYNC_RST of complex_reg is
begin

    process (clk, rst)
    begin
        if rst = '1' then
            output_real <= (others => '0');
            output_img  <= (others => '0');
        elsif rising_edge(clk) then
            output_real <= input_real;
            output_img  <= input_img;
        end if;
    end process;
end ASYNC_RST;