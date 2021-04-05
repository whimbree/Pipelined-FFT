library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity odd_stage is

    generic (
        width       : positive := 16;
        delayLength : positive := 2;
        multLength  : positive := 4);
    port (
        clk : in std_logic;
        rst : in std_logic;

        tg0_select, tg1_select, tg2_select : in std_logic_vector(1 downto 0);

        ds_0_select, ds_1_select, ds_2_select, ds_3_select : in std_logic;

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end odd_stage;

architecture STR of odd_stage is

    signal b_2_0_out_0_real, b_2_0_out_0_img, b_2_0_out_1_real, b_2_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_2_0_ds_out_0_real, b_2_0_ds_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_0_ds_out_1_real, b_2_0_ds_out_1_img                              : std_logic_vector(width - 1 downto 0);

    signal b_2_1_out_0_real, b_2_1_out_0_img, b_2_1_out_1_real, b_2_1_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_2_1_ds_out_0_real, b_2_1_ds_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_1_ds_out_1_real, b_2_1_ds_out_1_img                              : std_logic_vector(width - 1 downto 0);
    signal b_2_1_tm_out_1_real_2x, b_2_1_tm_out_1_img_2x                        : std_logic_vector((width * 2) - 1 downto 0);
    alias b_2_1_tm_out_1_real is b_2_1_tm_out_1_real_2x((width * 2) - 2 downto width - 1);
    alias b_2_1_tm_out_1_img is b_2_1_tm_out_1_img_2x((width * 2) - 2 downto width - 1);

begin

    b_2_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            input_0_real => r0_input,
            input_0_img  => i0_input,
            input_1_real => r1_input,
            input_1_img  => i1_input,

            output_0_real => b_2_0_out_0_real,
            output_0_img  => b_2_0_out_0_img,
            output_1_real => b_2_0_out_1_real,
            output_1_img  => b_2_0_out_1_img);

    b_2_1 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            input_0_real => r2_input,
            input_0_img  => i2_input,
            input_1_real => r3_input,
            input_1_img  => i3_input,

            output_0_real => b_2_1_out_0_real,
            output_0_img  => b_2_1_out_0_img,
            output_1_real => b_2_1_out_1_real,
            output_1_img  => b_2_1_out_1_img);

    ds_2 : entity work.data_shuffler
        generic map(
            delay_length => 1,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => ds_2_select,

            input_0_real => b_2_0_out_0_real,
            input_0_img  => b_2_0_out_0_img,
            input_1_real => b_2_1_out_0_real,
            input_1_img  => b_2_1_out_0_img,

            output_0_real => b_2_0_ds_out_0_real,
            output_0_img  => b_2_0_ds_out_0_img,
            output_1_real => b_2_0_ds_out_1_real,
            output_1_img  => b_2_0_ds_out_1_img);

    ds_3 : entity work.data_shuffler
        generic map(
            delay_length => 1,
            width        => width)
        port map(
            clk => clk,
            rst => rst,

            mux_select => ds_3_select,

            input_0_real => b_2_0_out_1_real,
            input_0_img  => b_2_0_out_1_img,
            input_1_real => b_2_1_out_1_real,
            input_1_img  => b_2_1_out_1_img,

            output_0_real => b_2_1_ds_out_0_real,
            output_0_img  => b_2_1_ds_out_0_img,
            output_1_real => b_2_1_ds_out_1_real,
            output_1_img  => b_2_1_ds_out_1_img);

    tm_1 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clock      => clk,
            dataa_real => b_2_1_ds_out_1_real,
            dataa_imag => b_2_1_ds_out_1_img,
            datab_real => REAL_4,
            datab_imag => IMAG_4,

            result_real => b_2_1_tm_out_1_real_2x,
            result_imag => b_2_1_tm_out_1_img_2x);

    r3_output <= b_2_1_tm_out_1_real;
    i3_output <= b_2_1_tm_out_1_img;

    db_4 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_2_0_ds_out_0_real,
            input_img   => b_2_0_ds_out_0_img,
            output_real => r1_output,
            output_img  => i1_output);

    db_5 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_2_0_ds_out_1_real,
            input_img   => b_2_0_ds_out_1_img,
            output_real => r2_output,
            output_img  => i2_output);

    db_6 : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => b_2_1_ds_out_0_real,
            input_img   => b_2_1_ds_out_0_img,
            output_real => r3_output,
            output_img  => i3_output);
end STR;