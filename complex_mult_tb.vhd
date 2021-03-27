library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity complex_mult_tb is
end;

architecture TB of complex_mult_tb is

    -- Clock period
    constant clk_period : time := 10 ns;
    -- Generics
    constant width : positive := 16;

    -- Ports
    signal clk         : std_logic := '0';
    signal dataa_real  : std_logic_vector(width - 1 downto 0);
    signal dataa_imag  : std_logic_vector(width - 1 downto 0);
    signal datab_real  : std_logic_vector(width - 1 downto 0);
    signal datab_imag  : std_logic_vector(width - 1 downto 0);
    signal result_real : std_logic_vector((width * 2) - 1 downto 0);
    signal result_imag : std_logic_vector((width * 2) - 1 downto 0);

    signal sim_done : std_logic := '0';

begin

    -- toggle clock
    clk <= not clk after clk_period when sim_done = '0' else -- it may be better to manually toggle the clock?
    clk;

    complex_mult_inst : entity work.complex_mult
        generic map(
            width => width
        )
        port map(
            clock       => clk,
            dataa_real  => dataa_real,
            dataa_imag  => dataa_imag,
            datab_real  => datab_real,
            datab_imag  => datab_imag,
            result_real => result_real,
            result_imag => result_imag
        );

    process

        variable expected_real, expected_imag : integer;

    begin

        -- (1 + 2i) * (3 + 4i) = -5 + 10i
        dataa_real <= std_logic_vector(to_signed(1, dataa_real'length));
        dataa_imag <= std_logic_vector(to_signed(2, dataa_imag'length));
        datab_real <= std_logic_vector(to_signed(3, datab_real'length));
        datab_imag <= std_logic_vector(to_signed(4, datab_imag'length));

        for i in 0 to 3 loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_real := (-5);
        expected_imag := 10;

        assert result_real = std_logic_vector(to_signed(expected_real, result_real'length)) report "unexpected value. expected_real = " & integer'image(expected_real) & ", result_real = " & integer'image(to_integer(signed(result_real)));
        assert result_imag = std_logic_vector(to_signed(expected_imag, result_imag'length)) report "unexpected value. expected_imag = " & integer'image(expected_imag) & ", result_imag = " & integer'image(to_integer(signed(result_imag)));

        -- (69 + 420i) * (1337 + 8008i) = -3271107 + 1114092i
        dataa_real <= std_logic_vector(to_signed(69, dataa_real'length));
        dataa_imag <= std_logic_vector(to_signed(420, dataa_imag'length));
        datab_real <= std_logic_vector(to_signed(1337, datab_real'length));
        datab_imag <= std_logic_vector(to_signed(8008, datab_imag'length));

        for i in 0 to 3 loop
            wait until rising_edge(clk);
        end loop; -- i

        expected_real := (-3271107);
        expected_imag := 1114092;

        assert result_real = std_logic_vector(to_signed(expected_real, result_real'length)) report "unexpected value. expected_real = " & integer'image(expected_real) & ", result_real = " & integer'image(to_integer(signed(result_real)));
        assert result_imag = std_logic_vector(to_signed(expected_imag, result_imag'length)) report "unexpected value. expected_imag = " & integer'image(expected_imag) & ", result_imag = " & integer'image(to_integer(signed(result_imag)));

        sim_done <= '1';
        report "SIMULATION FINISHED!!!";

    end process;
end TB;