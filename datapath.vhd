library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is

    generic (
        width : positive := 16);
    port (
        clk : in std_logic;
        rst : in std_logic;

        r_input  : in S_WIDTH(3 downto 0);
        i_input  : in S_WIDTH(3 downto 0);
        r_output : in S_WIDTH(3 downto 0);
        i_output : out S_WIDTH(3 downto 0)
    );

    type S_WIDTH is array (integer range <>) of std_logic_vector(width - 1 downto 0);

end datapath;

architecture STR of datapath is

    signal b_0_0_out_0_real, b_0_0_out_0_img, b_0_0_out_1_real, b_0_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_1_0_out_0_real, b_1_0_out_0_img, b_1_0_out_1_real, b_1_0_out_1_img : std_logic_vector(width - 1 downto 0);
begin

    -- butterfly naming convention b_x_y
    -- where x is the number
    -- and y is the stage

    b_0_0 : entity work.butterfly
        generic map(
            width => width
        )
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => r_input(0),
            input_0_img  => i_input(0),
            input_1_real => r_input(1),
            input_1_img  => i_input(1),

            output_0_real => b_0_0_out_0_real,
            output_0_img  => b_0_0_out_0_img,
            output_1_real => b_0_0_out_1_real,
            output_1_img  => b_0_0_out_1_img);

    b_1_0 : entity work.butterfly
        generic map(
            width => width
        )
        port map(
            clk => clk,
            rst => rst,

            twiddle_real => (others => '0'),
            twiddle_img => (others => '0'),

            input_0_real => r_input(0),
            input_0_img  => i_input(0),
            input_1_real => r_input(1),
            input_1_img  => i_input(1),

            output_0_real => b_1_0_out_0_real,
            output_0_img  => b_1_0_out_0_img,
            output_1_real => b_1_0_out_1_real,
            output_1_img  => b_1_0_out_1_img);

end STR;