library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

-- NOTES ON PARAMETERIZATION
-- first and last stage is always the same
-- middle stages come in pairs of two
-- ex: if we want a 16 point fft, we need 2^n = 4 stages
-- this is the trivial case
-- for higher point ffts, we might want to generate the internal pipeline
-- recursively, and then connect it to the first and last stage
-- this will greatly simplify the logic of the for generate required

-- we might not want to split up the stages so much,
-- having the middle 2 stages as their own component would be preferred I think

entity datapath is

    generic (
        num_internal_stage_pairs : positive := 1;
        width                    : positive := 32);
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

end datapath;

architecture STR of datapath is

    signal first_stage_r0_output, first_stage_r1_output, first_stage_r2_output, first_stage_r3_output : std_logic_vector(width - 1 downto 0);
    signal first_stage_i0_output, first_stage_i1_output, first_stage_i2_output, first_stage_i3_output : std_logic_vector(width - 1 downto 0);
    signal first_stage_output_valid                                                                   : std_logic;

    signal inner_stage_r0_output, inner_stage_r1_output, inner_stage_r2_output, inner_stage_r3_output : std_logic_vector(width - 1 downto 0);
    signal inner_stage_i0_output, inner_stage_i1_output, inner_stage_i2_output, inner_stage_i3_output : std_logic_vector(width - 1 downto 0);
    signal inner_stage_output_valid                                                                   : std_logic;

begin

    first_stage : entity work.first_stage
        generic map(
            width => DATA_WIDTH
        )
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_valid  => input_valid,
            output_valid => first_stage_output_valid,

            r0_input  => r0_input,
            r1_input  => r1_input,
            r2_input  => r2_input,
            r3_input  => r3_input,
            i0_input  => i0_input,
            i1_input  => i1_input,
            i2_input  => i2_input,
            i3_input  => i3_input,
            r0_output => first_stage_r0_output,
            r1_output => first_stage_r1_output,
            r2_output => first_stage_r2_output,
            r3_output => first_stage_r3_output,
            i0_output => first_stage_i0_output,
            i1_output => first_stage_i1_output,
            i2_output => first_stage_i2_output,
            i3_output => first_stage_i3_output);

    inner_stage : entity work.inner_stage
        generic map(
            num_stage_pairs => num_internal_stage_pairs,
            width           => DATA_WIDTH
        )
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_valid  => first_stage_output_valid,
            output_valid => inner_stage_output_valid,

            r0_input  => first_stage_r0_output,
            r1_input  => first_stage_r1_output,
            r2_input  => first_stage_r2_output,
            r3_input  => first_stage_r3_output,
            i0_input  => first_stage_i0_output,
            i1_input  => first_stage_i1_output,
            i2_input  => first_stage_i2_output,
            i3_input  => first_stage_i3_output,
            r0_output => inner_stage_r0_output,
            r1_output => inner_stage_r1_output,
            r2_output => inner_stage_r2_output,
            r3_output => inner_stage_r3_output,
            i0_output => inner_stage_i0_output,
            i1_output => inner_stage_i1_output,
            i2_output => inner_stage_i2_output,
            i3_output => inner_stage_i3_output);

    last_stage : entity work.last_stage
        generic map(
            width => DATA_WIDTH
        )
        port map(
            clk => clk,
            rst => rst,
            en  => en,

            input_valid  => inner_stage_output_valid,
            output_valid => output_valid,

            r0_input  => inner_stage_r0_output,
            r1_input  => inner_stage_r1_output,
            r2_input  => inner_stage_r2_output,
            r3_input  => inner_stage_r3_output,
            i0_input  => inner_stage_i0_output,
            i1_input  => inner_stage_i1_output,
            i2_input  => inner_stage_i2_output,
            i3_input  => inner_stage_i3_output,
            r0_output => r0_output,
            r1_output => r1_output,
            r2_output => r2_output,
            r3_output => r3_output,
            i0_output => i0_output,
            i1_output => i1_output,
            i2_output => i2_output,
            i3_output => i3_output);

end STR;