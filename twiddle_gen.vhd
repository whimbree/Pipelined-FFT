library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.user_pkg.all;

entity twiddle_gen is

    generic (
        width : positive := 16;
        -- The below twiddle factor inputs specify the 'twiddle memory' for this particular instantiation
        tw0_r : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        tw0_i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        tw1_r : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        tw1_i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        tw2_r : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        tw2_i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        tw3_r : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
        tw3_i : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0'));
    port (
        -- this selects which of the generic inputted twiddle factors to output
        theta_index_select : in std_logic_vector(1 downto 0);

        twiddle_real : out std_logic_vector(width - 1 downto 0);
        twiddle_img  : out std_logic_vector(width - 1 downto 0));

end twiddle_gen;

architecture BHV_nREG of twiddle_gen is -- non-registered version for testing
begin
    twiddle_real <= tw0_r when theta_index_select = "00" else
        tw1_r when theta_index_select = "01" else
        tw2_r when theta_index_select = "10" else
        tw3_r when theta_index_select = "11" else
        (others => '0');

    twiddle_img <= tw0_i when theta_index_select = "00" else
        tw1_i when theta_index_select = "01" else
        tw2_i when theta_index_select = "10" else
        tw3_i when theta_index_select = "11" else
        (others => '0');

end BHV_nREG;