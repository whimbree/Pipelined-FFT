library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity complex_add is
    generic (
        width : positive := 32);
    port (
        r1_in : in std_logic_vector(width - 1 downto 0);
        i1_in : in std_logic_vector(width - 1 downto 0);
        r2_in : in std_logic_vector(width - 1 downto 0);
        i2_in : in std_logic_vector(width - 1 downto 0);

        r_out : out std_logic_vector(width - 1 downto 0);
        i_out : out std_logic_vector(width - 1 downto 0));
end complex_add;

architecture BHV of complex_add is

begin

    r_out <= std_logic_vector(signed(r1_in) + signed(r2_in));
    i_out <= std_logic_vector(signed(i1_in) + signed(i2_in));

end BHV;