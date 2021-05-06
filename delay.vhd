library ieee;
use ieee.std_logic_1164.all;

entity delay is

    generic (
        length : positive := 4;
        width  : positive := 8);
    port (
        clk : in std_logic;
        rst : in std_logic;
        en  : in std_logic;

        input : in std_logic_vector(width - 1 downto 0);

        output : out std_logic_vector(width - 1 downto 0));

end delay;

architecture STR of delay is

    type sig_array is array (0 to length) of std_logic_vector(width - 1 downto 0);
    signal sigs : sig_array;

begin

    DELAY :
    for I in 1 to length generate

        regx : entity work.reg
            generic map(width => width)
            port map(
                clk    => clk,
                rst    => rst,
                en     => en,
                input  => sigs(I - 1),
                output => sigs(I));

    end generate DELAY;

    sigs(0) <= input;
    output  <= sigs(length);

end STR;