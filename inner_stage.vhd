library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity inner_stage is

    generic (
        num_stage_pairs : positive := 1;
        width           : positive := DATA_WIDTH);
    port (
        clk : in std_logic;
        rst : in std_logic;

        input_valid  : in std_logic;
        output_valid : out std_logic;

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end inner_stage;

architecture STR of inner_stage is

    signal front_stage_r0_output, front_stage_r1_output, front_stage_r2_output, front_stage_r3_output : std_logic_vector(width - 1 downto 0);
    signal front_stage_i0_output, front_stage_i1_output, front_stage_i2_output, front_stage_i3_output : std_logic_vector(width - 1 downto 0);
    signal front_stage_output_valid                                                                   : std_logic;

begin

    BASE_CASE : if (num_stage_pairs = 1) generate
        U_BASE_INNER_STAGE : entity work.base_inner_stage
            generic map(
                rot_length => 4,
                ds_length  => 2,
                width      => DATA_WIDTH)
            port map(
                clk => clk,
                rst => rst,

                input_valid  => input_valid,
                output_valid => output_valid,

                r0_input  => r0_input,
                r1_input  => r1_input,
                r2_input  => r2_input,
                r3_input  => r3_input,
                i0_input  => i0_input,
                i1_input  => i1_input,
                i2_input  => i2_input,
                i3_input  => i3_input,
                r0_output => r0_output,
                r1_output => r1_output,
                r2_output => r2_output,
                r3_output => r3_output,
                i0_output => i0_output,
                i1_output => i1_output,
                i2_output => i2_output,
                i3_output => i3_output);
    end generate BASE_CASE;

    RECURSIVE_CASE : if (num_stage_pairs /= 1) generate

        NEW_INNER_STAGE : entity work.base_inner_stage
            generic map(
                rot_length => 4 ** num_stage_pairs,
                ds_length  => (4 ** num_stage_pairs) / 2,
                width      => DATA_WIDTH)
            port map(
                clk => clk,
                rst => rst,

                input_valid  => input_valid,
                output_valid => front_stage_output_valid,

                r0_input  => r0_input,
                r1_input  => r1_input,
                r2_input  => r2_input,
                r3_input  => r3_input,
                i0_input  => i0_input,
                i1_input  => i1_input,
                i2_input  => i2_input,
                i3_input  => i3_input,
                r0_output => front_stage_r0_output,
                r1_output => front_stage_r1_output,
                r2_output => front_stage_r2_output,
                r3_output => front_stage_r3_output,
                i0_output => front_stage_i0_output,
                i1_output => front_stage_i1_output,
                i2_output => front_stage_i2_output,
                i3_output => front_stage_i3_output);

        RECURSIVE_INNER_STAGE : entity work.inner_stage
            generic map(
                num_stage_pairs => num_stage_pairs - 1,
                width           => DATA_WIDTH)
            port map(
                clk => clk,
                rst => rst,

                input_valid  => front_stage_output_valid,
                output_valid => output_valid,

                r0_input  => front_stage_r0_output,
                r1_input  => front_stage_r1_output,
                r2_input  => front_stage_r2_output,
                r3_input  => front_stage_r3_output,
                i0_input  => front_stage_i0_output,
                i1_input  => front_stage_i1_output,
                i2_input  => front_stage_i2_output,
                i3_input  => front_stage_i3_output,
                r0_output => r0_output,
                r1_output => r1_output,
                r2_output => r2_output,
                r3_output => r3_output,
                i0_output => i0_output,
                i1_output => i1_output,
                i2_output => i2_output,
                i3_output => i3_output);

    end generate RECURSIVE_CASE;

end STR;