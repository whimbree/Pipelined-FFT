library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package user_pkg is

    constant DATA_WIDTH : positive := 16;
    subtype DATA_RANGE is natural range DATA_WIDTH - 1 downto 0;

    -- Twiddle Factor Table

    constant REAL_0  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#7fff#, DATA_WIDTH));
    constant REAL_1  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#7641#, DATA_WIDTH));
    constant REAL_2  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#5a82#, DATA_WIDTH));
    constant REAL_3  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#30fb#, DATA_WIDTH));
    constant REAL_4  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#0#, DATA_WIDTH));
    constant REAL_5  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#cf05#, DATA_WIDTH));
    constant REAL_6  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#a57e#, DATA_WIDTH));
    constant REAL_7  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#89bf#, DATA_WIDTH));
    constant REAL_8  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#8000#, DATA_WIDTH));
    constant REAL_9  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#89be#, DATA_WIDTH));
    constant REAL_10 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#a57e#, DATA_WIDTH));
    constant REAL_11 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#cf05#, DATA_WIDTH));
    constant REAL_12 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#0#, DATA_WIDTH));
    constant REAL_13 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#30fb#, DATA_WIDTH));
    constant REAL_14 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#5a82#, DATA_WIDTH));
    constant REAL_15 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#7641#, DATA_WIDTH));

    constant IMAG_8  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#0#, DATA_WIDTH));
    constant IMAG_9  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#30fb#, DATA_WIDTH));
    constant IMAG_10  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#5a82#, DATA_WIDTH));
    constant IMAG_11  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#7641#, DATA_WIDTH));
    constant IMAG_12  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#7fff#, DATA_WIDTH));
    constant IMAG_13  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#7641#, DATA_WIDTH));
    constant IMAG_14  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#5a82#, DATA_WIDTH));
    constant IMAG_15  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#30fb#, DATA_WIDTH));
    constant IMAG_0  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#0#, DATA_WIDTH));
    constant IMAG_1  : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#cf05#, DATA_WIDTH));
    constant IMAG_2 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#a57e#, DATA_WIDTH));
    constant IMAG_3 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#89bf#, DATA_WIDTH));
    constant IMAG_4 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#8000#, DATA_WIDTH));
    constant IMAG_5 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#89bf#, DATA_WIDTH));
    constant IMAG_6 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#a57e#, DATA_WIDTH));
    constant IMAG_7 : std_logic_vector(DATA_RANGE) := std_logic_vector(to_signed(16#cf05#, DATA_WIDTH));

end user_pkg;