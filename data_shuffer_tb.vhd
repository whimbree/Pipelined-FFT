library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_shuffler_tb is
end;

architecture TB of data_shuffler_tb is

    -- Clock period
    constant clk_period : time := 10 ns;
    -- Generics
    constant delay_length : positive := 5;
    constant width        : positive := 16;

    -- Ports
    signal clk           : std_logic := '0';
    signal rst           : std_logic;
    signal en            : std_logic := '1';
    signal mux_select    : std_logic;
    signal input_0_real  : std_logic_vector(width - 1 downto 0);
    signal input_0_img   : std_logic_vector(width - 1 downto 0);
    signal input_1_real  : std_logic_vector(width - 1 downto 0);
    signal input_1_img   : std_logic_vector(width - 1 downto 0);
    signal output_0_real : std_logic_vector(width - 1 downto 0);
    signal output_0_img  : std_logic_vector(width - 1 downto 0);
    signal output_1_real : std_logic_vector(width - 1 downto 0);
    signal output_1_img  : std_logic_vector(width - 1 downto 0);

    signal sim_done : std_logic := '0';

begin

    -- toggle clock
    clk <= not clk after clk_period when sim_done = '0' else
        clk;

    UUT : entity work.data_shuffler
        generic map(
            delay_length => delay_length,
            width        => width
        )
        port map(
            clk           => clk,
            rst           => rst,
            en            => en,
            mux_select    => mux_select,
            input_0_real  => input_0_real,
            input_0_img   => input_0_img,
            input_1_real  => input_1_real,
            input_1_img   => input_1_img,
            output_0_real => output_0_real,
            output_0_img  => output_0_img,
            output_1_real => output_1_real,
            output_1_img  => output_1_img);

    process

        variable expected_output_0_real, expected_output_0_img : integer;
        variable expected_output_1_real, expected_output_1_img : integer;

    begin

        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);

        ---
        input_0_real <= std_logic_vector(to_signed(1, input_0_real'length));
        input_0_img  <= std_logic_vector(to_signed(2, input_0_img'length));
        input_1_real <= std_logic_vector(to_signed(3, input_1_real'length));
        input_1_img  <= std_logic_vector(to_signed(4, input_1_img'length));
        mux_select   <= '0';

        for i in 0 to delay_length loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_output_0_real := 1;
        expected_output_0_img  := 2;
        expected_output_1_real := 3;
        expected_output_1_img  := 4;

        assert output_0_real = std_logic_vector(to_signed(expected_output_0_real, output_0_real'length)) report "unexpected value. expected_output_0_real = " & integer'image(expected_output_0_real) & ", output_0_real = " & integer'image(to_integer(signed(output_0_real)));
        assert output_0_img = std_logic_vector(to_signed(expected_output_0_img, output_0_img'length)) report "unexpected value. expected_output_0_img = " & integer'image(expected_output_0_img) & ", output_0_img = " & integer'image(to_integer(signed(output_0_img)));
        assert output_1_real = std_logic_vector(to_signed(expected_output_1_real, output_1_real'length)) report "unexpected value. expected_output_1_real = " & integer'image(expected_output_1_real) & ", output_1_real = " & integer'image(to_integer(signed(output_1_real)));
        assert output_1_img = std_logic_vector(to_signed(expected_output_1_img, output_1_img'length)) report "unexpected value. expected_output_1_img = " & integer'image(expected_output_1_img) & ", output_1_img = " & integer'image(to_integer(signed(output_1_img)));

        wait until rising_edge(clk);

        ---
        input_0_real <= std_logic_vector(to_signed(3, input_0_real'length));
        input_0_img  <= std_logic_vector(to_signed(6, input_0_img'length));
        input_1_real <= std_logic_vector(to_signed(9, input_1_real'length));
        input_1_img  <= std_logic_vector(to_signed(12, input_1_img'length));
        mux_select   <= '1';

        for i in 0 to 2 * delay_length loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_output_0_real := 9;
        expected_output_0_img  := 12;
        expected_output_1_real := 3;
        expected_output_1_img  := 6;

        assert output_0_real = std_logic_vector(to_signed(expected_output_0_real, output_0_real'length)) report "unexpected value. expected_output_0_real = " & integer'image(expected_output_0_real) & ", output_0_real = " & integer'image(to_integer(signed(output_0_real)));
        assert output_0_img = std_logic_vector(to_signed(expected_output_0_img, output_0_img'length)) report "unexpected value. expected_output_0_img = " & integer'image(expected_output_0_img) & ", output_0_img = " & integer'image(to_integer(signed(output_0_img)));
        assert output_1_real = std_logic_vector(to_signed(expected_output_1_real, output_1_real'length)) report "unexpected value. expected_output_1_real = " & integer'image(expected_output_1_real) & ", output_1_real = " & integer'image(to_integer(signed(output_1_real)));
        assert output_1_img = std_logic_vector(to_signed(expected_output_1_img, output_1_img'length)) report "unexpected value. expected_output_1_img = " & integer'image(expected_output_1_img) & ", output_1_img = " & integer'image(to_integer(signed(output_1_img)));

        sim_done <= '1';
        report "SIMULATION FINISHED!!!";

    end process;

end TB;