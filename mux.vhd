library ieee;
use ieee.std_logic_1164.all;

entity mux is
    generic (
        width : positive := 8);
    port (

        mux_select : in std_logic;

        input_real_0 : in std_logic_vector(width - 1 downto 0);
        input_img_0  : in std_logic_vector(width - 1 downto 0);

        input_real_1 : in std_logic_vector(width - 1 downto 0);
        input_img_1  : in std_logic_vector(width - 1 downto 0);

        output_real : out std_logic_vector(width - 1 downto 0);
        output_img  : out std_logic_vector(width - 1 downto 0));

end mux;

architecture STR of reg is
begin

    output_real <= input_real_1 when mux_select = '1' else
        input_real_0;

    output_img <= input_img_1 when mux_select = '1' else
        input_img_0;

end STR;