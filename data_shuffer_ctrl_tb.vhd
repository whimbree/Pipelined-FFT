library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_shuffler_ctrl_tb is
end data_shuffler_ctrl_tb;

architecture TB of data_shuffler_ctrl_tb is

    -- Clock period
    constant clk_period : time := 10 ns;
    -- Generics
    constant pulse_length : positive := 1;

    -- Ports
    signal clk         : std_logic := '0';
    signal rst         : std_logic;
    signal en          : std_logic := '1';
    signal input_valid : std_logic;
    signal ds_select   : std_logic;

    signal sim_done : std_logic := '0';

begin

    -- toggle clock
    clk <= not clk after clk_period when sim_done = '0' else
        clk;

    UUT : entity work.data_shuffler_ctrl
        generic map(
            pulse_length => pulse_length)
        port map(
            clk         => clk,
            rst         => rst,
            en          => en,
            input_valid => input_valid,
            ds_select   => ds_select);

    process

        variable expected_ds_select : std_logic;

    begin
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);

        input_valid <= '0';

        for i in 0 to pulse_length loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_ds_select := '0';

        assert ds_select = expected_ds_select report "unexpected value. expected_ds_select = " & std_logic'image(expected_ds_select) & ", ds_select = " & std_logic'image(ds_select);

        wait until rising_edge(clk);

        input_valid <= '1';

        for i in 0 to pulse_length - 1 loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_ds_select := '1';

        assert ds_select = expected_ds_select report "unexpected value. expected_ds_select = " & std_logic'image(expected_ds_select) & ", ds_select = " & std_logic'image(ds_select);

        for i in 0 to pulse_length - 1 loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_ds_select := '0';

        assert ds_select = expected_ds_select report "unexpected value. expected_ds_select = " & std_logic'image(expected_ds_select) & ", ds_select = " & std_logic'image(ds_select);

        for i in 0 to pulse_length - 1 loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_ds_select := '1';

        assert ds_select = expected_ds_select report "unexpected value. expected_ds_select = " & std_logic'image(expected_ds_select) & ", ds_select = " & std_logic'image(ds_select);

        sim_done <= '1';
        report "SIMULATION FINISHED!!!";

    end process;

end TB;