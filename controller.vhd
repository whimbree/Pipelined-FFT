library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is

    port (
        clk : in std_logic;
        rst : in std_logic;

        -- control signals
        go   : in std_logic;
        size : in std_logic_vector(31 downto 0);
        done : out std_logic;

        -- valid signal to datapath delay entity
        valid_start : out std_logic;

        -- valid signals from datapath delay entity
        valid_end : in std_logic);

end controller;

architecture BHV of controller is

    type STATE_TYPE is (INIT, MAIN, FIN);

    signal state, next_state               : STATE_TYPE;
    signal size_reg, next_size_reg         : std_logic_vector(31 downto 0);
    signal size_count, next_size_count     : integer := 0;
    signal output_count, next_output_count : integer := 0;

begin

    sync_proc : process (rst, clk)
    begin
        if rst = '1' then
            state        <= INIT;
            size_reg     <= (others => '0');
            size_count   <= 0;
            output_count <= 0;
        elsif rising_edge(clk) then
            state        <= next_state;
            size_reg     <= next_size_reg;
            size_count   <= next_size_count;
            output_count <= next_output_count;
        end if;
    end process;

    comb_proc : process (state, go, valid_end, size_count, output_count, size_reg, size)
    begin

        next_state        <= state;
        next_size_reg     <= size_reg;
        next_size_count   <= size_count;
        next_output_count <= output_count;
        done              <= '0';
        valid_start       <= '0';

        case state is
            when INIT =>
                if go = '1' then
                    next_state    <= MAIN;
                    next_size_reg <= size;
                end if;

            when MAIN =>
                if size_count < to_integer(unsigned(size_reg)) then
                    next_size_count <= size_count + 1;
                    valid_start     <= '1';

                end if;

                if valid_end = '1' then
                    next_output_count <= output_count + 1;
                end if;

                if output_count >= (to_integer(unsigned(size_reg)) - 1) then
                    -- done <= '1';
                    next_state <= FIN;
                end if;

            when FIN =>
                done <= '1';
                if go = '0' then -- should check for go = 0 to make sure it has been cleared and then set again
                    next_state <= INIT;
                end if;
            when others => null;
        end case;
    end process;
end BHV;