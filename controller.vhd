library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is

    generic (
        width : positive := 16);
    port (
        clk : in std_logic;
        rst : in std_logic;

        theta_select_0, theta_select_1, theta_select_2 : out std_logic_vector(1 downto 0);

        ds_select_0, ds_select_1, ds_select_2, ds_select_3 : out std_logic);

end controller;

architecture BHV of controller is
begin

    process (clk, rst)
    begin

    end process;
end BHV;