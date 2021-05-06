library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity butterfly is

    generic (
        width : positive := 16);
    port (
        clk : in std_logic;
        rst : in std_logic;
        en  : in std_logic;

        input_0_real : in std_logic_vector(width - 1 downto 0);
        input_0_img  : in std_logic_vector(width - 1 downto 0);
        input_1_real : in std_logic_vector(width - 1 downto 0);
        input_1_img  : in std_logic_vector(width - 1 downto 0);

        output_0_real : out std_logic_vector(width - 1 downto 0);
        output_0_img  : out std_logic_vector(width - 1 downto 0);
        output_1_real : out std_logic_vector(width - 1 downto 0);
        output_1_img  : out std_logic_vector(width - 1 downto 0));

end butterfly;

architecture STR of butterfly is

    signal reg_0_real, reg_0_img, reg_1_real, reg_1_img : std_logic_vector(width - 1 downto 0);

    signal add2_r2_in, add2_i2_in : std_logic_vector(width - 1 downto 0);

begin

    reg0 : entity work.complex_reg
        generic map(width => width)
        port map(
            clk         => clk,
            rst         => rst,
            en          => en,
            input_real  => input_0_real,
            input_img   => input_0_img,
            output_real => reg_0_real,
            output_img  => reg_0_img);

    reg1 : entity work.complex_reg
        generic map(width => width)
        port map(
            clk         => clk,
            rst         => rst,
            en          => en,
            input_real  => input_1_real,
            input_img   => input_1_img,
            output_real => reg_1_real,
            output_img  => reg_1_img);

    add1 : entity work.complex_add
        generic map(width => width)
        port map(
            r1_in => reg_0_real,
            i1_in => reg_0_img,
            r2_in => reg_1_real,
            i2_in => reg_1_img,

            r_out => output_0_real,
            i_out => output_0_img);

    add2_r2_in <= std_logic_vector(resize(-1 * signed(reg_1_real), width));
    add2_i2_in <= std_logic_vector(resize(-1 * signed(reg_1_img), width));

    add2 : entity work.complex_add
        generic map(width => width)
        port map(
            r1_in => reg_0_real,
            i1_in => reg_0_img,
            r2_in => add2_r2_in,
            i2_in => add2_i2_in,

            r_out => output_1_real,
            i_out => output_1_img);
end STR;