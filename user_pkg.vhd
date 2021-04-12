library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package user_pkg is

constant DATA_WIDTH : positive := 32;
subtype DATA_RANGE is natural range DATA_WIDTH - 1 downto 0;

constant NUM_POINTS : positive := 64;

type TWIDDLE_ARRAY is array (natural range <>) of std_logic_vector(DATA_RANGE);
subtype TWIDDLE_RANGE is natural range 0 to NUM_POINTS - 1;

constant TWIDDLE_FACTORS_REAL : TWIDDLE_ARRAY(TWIDDLE_RANGE) := (0 => x"7fffffff",1 => x"7f62368f",2 => x"7d8a5f3f",3 => x"7a7d055b",4 => x"7641af3c",5 => x"70e2cbc6",6 => x"6a6d98a4",7 => x"62f201ac",8 => x"5a827999",9 => x"5133cc94",
10 => x"471cece6",11 => x"3c56ba70",12 => x"30fbc54d",13 => x"25280c5d",14 => x"18f8b83c",15 => x"0c8bd35e",16 => x"00000000",17 => x"f3742ca2",18 => x"e70747c4",19 => x"dad7f3a3",
20 => x"cf043ab3",21 => x"c3a94590",22 => x"b8e3131a",23 => x"aecc336c",24 => x"a57d8667",25 => x"9d0dfe54",26 => x"9592675c",27 => x"8f1d343a",28 => x"89be50c4",29 => x"8582faa5",
30 => x"8275a0c1",31 => x"809dc971",32 => x"80000000",33 => x"809dc971",34 => x"8275a0c1",35 => x"8582faa5",36 => x"89be50c4",37 => x"8f1d343a",38 => x"9592675c",39 => x"9d0dfe54",
40 => x"a57d8667",41 => x"aecc336c",42 => x"b8e3131a",43 => x"c3a94590",44 => x"cf043ab3",45 => x"dad7f3a3",46 => x"e70747c4",47 => x"f3742ca2",48 => x"00000000",49 => x"0c8bd35e",
50 => x"18f8b83c",51 => x"25280c5d",52 => x"30fbc54d",53 => x"3c56ba70",54 => x"471cece6",55 => x"5133cc94",56 => x"5a827999",57 => x"62f201ac",58 => x"6a6d98a4",59 => x"70e2cbc6",
60 => x"7641af3c",61 => x"7a7d055b",62 => x"7d8a5f3f",63 => x"7f62368f");

constant TWIDDLE_FACTORS_IMAG : TWIDDLE_ARRAY(TWIDDLE_RANGE) := (0 => x"00000000",1 => x"f3742ca2",2 => x"e70747c4",3 => x"dad7f3a3",4 => x"cf043ab3",5 => x"c3a94590",6 => x"b8e3131a",7 => x"aecc336c",8 => x"a57d8667",9 => x"9d0dfe54",
10 => x"9592675c",11 => x"8f1d343a",12 => x"89be50c4",13 => x"8582faa5",14 => x"8275a0c1",15 => x"809dc971",16 => x"80000000",17 => x"809dc971",18 => x"8275a0c1",19 => x"8582faa5",
20 => x"89be50c4",21 => x"8f1d343a",22 => x"9592675c",23 => x"9d0dfe54",24 => x"a57d8667",25 => x"aecc336c",26 => x"b8e3131a",27 => x"c3a94590",28 => x"cf043ab3",29 => x"dad7f3a3",
30 => x"e70747c4",31 => x"f3742ca2",32 => x"00000000",33 => x"0c8bd35e",34 => x"18f8b83c",35 => x"25280c5d",36 => x"30fbc54d",37 => x"3c56ba70",38 => x"471cece6",39 => x"5133cc94",
40 => x"5a827999",41 => x"62f201ac",42 => x"6a6d98a4",43 => x"70e2cbc6",44 => x"7641af3c",45 => x"7a7d055b",46 => x"7d8a5f3f",47 => x"7f62368f",48 => x"7fffffff",49 => x"7f62368f",
50 => x"7d8a5f3f",51 => x"7a7d055b",52 => x"7641af3c",53 => x"70e2cbc6",54 => x"6a6d98a4",55 => x"62f201ac",56 => x"5a827999",57 => x"5133cc94",58 => x"471cece6",59 => x"3c56ba70",
60 => x"30fbc54d",61 => x"25280c5d",62 => x"18f8b83c",63 => x"0c8bd35e");

constant ZERO : std_logic_vector(DATA_RANGE) := (others => '0');

constant NEGATIVE_ONE : std_logic_vector(DATA_RANGE) := ((DATA_WIDTH - 1) => '1', others => '0');

end user_pkg;