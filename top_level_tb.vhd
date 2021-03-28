library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.csv_file_reader_pkg.all;

entity top_level_tb is
end;

architecture TB of top_level_tb is

    constant TEST_WIDTH : positive := 16;
    constant TEST_SIZE  : positive := 8;

    -- Clock period
    constant clk_period : time := 5 ns;
    -- Generics
    constant width : positive := TEST_WIDTH;

    constant C_FILE_NAME : string := "/Users/Justin Golabek/Documents/My documents/School/Research/SHREC/CnM_CiM/src/Pipelined-FFT/tb_testInput_1.csv";

    -- Ports
    signal clk       : std_logic := '0';
    signal rst       : std_logic;
    signal done      : std_logic;
    signal go        : std_logic;
    signal size      : std_logic_vector(31 downto 0);
    signal r0_input  : std_logic_vector(width - 1 downto 0);
    signal r1_input  : std_logic_vector(width - 1 downto 0);
    signal r2_input  : std_logic_vector(width - 1 downto 0);
    signal r3_input  : std_logic_vector(width - 1 downto 0);
    signal i0_input  : std_logic_vector(width - 1 downto 0);
    signal i1_input  : std_logic_vector(width - 1 downto 0);
    signal i2_input  : std_logic_vector(width - 1 downto 0);
    signal i3_input  : std_logic_vector(width - 1 downto 0);
    signal r0_output : std_logic_vector(width - 1 downto 0);
    signal r1_output : std_logic_vector(width - 1 downto 0);
    signal r2_output : std_logic_vector(width - 1 downto 0);
    signal r3_output : std_logic_vector(width - 1 downto 0);
    signal i0_output : std_logic_vector(width - 1 downto 0);
    signal i1_output : std_logic_vector(width - 1 downto 0);
    signal i2_output : std_logic_vector(width - 1 downto 0);
    signal i3_output : std_logic_vector(width - 1 downto 0);

    signal sim_done : std_logic := '0';

    file fptr : text;

begin

    -- toggle clock
    clk <= not clk after 5 ns when sim_done = '0' else -- it may be better to manually toggle the clock?
    clk;

    top_level_inst : entity work.top_level
        generic map(
            width => width
        )
        port map(
            clk       => clk,
            rst       => rst,
            done      => done,
            go        => go,
            size      => size,
            r0_input  => r0_input,
            r1_input  => r1_input,
            r2_input  => r2_input,
            r3_input  => r3_input,
            i0_input  => i0_input,
            i1_input  => i1_input,
            i2_input  => i2_input,
            i3_input  => i3_input,
            r0_output => r0_output,
            r1_output => r1_output,
            r2_output => r2_output,
            r3_output => r3_output,
            i0_output => i0_output,
            i1_output => i1_output,
            i2_output => i2_output,
            i3_output => i3_output
        );

    test_process : process

        function Read_Decimal(in1 : real)
            return std_logic_vector is 
            begin
                return std_logic_vector(to_signed(integer(in1 * real(2**(TEST_WIDTH-1))), TEST_WIDTH));
            end Read_Decimal;

        variable read_col_from_input_buf : line; -- read lines one by one from input_buf
        variable write_col_to_output_buf : line; -- write lines one by one to output_buf

        variable buf_data_from_file : line; -- buffer for storind the data from input read-file
        
        variable input_0_real, input_1_real, input_2_real, input_3_real : real;
        variable input_0_imag, input_1_imag, input_2_imag, input_3_imag : real;

        variable fstatus : file_open_status;

        variable file_line : line;

        variable read_char : character;
    begin

        file_open(fstatus, fptr, C_FILE_NAME, read_mode);

        rst  <= '1';
        size <= (others => '0');
        go   <= '0';

        r0_input <= (others => '0');
        i0_input <= (others => '0');
        r1_input <= (others => '0');
        i1_input <= (others => '0');
        r2_input <= (others => '0');
        i2_input <= (others => '0');
        r3_input <= (others => '0');
        i3_input <= (others => '0');

        for i in 0 to 4 loop
            wait until rising_edge(clk);
        end loop; -- i

        rst <= '0';
        wait until rising_edge(clk);

        size <= std_logic_vector(to_unsigned(TEST_SIZE, 32));
        go   <= '1';

        for i in 1 to TEST_SIZE loop
            wait until rising_edge(clk);
            readline(fptr, file_line);

            read(file_line, input_0_real);
            r0_input <= Read_Decimal(input_0_real);
            read(file_line, read_char);

            read(file_line, input_0_imag);
            i0_input <= Read_Decimal(input_0_imag);
            read(file_line, read_char);

            read(file_line, input_1_real);
            r1_input <= Read_Decimal(input_1_real);
            read(file_line, read_char);

            read(file_line, input_1_imag);
            i1_input <= Read_Decimal(input_1_imag);
            read(file_line, read_char);

            read(file_line, input_2_real);
            r2_input <= Read_Decimal(input_2_real);
            read(file_line, read_char);

            read(file_line, input_2_imag);
            i2_input <= Read_Decimal(input_2_imag);
            read(file_line, read_char);

            read(file_line, input_3_real);
            r3_input <= Read_Decimal(input_3_real);
            read(file_line, read_char);

            read(file_line, input_3_imag);
            i3_input <= Read_Decimal(input_3_imag);
            read(file_line, read_char);

        end loop;

	wait until rising_edge(clk);

	r0_input <= (others => '0');
    i0_input <= (others => '0');
    r1_input <= (others => '0');
    i1_input <= (others => '0');
    r2_input <= (others => '0');
    i2_input <= (others => '0');
    r3_input <= (others => '0');
    i3_input <= (others => '0');

        --wait until done = '1';

        for i in 0 to 25 loop
            wait until clk'event and clk = '1';
        end loop; -- i

        go <= '0';
            
        sim_done <= '1';    
        report "SIMULATION FINISHED!!!";
        wait;
    end process;
end TB;