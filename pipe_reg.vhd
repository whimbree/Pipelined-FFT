library ieee;
use ieee.std_logic_1164.all;

entity pipe_reg is

    generic (
        length : positive := 4;
        width  : positive := 8);
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        input_real  : in std_logic_vector(width - 1 downto 0);
        input_img   : in std_logic_vector(width - 1 downto 0);
        output_real : out std_logic_vector(width - 1 downto 0);
        output_img  : out std_logic_vector(width - 1 downto 0));

end pipe_reg;

architecture STR of pipe_reg is

    type sig_array is array (0 to length) of std_logic_vector(width - 1 downto 0);
    signal real_sigs : sig_array;
    signal img_sigs  : sig_array;

begin

    PIPE_DELAY :
    for I in 1 to length generate

        regx : entity work.complex_reg
            generic map(width => width)
            port map(
                clk         => clk,
                rst         => rst,
                input_real  => real_sigs(I - 1),
                input_img   => img_sigs(I - 1),
                output_real => real_sigs(I),
                output_img  => img_sigs(I));

    end generate PIPE_DELAY;

    real_sigs(0) <= input_real;
    img_sigs(0)  <= input_img;
    output_real  <= real_sigs(length);
    output_img   <= img_sigs(length);

end STR;