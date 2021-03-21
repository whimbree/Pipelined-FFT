library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is

    generic (
        width : positive := 16);
    port (
        clk : in std_logic;
        rst : in std_logic;

        tg0_select, tg1_select, tg2_select : in std_logic_vector(1 downto 0);

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end top_level;

architecture BHV of top_level is
begin

    process (clk, rst)
    begin

    end process;

    datapath : entity work.datapath
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            tg0_select => tg1_select,
            tg1_select => tg1_select,
            tg2_select => tg2_select,

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

end BHV;