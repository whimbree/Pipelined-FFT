library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity base_inner_stage is

    generic (
        rot_length                 : positive := 4;
        ds_length                  : positive := 2;
        twiddle_idx_shift_left_amt : natural  := 0;
        width                      : positive := DATA_WIDTH);
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

end base_inner_stage;

architecture STR of base_inner_stage is

    -- Stage 1
    signal b_1_0_out_0_real, b_1_0_out_0_img, b_1_0_out_1_real, b_1_0_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_1_0_db_out_0_real, b_1_0_db_out_0_img                              : std_logic_vector(width - 1 downto 0);
    signal b_1_0_cm_out_1_real_2x, b_1_0_cm_out_1_img_2x                        : std_logic_vector((width * 2) - 1 downto 0);
    alias b_1_0_cm_out_1_real is b_1_0_cm_out_1_real_2x((width * 2) - 2 downto width - 1);
    alias b_1_0_cm_out_1_img is b_1_0_cm_out_1_img_2x((width * 2) - 2 downto width - 1);

    signal b_1_0_ds_out_0_real, b_1_0_ds_out_0_img : std_logic_vector(width - 1 downto 0);
    signal b_1_0_ds_out_1_real, b_1_0_ds_out_1_img : std_logic_vector(width - 1 downto 0);
    signal ts0_real, ts0_imag                      : std_logic_vector(DATA_RANGE);

    signal b_1_1_out_0_real, b_1_1_out_0_img, b_1_1_out_1_real, b_1_1_out_1_img : std_logic_vector(width - 1 downto 0);
    signal b_1_1_cm_out_0_real_2x, b_1_1_cm_out_0_img_2x                        : std_logic_vector((width * 2) - 1 downto 0);
    alias b_1_1_cm_out_0_real is b_1_1_cm_out_0_real_2x((width * 2) - 2 downto width - 1);
    alias b_1_1_cm_out_0_img is b_1_1_cm_out_0_img_2x((width * 2) - 2 downto width - 1);

    signal b_1_1_cm_out_1_real_2x, b_1_1_cm_out_1_img_2x : std_logic_vector((width * 2) - 1 downto 0);
    alias b_1_1_cm_out_1_real is b_1_1_cm_out_1_real_2x((width * 2) - 2 downto width - 1);
    alias b_1_1_cm_out_1_img is b_1_1_cm_out_1_img_2x((width * 2) - 2 downto width - 1);

    signal b_1_1_ds_out_0_real, b_1_1_ds_out_0_img : std_logic_vector(width - 1 downto 0);
    signal b_1_1_ds_out_1_real, b_1_1_ds_out_1_img : std_logic_vector(width - 1 downto 0);
    signal ts1_real, ts1_imag                      : std_logic_vector(DATA_RANGE);
    signal ts2_real, ts2_imag                      : std_logic_vector(DATA_RANGE);

    signal cm_valid, ds_0_valid, ds_1_valid : std_logic;
    signal ds_0_select, ds_1_select         : std_logic;

    -- Stage 2
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

    ------------------------------------------------------------------------------------------------------------
    ---------------------------------------------  STAGE 1  ----------------------------------------------------
    ------------------------------------------------------------------------------------------------------------

    b_1_0 : entity work.butterfly(STR)
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

            output_0_real => b_1_0_out_0_real,
            output_0_img  => b_1_0_out_0_img,
            output_1_real => b_1_0_out_1_real,
            output_1_img  => b_1_0_out_1_img);

    b_1_1 : entity work.butterfly(STR)
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

            output_0_real => b_1_1_out_0_real,
            output_0_img  => b_1_1_out_0_img,
            output_1_real => b_1_1_out_1_real,
            output_1_img  => b_1_1_out_1_img);

    ts_0 : entity work.twiddle_sel
        generic map(
            len_sequence       => rot_length,
            increment_amt      => 2,
            idx_shift_left_amt => twiddle_idx_shift_left_amt)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            count_en     => cm_valid,
            twiddle_real => ts0_real,
            twiddle_imag => ts0_imag);

    ts_1 : entity work.twiddle_sel
        generic map(
            len_sequence       => rot_length,
            increment_amt      => 1,
            idx_shift_left_amt => twiddle_idx_shift_left_amt)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            count_en     => cm_valid,
            twiddle_real => ts1_real,
            twiddle_imag => ts1_imag);

    ts_2 : entity work.twiddle_sel
        generic map(
            len_sequence       => rot_length,
            increment_amt      => 3,
            idx_shift_left_amt => twiddle_idx_shift_left_amt)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            count_en     => cm_valid,
            twiddle_real => ts2_real,
            twiddle_imag => ts2_imag);

    cm_0 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            dataa_real => b_1_0_out_1_real,
            dataa_imag => b_1_0_out_1_img,
            datab_real => ts0_real,
            datab_imag => ts0_imag,

            result_real => b_1_0_cm_out_1_real_2x,
            result_imag => b_1_0_cm_out_1_img_2x);

    cm_1 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            dataa_real => b_1_1_out_0_real,
            dataa_imag => b_1_1_out_0_img,
            datab_real => ts1_real,
            datab_imag => ts1_imag,

            result_real => b_1_1_cm_out_0_real_2x,
            result_imag => b_1_1_cm_out_0_img_2x);

    cm_2 : entity work.complex_mult(BHV_PIPELINED)
        generic map(width => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            dataa_real => b_1_1_out_1_real,
            dataa_imag => b_1_1_out_1_img,
            datab_real => ts2_real,
            datab_imag => ts2_imag,

            result_real => b_1_1_cm_out_1_real_2x,
            result_imag => b_1_1_cm_out_1_img_2x);

    db_3 : entity work.pipe_reg
        generic map(
            length => 3,
            width  => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_real  => b_1_0_out_0_real,
            input_img   => b_1_0_out_0_img,
            output_real => b_1_0_db_out_0_real,
            output_img  => b_1_0_db_out_0_img);

    ds_ctrl_0 : entity work.data_shuffler_ctrl
        generic map(pulse_length => ds_length)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_valid => ds_0_valid,
            ds_select   => ds_0_select);

    ds_0_0 : entity work.data_shuffler
        generic map(
            delay_length => ds_length,
            width        => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            mux_select => ds_0_select,

            input_0_real => b_1_0_db_out_0_real,
            input_0_img  => b_1_0_db_out_0_img,
            input_1_real => b_1_1_cm_out_0_real,
            input_1_img  => b_1_1_cm_out_0_img,

            output_0_real => b_1_0_ds_out_0_real,
            output_0_img  => b_1_0_ds_out_0_img,
            output_1_real => b_1_0_ds_out_1_real,
            output_1_img  => b_1_0_ds_out_1_img);

    ds_0_1 : entity work.data_shuffler
        generic map(
            delay_length => ds_length,
            width        => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            mux_select => ds_0_select,

            input_0_real => b_1_0_cm_out_1_real,
            input_0_img  => b_1_0_cm_out_1_img,
            input_1_real => b_1_1_cm_out_1_real,
            input_1_img  => b_1_1_cm_out_1_img,

            output_0_real => b_1_1_ds_out_0_real,
            output_0_img  => b_1_1_ds_out_0_img,
            output_1_real => b_1_1_ds_out_1_real,
            output_1_img  => b_1_1_ds_out_1_img);

    cm_delay : entity work.delay
        generic map(width => 1, length => 1)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input(0)  => input_valid,
            output(0) => cm_valid);

    ds_0_delay : entity work.delay
        generic map(width => 1, length => 3)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input(0)  => cm_valid,
            output(0) => ds_0_valid);

    ds_1_delay : entity work.delay
        generic map(width => 1, length => ds_length + 1)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input(0)  => ds_0_valid,
            output(0) => ds_1_valid);

    output_delay : entity work.delay
        generic map(width => 1, length => (ds_length / 2) + 3)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input(0)  => ds_1_valid,
            output(0) => output_valid);

    ------------------------------------------------------------------------------------------------------------
    ---------------------------------------------  STAGE 2  ----------------------------------------------------
    ------------------------------------------------------------------------------------------------------------

    b_2_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_0_real => b_1_0_ds_out_0_real,
            input_0_img  => b_1_0_ds_out_0_img,
            input_1_real => b_1_0_ds_out_1_real,
            input_1_img  => b_1_0_ds_out_1_img,

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
            en  => en,

            input_0_real => b_1_1_ds_out_0_real,
            input_0_img  => b_1_1_ds_out_0_img,
            input_1_real => b_1_1_ds_out_1_real,
            input_1_img  => b_1_1_ds_out_1_img,

            output_0_real => b_2_1_out_0_real,
            output_0_img  => b_2_1_out_0_img,
            output_1_real => b_2_1_out_1_real,
            output_1_img  => b_2_1_out_1_img);

    ds_ctrl_1 : entity work.data_shuffler_ctrl
        generic map(pulse_length => ds_length / 2)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_valid => ds_1_valid,
            ds_select   => ds_1_select);

    ds_1_0 : entity work.data_shuffler
        generic map(
            delay_length => ds_length / 2,
            width        => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            mux_select => ds_1_select,

            input_0_real => b_2_0_out_0_real,
            input_0_img  => b_2_0_out_0_img,
            input_1_real => b_2_1_out_0_real,
            input_1_img  => b_2_1_out_0_img,

            output_0_real => b_2_0_ds_out_0_real,
            output_0_img  => b_2_0_ds_out_0_img,
            output_1_real => b_2_0_ds_out_1_real,
            output_1_img  => b_2_0_ds_out_1_img);

    ds_1_1 : entity work.data_shuffler
        generic map(
            delay_length => ds_length / 2,
            width        => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            mux_select => ds_1_select,

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
            clk => clk,
            rst => rst,
            en  => en,

            dataa_real => b_2_1_ds_out_1_real,
            dataa_imag => b_2_1_ds_out_1_img,
            datab_real => ZERO,
            datab_imag => NEGATIVE_ONE,

            result_real => b_2_1_tm_out_1_real_2x,
            result_imag => b_2_1_tm_out_1_img_2x);

    r3_output <= b_2_1_tm_out_1_real;
    i3_output <= b_2_1_tm_out_1_img;

    db_4 : entity work.pipe_reg
        generic map(
            length => 3,
            width  => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_real  => b_2_0_ds_out_0_real,
            input_img   => b_2_0_ds_out_0_img,
            output_real => r0_output,
            output_img  => i0_output);

    db_5 : entity work.pipe_reg
        generic map(
            length => 3,
            width  => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_real  => b_2_0_ds_out_1_real,
            input_img   => b_2_0_ds_out_1_img,
            output_real => r1_output,
            output_img  => i1_output);

    db_6 : entity work.pipe_reg
        generic map(
            length => 3,
            width  => width)
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_real  => b_2_1_ds_out_0_real,
            input_img   => b_2_1_ds_out_0_img,
            output_real => r2_output,
            output_img  => i2_output);

end STR;