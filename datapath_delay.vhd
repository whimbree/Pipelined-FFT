--6,10,13

library ieee;
use ieee.std_logic_1164.all;

entity datapath_delay is
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        ready : in std_logic;

        cm2_valid    : out std_logic;
        ds2_valid    : out std_logic;
        ds3_valid    : out std_logic;
        output_valid : out std_logic);
end datapath_delay;

architecture STR of datapath_delay is

    signal cm2_valid_wire, ds2_valid_wire, ds3_valid_wire : std_logic;

begin
    cm2_delay : entity work.delay
        generic map(width => 1, length => 6)
        port map(
            clk       => clk,
            rst       => rst,
            input(0)  => ready,
            output(0) => cm2_valid_wire);

    ds2_delay : entity work.delay
        generic map(width => 1, length => 4)
        port map(
            clk       => clk,
            rst       => rst,
            input(0)  => cm2_valid_wire,
            output(0) => ds2_valid_wire);

    ds3_delay : entity work.delay
        generic map(width => 1, length => 3)
        port map(
            clk       => clk,
            rst       => rst,
            input(0)  => ds2_valid_wire,
            output(0) => ds3_valid_wire);

    out_delay : entity work.delay
        generic map(width => 1, length => 2)
        port map(
            clk       => clk,
            rst       => rst,
            input(0)  => ds3_valid_wire,
            output(0) => output_valid);

    cm2_valid <= cm2_valid_wire;
    ds2_valid <= ds2_valid_wire;
    ds3_valid <= ds3_valid_wire;

end STR;