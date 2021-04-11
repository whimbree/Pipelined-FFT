library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity last_stage is

    generic (
        width : positive := DATA_WIDTH);
    port (
        clk : in std_logic;
        rst : in std_logic;

        input_valid  : in std_logic;
        output_valid : out std_logic;

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end last_stage;

architecture STR of last_stage is

begin

    b_0_0 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            input_0_real => r0_input,
            input_0_img  => i0_input,
            input_1_real => r1_input,
            input_1_img  => i1_input,

            output_0_real => r0_output,
            output_0_img  => i0_output,
            output_1_real => r1_output,
            output_1_img  => i1_output);

    b_0_1 : entity work.butterfly(STR)
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            input_0_real => r2_input,
            input_0_img  => i2_input,
            input_1_real => r3_input,
            input_1_img  => i3_input,

            output_0_real => r2_output,
            output_0_img  => i2_output,
            output_1_real => r3_output,
            output_1_img  => i3_output);

    stage_delay : entity work.delay
        generic map(width => 1, length => 1)
        port map(
            clk       => clk,
            rst       => rst,
            input(0)  => input_valid,
            output(0) => output_valid);

end STR;