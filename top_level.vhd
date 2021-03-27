library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is

    generic (
        width : positive := 16);
    port (
        clk : in std_logic;
        rst : in std_logic;

        done : out std_logic;
        go   : in std_logic;
        size : in std_logic_vector(31 downto 0);

        r0_input, r1_input, r2_input, r3_input     : in std_logic_vector(width - 1 downto 0);
        i0_input, i1_input, i2_input, i3_input     : in std_logic_vector(width - 1 downto 0);
        r0_output, r1_output, r2_output, r3_output : out std_logic_vector(width - 1 downto 0);
        i0_output, i1_output, i2_output, i3_output : out std_logic_vector(width - 1 downto 0));

end top_level;

architecture STR of top_level is
    signal cm2_valid, ds2_valid, ds3_valid, output_valid : std_logic;
    signal theta_select                                  : std_logic_vector(1 downto 0);
    signal valid_start                                   : std_logic := '1';
    signal ds_2_select, ds_3_select                      : std_logic;

begin

    controller : entity work.controller
        port map(
            clk => clk,
            rst => rst,

            go   => go,
            size => size,
            done => done,

				valid_start => valid_start,
				
            cm_2_valid => cm2_valid,
            ds_2_valid => ds2_valid,
            ds_3_valid => ds3_valid,
            valid_end  => output_valid,

            theta_select_2 => theta_select,

            ds_select_2 => ds_2_select,
            ds_select_3 => ds_3_select);

    datapath : entity work.datapath
        generic map(
            width => width)
        port map(
            clk => clk,
            rst => rst,

            tg0_select => theta_select,
            tg1_select => theta_select,
            tg2_select => theta_select,

            ds_0_select => ds_2_select,
            ds_1_select => ds_2_select,
            ds_2_select => ds_3_select,
            ds_3_select => ds_3_select,

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

    datapath_delay : entity work.datapath_delay
        port map(
            clk   => clk,
            rst   => rst,
            input_valid => valid_start,

            cm2_valid    => cm2_valid,
            ds2_valid    => ds2_valid,
            ds3_valid    => ds3_valid,
            output_valid => output_valid);

end STR;