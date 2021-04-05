library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package user_pkg is

    constant DATA_WIDTH : positive := 32;
    subtype DATA_RANGE is natural range DATA_WIDTH - 1 downto 0;

    -- Twiddle Factor Table

    constant REAL_0  : std_logic_vector(DATA_RANGE) := x"7fffffff";
    constant REAL_1  : std_logic_vector(DATA_RANGE) := x"7641af3c";
    constant REAL_2  : std_logic_vector(DATA_RANGE) := x"5a827999";
    constant REAL_3  : std_logic_vector(DATA_RANGE) := x"30fbc54d";
    constant REAL_4  : std_logic_vector(DATA_RANGE) := x"00000000";
    constant REAL_5  : std_logic_vector(DATA_RANGE) := x"cf043ab3";
    constant REAL_6  : std_logic_vector(DATA_RANGE) := x"a57d8667";
    constant REAL_7  : std_logic_vector(DATA_RANGE) := x"89be50c4";
    constant REAL_8  : std_logic_vector(DATA_RANGE) := x"7fffffff";
    constant REAL_9  : std_logic_vector(DATA_RANGE) := x"89be50c4";
    constant REAL_10 : std_logic_vector(DATA_RANGE) := x"a57d8667";
    constant REAL_11 : std_logic_vector(DATA_RANGE) := x"cf043ab3";
    constant REAL_12 : std_logic_vector(DATA_RANGE) := x"00000000";
    constant REAL_13 : std_logic_vector(DATA_RANGE) := x"30fbc54d";
    constant REAL_14 : std_logic_vector(DATA_RANGE) := x"5a827999";
    constant REAL_15 : std_logic_vector(DATA_RANGE) := x"7641af3c";

    constant IMAG_0  : std_logic_vector(DATA_RANGE) := x"00000000";
    constant IMAG_1  : std_logic_vector(DATA_RANGE) := x"30fbc54d";
    constant IMAG_2  : std_logic_vector(DATA_RANGE) := x"5a827999";
    constant IMAG_3  : std_logic_vector(DATA_RANGE) := x"7641af3c";
    constant IMAG_4  : std_logic_vector(DATA_RANGE) := x"7fffffff";
    constant IMAG_5  : std_logic_vector(DATA_RANGE) := x"7641af3c";
    constant IMAG_6  : std_logic_vector(DATA_RANGE) := x"5a827999";
    constant IMAG_7  : std_logic_vector(DATA_RANGE) := x"30fbc54d";
    constant IMAG_8  : std_logic_vector(DATA_RANGE) := x"00000000";
    constant IMAG_9  : std_logic_vector(DATA_RANGE) := x"cf043ab3";
    constant IMAG_10 : std_logic_vector(DATA_RANGE) := x"a57d8667";
    constant IMAG_11 : std_logic_vector(DATA_RANGE) := x"89be50c4";
    constant IMAG_12 : std_logic_vector(DATA_RANGE) := x"7fffffff";
    constant IMAG_13 : std_logic_vector(DATA_RANGE) := x"89be50c4";
    constant IMAG_14 : std_logic_vector(DATA_RANGE) := x"a57d8667";
    constant IMAG_15 : std_logic_vector(DATA_RANGE) := x"cf043ab3";
end user_pkg;