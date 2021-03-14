library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Butterfly_tb is
end;

architecture bench of Butterfly_tb is

    component Butterfly
        generic (
            width : positive
        );
        port (
            clk           : in std_logic;
            rst           : in std_logic;
            twiddle_real  : in std_logic_vector(width - 1 downto 0);
            twiddle_img   : in std_logic_vector(width - 1 downto 0);
            input_1_real  : in std_logic_vector(width - 1 downto 0);
            input_1_img   : in std_logic_vector(width - 1 downto 0);
            input_2_real  : in std_logic_vector(width - 1 downto 0);
            input_2_img   : in std_logic_vector(width - 1 downto 0);
            output_1_real : out std_logic_vector(width - 1 downto 0);
            output_1_img  : out std_logic_vector(width - 1 downto 0);
            output_2_real : out std_logic_vector(width - 1 downto 0);
            output_2_img  : out std_logic_vector(width - 1 downto 0)
        );
    end component;

    -- Clock period
    constant clk_period : time := 5 ns;
    -- Generics
    constant width : positive := 32;

    -- Ports
    signal clk           : std_logic;
    signal rst           : std_logic;
    signal twiddle_real  : std_logic_vector(width - 1 downto 0);
    signal twiddle_img   : std_logic_vector(width - 1 downto 0);
    signal input_1_real  : std_logic_vector(width - 1 downto 0);
    signal input_1_img   : std_logic_vector(width - 1 downto 0);
    signal input_2_real  : std_logic_vector(width - 1 downto 0);
    signal input_2_img   : std_logic_vector(width - 1 downto 0);
    signal output_1_real : std_logic_vector(width - 1 downto 0);
    signal output_1_img  : std_logic_vector(width - 1 downto 0);
    signal output_2_real : std_logic_vector(width - 1 downto 0);
    signal output_2_img  : std_logic_vector(width - 1 downto 0);

begin

    Butterfly_inst : Butterfly
    generic map(
        width => width
    )
    port map(
        clk           => clk,
        rst           => rst,
        twiddle_real  => twiddle_real,
        twiddle_img   => twiddle_img,
        input_1_real  => input_1_real,
        input_1_img   => input_1_img,
        input_2_real  => input_2_real,
        input_2_img   => input_2_img,
        output_1_real => output_1_real,
        output_1_img  => output_1_img,
        output_2_real => output_2_real,
        output_2_img  => output_2_img
    );

    --   clk_process : process
    --   begin
    --     clk <= '1';
    --     wait for clk_period/2;
    --     clk <= '0';
    --     wait for clk_period/2;
    --   end process clk_process;

end;