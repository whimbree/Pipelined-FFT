library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_shuffler is

    generic (
        delay_length : positive := 4;
        width        : positive := 16);
    port (
        clk : in std_logic;
        rst : in std_logic;

        mux_select : in std_logic;

        input_0_real : in std_logic_vector(width - 1 downto 0);
        input_0_img  : in std_logic_vector(width - 1 downto 0);
        input_1_real : in std_logic_vector(width - 1 downto 0);
        input_1_img  : in std_logic_vector(width - 1 downto 0);

        output_0_real : out std_logic_vector(width - 1 downto 0);
        output_0_img  : out std_logic_vector(width - 1 downto 0);
        output_1_real : out std_logic_vector(width - 1 downto 0);
        output_1_img  : out std_logic_vector(width - 1 downto 0)
    );

end data_shuffler;

architecture STR of data_shuffler is

    signal dbuff_real, dbuff_img : std_logic_vector(width - 1 downto 0);
    signal mux_real, mux_img     : std_logic_vector(width - 1 downto 0);
    signal mux_select_inverted   : std_logic;

begin

    mux_select_inverted <= not(mux_select);

    -- upper mux
    mux_1 : entity work.mux
        generic map(
            width => width)
        port map(
            mux_select   => mux_select,
            input_real_0 => input_0_real,
            input_img_0  => input_0_img,
            input_real_1 => dbuff_real,
            input_img_1  => dbuff_img,
            output_real  => mux_real,
            output_img   => mux_img);

    -- lower mux        
    mux_2 : entity work.mux
        generic map(
            width => width)
        port map(
            mux_select   => mux_select_inverted,
            input_real_0 => input_0_real,
            input_img_0  => input_0_img,
            input_real_1 => dbuff_real,
            input_img_1  => dbuff_img,
            output_real  => output_1_real,
            output_img   => output_1_img);

    -- lower delay buffer        
    delay_buffer_1 : entity work.pipe_reg
        generic map(
            length => delay_length,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => input_1_real,
            input_img   => input_1_img,
            output_real => dbuff_real,
            output_img  => dbuff_img);

    -- upper delay buffer        
    delay_buffer_2 : entity work.pipe_reg
        generic map(
            length => delay_length,
            width  => width)
        port map(
            clk         => clk,
            rst         => rst,
            input_real  => mux_real,
            input_img   => mux_img,
            output_real => output_0_real,
            output_img  => output_0_img);

end STR;