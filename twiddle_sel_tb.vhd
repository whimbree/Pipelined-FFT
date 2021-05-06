library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- twiddle factors array is stored here
use work.user_pkg.all;

entity twiddle_sel_tb is
end twiddle_sel_tb;

architecture TB of twiddle_sel_tb is

    -- Clock period
    constant clk_period : time := 10 ns;
    -- Generics
    constant len_sequence       : positive range 1 to 65535 := 4;
    constant increment_amt      : positive range 1 to 65535 := 3;
    constant idx_shift_left_amt : natural range 0 to 65535  := 2;

    -- Signals
    signal tb_count                                     : natural := 0;
    signal expected_index                               : natural := 0;
    signal expected_twiddle_real, expected_twiddle_imag : std_logic_vector(DATA_RANGE);

    -- Ports
    signal clk                        : std_logic := '0';
    signal rst                        : std_logic;
    signal en                         : std_logic := '1';
    signal count_en                   : std_logic;
    signal twiddle_real, twiddle_imag : std_logic_vector(DATA_RANGE);

    signal sim_done : std_logic := '0';

    -- https://stackoverflow.com/questions/15406887/vhdl-convert-vector-to-string
    function to_string (a : std_logic_vector) return string is
        variable b            : string (1 to a'length) := (others => NUL);
        variable stri         : integer                := 1;
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
            stri    := stri + 1;
        end loop;
        return b;
    end function;

begin

    -- toggle clock
    clk <= not clk after clk_period when sim_done = '0' else
        clk;

    UUT : entity work.twiddle_sel
        generic map(
            len_sequence       => len_sequence,
            increment_amt      => increment_amt,
            idx_shift_left_amt => idx_shift_left_amt)
        port map(
            clk          => clk,
            rst          => rst,
            en           => en,
            count_en     => count_en,
            twiddle_real => twiddle_real,
            twiddle_imag => twiddle_imag);

    process
    begin
        rst <= '1';
        wait until rising_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);

        count_en <= '1';

        expected_twiddle_real <= TWIDDLE_FACTORS_REAL(expected_index);
        expected_twiddle_imag <= TWIDDLE_FACTORS_IMAG(expected_index);
        tb_count              <= tb_count + increment_amt;
        expected_index        <= (tb_count + increment_amt) * (2 ** idx_shift_left_amt);

        wait until rising_edge(clk);

        assert twiddle_real = expected_twiddle_real report "unexpected value. expected_twiddle_real = " & to_string(expected_twiddle_real) & ", twiddle_real = " & to_string(twiddle_real);
        assert twiddle_imag = expected_twiddle_imag report "unexpected value. expected_twiddle_imag = " & to_string(expected_twiddle_imag) & ", twiddle_imag = " & to_string(twiddle_imag);

        expected_twiddle_real <= TWIDDLE_FACTORS_REAL(expected_index);
        expected_twiddle_imag <= TWIDDLE_FACTORS_IMAG(expected_index);
        tb_count              <= tb_count + increment_amt;
        expected_index        <= (tb_count + increment_amt) * (2 ** idx_shift_left_amt);

        wait until rising_edge(clk);

        assert twiddle_real = expected_twiddle_real report "unexpected value. expected_twiddle_real = " & to_string(expected_twiddle_real) & ", twiddle_real = " & to_string(twiddle_real);
        assert twiddle_imag = expected_twiddle_imag report "unexpected value. expected_twiddle_imag = " & to_string(expected_twiddle_imag) & ", twiddle_imag = " & to_string(twiddle_imag);

        expected_twiddle_real <= TWIDDLE_FACTORS_REAL(expected_index);
        expected_twiddle_imag <= TWIDDLE_FACTORS_IMAG(expected_index);
        tb_count              <= tb_count + increment_amt;
        expected_index        <= (tb_count + increment_amt) * (2 ** idx_shift_left_amt);

        wait until rising_edge(clk);

        assert twiddle_real = expected_twiddle_real report "unexpected value. expected_twiddle_real = " & to_string(expected_twiddle_real) & ", twiddle_real = " & to_string(twiddle_real);
        assert twiddle_imag = expected_twiddle_imag report "unexpected value. expected_twiddle_imag = " & to_string(expected_twiddle_imag) & ", twiddle_imag = " & to_string(twiddle_imag);

        expected_twiddle_real <= TWIDDLE_FACTORS_REAL(expected_index);
        expected_twiddle_imag <= TWIDDLE_FACTORS_IMAG(expected_index);
        tb_count              <= 0;
        expected_index        <= 0;

        wait until rising_edge(clk);

        assert twiddle_real = expected_twiddle_real report "unexpected value. expected_twiddle_real = " & to_string(expected_twiddle_real) & ", twiddle_real = " & to_string(twiddle_real);
        assert twiddle_imag = expected_twiddle_imag report "unexpected value. expected_twiddle_imag = " & to_string(expected_twiddle_imag) & ", twiddle_imag = " & to_string(twiddle_imag);

        expected_twiddle_real <= TWIDDLE_FACTORS_REAL(expected_index);
        expected_twiddle_imag <= TWIDDLE_FACTORS_IMAG(expected_index);
        tb_count              <= tb_count + increment_amt;
        expected_index        <= (tb_count + increment_amt) * (2 ** idx_shift_left_amt);

        wait until rising_edge(clk);

        assert twiddle_real = expected_twiddle_real report "unexpected value. expected_twiddle_real = " & to_string(expected_twiddle_real) & ", twiddle_real = " & to_string(twiddle_real);
        assert twiddle_imag = expected_twiddle_imag report "unexpected value. expected_twiddle_imag = " & to_string(expected_twiddle_imag) & ", twiddle_imag = " & to_string(twiddle_imag);

        expected_twiddle_real <= TWIDDLE_FACTORS_REAL(expected_index);
        expected_twiddle_imag <= TWIDDLE_FACTORS_IMAG(expected_index);
        tb_count              <= tb_count + increment_amt;
        expected_index        <= (tb_count + increment_amt) * (2 ** idx_shift_left_amt);

        wait until rising_edge(clk);

        assert twiddle_real = expected_twiddle_real report "unexpected value. expected_twiddle_real = " & to_string(expected_twiddle_real) & ", twiddle_real = " & to_string(twiddle_real);
        assert twiddle_imag = expected_twiddle_imag report "unexpected value. expected_twiddle_imag = " & to_string(expected_twiddle_imag) & ", twiddle_imag = " & to_string(twiddle_imag);

        expected_twiddle_real <= TWIDDLE_FACTORS_REAL(expected_index);
        expected_twiddle_imag <= TWIDDLE_FACTORS_IMAG(expected_index);
        tb_count              <= tb_count + increment_amt;
        expected_index        <= (tb_count + increment_amt) * (2 ** idx_shift_left_amt);

        wait until rising_edge(clk);

        sim_done <= '1';
        report "SIMULATION FINISHED!!!";

    end process;

end TB;