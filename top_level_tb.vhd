library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.tb_files_pkg.all;

use work.user_pkg.all;

entity top_level_tb is
end;

architecture TB of top_level_tb is

    constant TEST_WIDTH : positive := DATA_WIDTH;
    constant TEST_SIZE  : positive := 4 ** NUM_INTERNAL_STAGE_PAIRS;

    -- Clock period
    constant clk_period : time := 5 ns;
    -- Generics
    constant width : positive := TEST_WIDTH;

    -- Ports
    signal clk          : std_logic := '0';
    signal rst          : std_logic;
    signal en           : std_logic := '1';
    signal valid_input  : std_logic;
    signal done         : std_logic;
    signal go           : std_logic;
    signal size         : std_logic_vector(31 downto 0);
    signal valid_output : std_logic;
    signal r0_input     : std_logic_vector(width - 1 downto 0);
    signal r1_input     : std_logic_vector(width - 1 downto 0);
    signal r2_input     : std_logic_vector(width - 1 downto 0);
    signal r3_input     : std_logic_vector(width - 1 downto 0);
    signal i0_input     : std_logic_vector(width - 1 downto 0);
    signal i1_input     : std_logic_vector(width - 1 downto 0);
    signal i2_input     : std_logic_vector(width - 1 downto 0);
    signal i3_input     : std_logic_vector(width - 1 downto 0);
    signal r0_output    : std_logic_vector(width - 1 downto 0);
    signal r1_output    : std_logic_vector(width - 1 downto 0);
    signal r2_output    : std_logic_vector(width - 1 downto 0);
    signal r3_output    : std_logic_vector(width - 1 downto 0);
    signal i0_output    : std_logic_vector(width - 1 downto 0);
    signal i1_output    : std_logic_vector(width - 1 downto 0);
    signal i2_output    : std_logic_vector(width - 1 downto 0);
    signal i3_output    : std_logic_vector(width - 1 downto 0);

    signal sim_done : std_logic := '0';

    file fptr : text;

    file fptr_out : text;

begin

    -- toggle clock
    clk <= not clk after 5 ns when sim_done = '0' else -- it may be better to manually toggle the clock?
        clk;

    top_level_inst : entity work.top_level
        generic map(
            num_internal_stage_pairs => NUM_INTERNAL_STAGE_PAIRS,
            width                    => width
        )
        port map(
            clk          => clk,
            rst          => rst,
            en           => en,
            done         => done,
            go           => go,
            size         => size,
            valid_input  => valid_input,
            valid_output => valid_output,
            r0_input     => r0_input,
            r1_input     => r1_input,
            r2_input     => r2_input,
            r3_input     => r3_input,
            i0_input     => i0_input,
            i1_input     => i1_input,
            i2_input     => i2_input,
            i3_input     => i3_input,
            r0_output    => r0_output,
            r1_output    => r1_output,
            r2_output    => r2_output,
            r3_output    => r3_output,
            i0_output    => i0_output,
            i1_output    => i1_output,
            i2_output    => i2_output,
            i3_output    => i3_output
        );

    test_process : process

        variable read_col_from_input_buf : line; -- read lines one by one from input_buf
        variable write_col_to_output_buf : line; -- write lines one by one to output_buf

        variable buf_data_from_file : line; -- buffer for storind the data from input read-file

        variable input_0_real, input_1_real, input_2_real, input_3_real : std_logic_vector(width - 1 downto 0);
        variable input_0_imag, input_1_imag, input_2_imag, input_3_imag : std_logic_vector(width - 1 downto 0);

        variable fstatus : file_open_status;

        variable file_line : line;

        variable read_char : character;
    begin

        file_open(fstatus, fptr, C_FILE_NAME_INPUT, read_mode);

        rst  <= '1';
        size <= (others => '0');
        go   <= '0';

        for i in 0 to 4 loop
            wait until rising_edge(clk);
        end loop; -- i

        rst <= '0';
        wait until rising_edge(clk);

        size <= std_logic_vector(to_unsigned(TEST_SIZE, 32));
        go   <= '1';

        -- fill 2/3s of the pipeline, then
        -- reset and start filling from the beginning
        -- test for proper resetting
        for i in 1 to (2 * TEST_SIZE) / 3 loop
            readline(fptr, file_line);

            hread(file_line, input_0_real);
            r0_input <= input_0_real;
            read(file_line, read_char);

            hread(file_line, input_0_imag);
            i0_input <= input_0_imag;
            read(file_line, read_char);

            hread(file_line, input_1_real);
            r1_input <= input_1_real;
            read(file_line, read_char);

            hread(file_line, input_1_imag);
            i1_input <= input_1_imag;
            read(file_line, read_char);

            hread(file_line, input_2_real);
            r2_input <= input_2_real;
            read(file_line, read_char);

            hread(file_line, input_2_imag);
            i2_input <= input_2_imag;
            read(file_line, read_char);

            hread(file_line, input_3_real);
            r3_input <= input_3_real;
            read(file_line, read_char);

            hread(file_line, input_3_imag);
            i3_input <= input_3_imag;

            valid_input <= '1';

            wait until rising_edge(clk);
        end loop;

        valid_input <= '0';
        wait until rising_edge(clk);

        file_close(fptr);

        -- reopen the file to get back to the top
        file_open(fstatus, fptr, C_FILE_NAME_INPUT, read_mode);

        rst  <= '1';
        size <= (others => '0');
        go   <= '0';

        for i in 0 to 4 loop
            wait until rising_edge(clk);
        end loop; -- i

        rst <= '0';
        wait until rising_edge(clk);

        size <= std_logic_vector(to_unsigned(TEST_SIZE, 32));
        go   <= '1';
        wait until rising_edge(clk);

        -- populate the first half of the pipeline

        for i in 1 to TEST_SIZE / 2 loop
            readline(fptr, file_line);

            hread(file_line, input_0_real);
            r0_input <= input_0_real;
            read(file_line, read_char);

            hread(file_line, input_0_imag);
            i0_input <= input_0_imag;
            read(file_line, read_char);

            hread(file_line, input_1_real);
            r1_input <= input_1_real;
            read(file_line, read_char);

            hread(file_line, input_1_imag);
            i1_input <= input_1_imag;
            read(file_line, read_char);

            hread(file_line, input_2_real);
            r2_input <= input_2_real;
            read(file_line, read_char);

            hread(file_line, input_2_imag);
            i2_input <= input_2_imag;
            read(file_line, read_char);

            hread(file_line, input_3_real);
            r3_input <= input_3_real;
            read(file_line, read_char);

            hread(file_line, input_3_imag);
            i3_input <= input_3_imag;

            valid_input <= '1';

            wait until rising_edge(clk);
        end loop;

        -- stall for a bit in the middle

        for i in 1 to 25 loop
            en <= '0';
            wait until rising_edge(clk);
        end loop;
        en <= '1';

        -- populate the second half of the pipeline

        for i in TEST_SIZE / 2 + 1 to TEST_SIZE loop
            readline(fptr, file_line);

            hread(file_line, input_0_real);
            r0_input <= input_0_real;
            read(file_line, read_char);

            hread(file_line, input_0_imag);
            i0_input <= input_0_imag;
            read(file_line, read_char);

            hread(file_line, input_1_real);
            r1_input <= input_1_real;
            read(file_line, read_char);

            hread(file_line, input_1_imag);
            i1_input <= input_1_imag;
            read(file_line, read_char);

            hread(file_line, input_2_real);
            r2_input <= input_2_real;
            read(file_line, read_char);

            hread(file_line, input_2_imag);
            i2_input <= input_2_imag;
            read(file_line, read_char);

            hread(file_line, input_3_real);
            r3_input <= input_3_real;
            read(file_line, read_char);

            hread(file_line, input_3_imag);
            i3_input <= input_3_imag;

            valid_input <= '1';

            wait until rising_edge(clk);
        end loop;

        wait until done = '1';

        go <= '0';

        sim_done <= '1';
        report "SIMULATION FINISHED!!!";
        wait;
    end process;

    output_process : process (clk)

        -- http://edaplaygroundblog.blogspot.com/2018/10/how-to-convert-stdlogicvector-to-hex.html
        function to_hstring (SLV : std_logic_vector) return string is
            variable L               : LINE;
        begin
            hwrite(L, SLV);
            return L.all;
        end function to_hstring;

        constant CSV_DELIM : string := ",";

        variable fstatus : file_open_status;

        variable file_line : line;
    begin

        file_open(fstatus, fptr_out, C_FILE_NAME_OUTPUT, write_mode);

        if sim_done = '0' then

            if valid_output = '1' and rising_edge(clk) then
                write(file_line, to_hstring(r0_output));
                write(file_line, CSV_DELIM);
                write(file_line, to_hstring(i0_output));
                write(file_line, CSV_DELIM);
                write(file_line, to_hstring(r1_output));
                write(file_line, CSV_DELIM);
                write(file_line, to_hstring(i1_output));
                write(file_line, CSV_DELIM);
                write(file_line, to_hstring(r2_output));
                write(file_line, CSV_DELIM);
                write(file_line, to_hstring(i2_output));
                write(file_line, CSV_DELIM);
                write(file_line, to_hstring(r3_output));
                write(file_line, CSV_DELIM);
                write(file_line, to_hstring(i3_output));

                writeline(fptr_out, file_line);
            end if;
        end if;
    end process;
end TB;