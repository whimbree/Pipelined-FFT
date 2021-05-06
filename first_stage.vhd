library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity first_stage is

    generic (
        width : positive := DATA_WIDTH);
    port (
        clk : in std_logic;
        rst : in std_logic;
        en  : in std_logic;

        input_valid  : in std_logic;
        output_valid : out std_logic;

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end first_stage;

architecture STR of first_stage is

    signal b_0_0_out_0_real, b_0_0_out_0_img, b_0_0_out_1_real, b_0_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_0_0_db_out_0_real, b_0_0_db_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_0_0_db_out_1_real, b_0_0_db_out_1_img                              : std_logic_vector(width - 1 downto 0);

    signal b_0_1_out_0_real, b_0_1_out_0_img, b_0_1_out_1_real, b_0_1_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_0_1_tm_out_1_real_2x, b_0_1_tm_out_1_img_2x                        : std_logic_vector((width * 2) - 1 downto 0);
    alias b_0_1_tm_out_1_real is b_0_1_tm_out_1_real_2x((width * 2) - 2 downto width - 1);
    alias b_0_1_tm_out_1_img is b_0_1_tm_out_1_img_2x((width * 2) - 2 downto width - 1);

begin

    b_0_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_0_real => r0_input,
            input_0_img  => i0_input,
            input_1_real => r1_input,
            input_1_img  => i1_input,

            output_0_real => b_0_0_out_0_real,
            output_0_img  => b_0_0_out_0_img,
            output_1_real => b_0_0_out_1_real,
            output_1_img  => b_0_0_out_1_img);

    b_0_1 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_0_real => r2_input,
            input_0_img  => i2_input,
            input_1_real => r3_input,
            input_1_img  => i3_input,

            output_0_real => b_0_1_out_0_real,
            output_0_img  => b_0_1_out_0_img,
            output_1_real => b_0_1_out_1_real,
            output_1_img  => b_0_1_out_1_img);

    tm_0 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            dataa_real => b_0_1_out_1_real,
            dataa_imag => b_0_1_out_1_img,
            datab_real => ZERO,
            datab_imag => NEGATIVE_ONE,

            result_real => b_0_1_tm_out_1_real_2x,
            result_imag => b_0_1_tm_out_1_img_2x);

    r3_output <= b_0_1_tm_out_1_real;
    i3_output <= b_0_1_tm_out_1_img;

    db_0 : entity work.pipe_reg
        generic map(
            length => 3,
            width  => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_real  => b_0_0_out_0_real,
            input_img   => b_0_0_out_0_img,
            output_real => r0_output,
            output_img  => i0_output);

    db_1 : entity work.pipe_reg
        generic map(
            length => 3,
            width  => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_real  => b_0_0_out_1_real,
            input_img   => b_0_0_out_1_img,
            output_real => r2_output,
            output_img  => i2_output);

    db_2 : entity work.pipe_reg
        generic map(
            length => 3,
            width  => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_real  => b_0_1_out_0_real,
            input_img   => b_0_1_out_0_img,
            output_real => r1_output,
            output_img  => i1_output);

    stage_delay : entity work.delay
        generic map(width => 1, length => 4)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input(0)  => input_valid,
            output(0) => output_valid);

end STR;