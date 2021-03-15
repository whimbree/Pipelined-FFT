library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity butterfly is

    generic (
        width : positive := 16);
    port (
        clk : in std_logic;
        rst : in std_logic;

        twiddle_real : in std_logic_vector(width - 1 downto 0);
        twiddle_img  : in std_logic_vector(width - 1 downto 0);

        input_0_real : in std_logic_vector(width - 1 downto 0);
        input_0_img  : in std_logic_vector(width - 1 downto 0);
        input_1_real : in std_logic_vector(width - 1 downto 0);
        input_1_img  : in std_logic_vector(width - 1 downto 0);

        output_0_real : out std_logic_vector(width - 1 downto 0);
        output_0_img  : out std_logic_vector(width - 1 downto 0);
        output_1_real : out std_logic_vector(width - 1 downto 0);
        output_1_img  : out std_logic_vector(width - 1 downto 0));

end butterfly;

architecture STR_MULT of butterfly is

    signal mult_out_real, mult_out_img       : std_logic_vector((width * 2) - 1 downto 0);
    signal dbuffer_out_real, dbuffer_out_img : std_logic_vector(width - 1 downto 0);

begin

    mult : entity work.complex_mult
        port map(
            dataa_real  => input_1_real,
            dataa_imag  => input_1_img,
            datab_real  => twiddle_real,
            datab_imag  => twiddle_img,
            result_real => mult_out_real,
            result_imag => mult_out_img,
            clock       => clk);

    add1 : entity work.complex_add
        generic map(width => width)
        port map(
            r1_in => dbuffer_out_real,
            i1_in => dbuffer_out_img,
            r2_in => mult_out_real((width * 2) - 1 downto width),
            i2_in => mult_out_img((width * 2) - 1 downto width),

            r_out => output_0_real,
            i_out => output_0_img);

    add2 : entity work.complex_add
        generic map(width => width)
        port map(
            r1_in => dbuffer_out_real,
            i1_in => dbuffer_out_img,
            r2_in => std_logic_vector(resize(-1 * signed(mult_out_real((width * 2) - 1 downto width)), width)),
            i2_in => std_logic_vector(resize(-1 * signed(mult_out_img((width * 2) - 1 downto width)), width)),

            r_out => output_1_real,
            i_out => output_1_img);

    delay_buffer : entity work.pipe_reg
        generic map(
            length => 4,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => input_0_real,
            input_img   => input_0_img,
            output_real => dbuffer_out_real,
            output_img  => dbuffer_out_img);

end STR_MULT;

architecture STR of butterfly is

    signal reg_0_real, reg_0_img, reg_1_real, reg_1_img : std_logic_vector(width - 1 downto 0);

begin

    reg0 : entity work.reg
        generic map(width => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => input_0_real,
            input_img   => input_0_img,
            output_real => reg_0_real,
            output_img  => reg_0_img);

    reg1 : entity work.reg
        generic map(width => width)
        port map(
            clk         => clk,
            rst         => rst,
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

    add2 : entity work.complex_add
        generic map(width => width)
        port map(
            r1_in => reg_0_real,
            i1_in => reg_0_img,
            r2_in => std_logic_vector(resize(-1 * signed(reg_1_real), width)),
            i2_in => std_logic_vector(resize(-1 * signed(reg_1_img), width)),

            r_out => output_1_real,
            i_out => output_1_img);
end STR;