library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- twiddle factors array is stored here
use work.user_pkg.all;

entity twiddle_sel is
    generic (
        len_sequence       : positive range 1 to 65535 := 4;
        increment_amt      : positive range 1 to 65535 := 2;
        idx_shift_left_amt : natural range 0 to 65535  := 0);
    port (
        clk : in std_logic;
        rst : in std_logic;

        count_en     : in std_logic;
        twiddle_real : out std_logic_vector(DATA_RANGE);
        twiddle_imag : out std_logic_vector(DATA_RANGE));
end twiddle_sel;

architecture BHV of twiddle_sel is

    signal twiddle_idx : natural range 0 to len_sequence * increment_amt;

begin
    process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                twiddle_idx <= 0;
            elsif count_en = '1' then
                if twiddle_idx = len_sequence * increment_amt then
                    twiddle_idx <= 0;
                else
                    twiddle_idx <= twiddle_idx + increment_amt;
                end if;
            end if;
        end if;
    end process;

    twiddle_real <= TWIDDLE_FACTORS_REAL(to_integer(shift_left(to_unsigned(twiddle_idx, 16), idx_shift_left_amt)));
    twiddle_imag <= TWIDDLE_FACTORS_IMAG(to_integer(shift_left(to_unsigned(twiddle_idx, 16), idx_shift_left_amt)));

end BHV;