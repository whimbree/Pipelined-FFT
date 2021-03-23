library ieee;
use ieee.std_logic_1164.all;

entity reg is

    generic (
        width : positive := 8);
    port (
        clk    : in std_logic;
        rst    : in std_logic;
        input  : in std_logic_vector(width - 1 downto 0);
        output : out std_logic_vector(width - 1 downto 0));

end reg;

architecture ASYNC_RST of reg is
begin

    process (clk, rst)
    begin
        if rst = '1' then
            output <= (others => '0');
        elsif rising_edge(clk) then
            output <= input;
        end if;
    end process;
end ASYNC_RST;