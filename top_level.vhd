library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity top_level is

    generic (
        num_internal_stage_pairs : positive := 1;
        width                    : positive := DATA_WIDTH);
    port (
        clk : in std_logic;
        rst : in std_logic;

        done : out std_logic;
        go   : in std_logic;
        size : in std_logic_vector(31 downto 0);

        valid_output : out std_logic;

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end top_level;

architecture STR of top_level is

    signal input_valid, output_valid : std_logic;

begin

    valid_output <= output_valid;

    controller : entity work.controller
        port map(
            clk => clk,
            rst => rst,

            go   => go,
            size => size,
            done => done,

            valid_start => input_valid,

            valid_end => output_valid);

    datapath : entity work.datapath
        generic map(
            num_internal_stage_pairs => num_internal_stage_pairs,
            width                    => width)
        port map(
            clk => clk,
            rst => rst,

            input_valid  => input_valid,
            output_valid => output_valid,

            r0_input => r0_input,
            i0_input => i0_input,

            r1_input => r1_input,
            i1_input => i1_input,

            r2_input => r2_input,
            i2_input => i2_input,

            r3_input => r3_input,
            i3_input => i3_input,

            r0_output => r0_output,
            i0_output => i0_output,

            r1_output => r1_output,
            i1_output => i1_output,

            r2_output => r2_output,
            i2_output => i2_output,

            r3_output => r3_output,
            i3_output => i3_output);

end STR;