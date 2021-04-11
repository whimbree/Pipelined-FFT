library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package user_pkg is

    constant DATA_WIDTH : positive := 32;
    subtype DATA_RANGE is natural range DATA_WIDTH - 1 downto 0;

    type TWIDDLE_ARRAY is array (natural range <>) of std_logic_vector(DATA_RANGE);
    subtype TWIDDLE_RANGE is natural range 0 to 15;

    constant TWIDDLE_FACTORS_REAL : TWIDDLE_ARRAY(TWIDDLE_RANGE) := (0 => x"7fffffff", 1 => x"7641af3c", 2 => x"5a827999", 3 => x"30fbc54d", 4 => x"00000000", 5 => x"cf043ab3", 6 => x"a57d8667", 7 => x"89be50c4", 8 => x"80000000", 9 => x"89be50c4",
    10 => x"a57d8667", 11 => x"cf043ab3", 12 => x"00000000", 13 => x"30fbc54d", 14 => x"5a827999", 15 => x"7641af3c");

    constant TWIDDLE_FACTORS_IMAG : TWIDDLE_ARRAY(TWIDDLE_RANGE) := (0 => x"00000000", 1 => x"cf043ab3", 2 => x"a57d8667", 3 => x"89be50c4", 4 => x"80000000", 5 => x"89be50c4", 6 => x"a57d8667", 7 => x"cf043ab3", 8 => x"00000000", 9 => x"30fbc54d",
    10 => x"5a827999", 11 => x"7641af3c", 12 => x"7fffffff", 13 => x"7641af3c", 14 => x"5a827999", 15 => x"30fbc54d");

    constant ZERO : std_logic_vector(DATA_RANGE) := (others => '0');

    constant NEGATIVE_ONE : std_logic_vector(DATA_RANGE) := ((DATA_WIDTH - 1) => '1', others => '0');

end user_pkg;