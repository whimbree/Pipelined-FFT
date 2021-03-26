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
        cm_2_valid : in std_logic;
        ds_2_valid : in std_logic;
        ds_3_valid : in std_logic;
        valid_end  : in std_logic;

        -- only need one theta select per-stage (all CMs within stage are synced up)
        theta_select_2 : out std_logic_vector(1 downto 0);

        -- only need one data-shuffler select per stage (all DSs within stage are synced up)
        ds_select_2, ds_select_3 : out std_logic);

end controller;

architecture BHV of controller is

    type STATE_TYPE is (INIT, PRE, CM, DS_0, DS_1, MAIN, DRAIN, FIN);

    signal state, next_state           : STATE_TYPE;
    signal size_reg, next_size_reg     : std_logic_vector(31 downto 0);
    signal size_count, next_size_count : integer := 0;

    signal theta_select_count : std_logic_vector(1 downto 0) := "00";
    signal DS_2_count         : std_logic_vector(1 downto 0) := "00";
    signal DS_3_select_sig    : std_logic                    := '0';

begin

    sync_proc : process (rst, clk)
    begin
        if rst = '1' then
            state      <= INIT;
            size_reg   <= (others => '0');
            size_count <= 0;
        elsif rising_edge(clk) then
            state      <= next_state;
            size_reg   <= next_size_reg;
            size_count <= next_size_count;
        end if;
    end process;

    comb_proc : process (state, go, cm_2_valid, ds_2_valid, ds_3_valid, valid_end, theta_select_count, DS_2_count, DS_3_select_sig, size_reg, size, size_count)
    begin

        next_state         <= state;
        next_size_reg      <= size_reg;
        next_size_count    <= size_count;
        done               <= '0';
		  valid_start  		<= '0';
        theta_select_count <= "00";
        DS_2_count         <= "00";
        DS_3_select_sig    <= '0';

        case state is
            when INIT =>
                if go = '1' then
                    next_state    <= PRE;
                    next_size_reg <= size;
                end if;
            when PRE =>
					 valid_start <= '1';
                next_size_count <= size_count + 1;
                if cm_2_valid = '1' then
                    next_state <= CM;
                end if;
            when CM =>
					 valid_start <= '1';
                next_size_count <= size_count + 1;
                -- should the below be here or in the next stage?
                -- also I think this should properly overflow from 3 to 0 as desired, but not certain...
                theta_select_count <= std_logic_vector(resize(1 + unsigned(theta_select_count), 2));
                if ds_2_valid = '1' then
                    next_state <= DS_0;
                end if;
            when DS_0 =>
					 valid_start <= '1';
                next_size_count    <= size_count + 1;
                theta_select_count <= std_logic_vector(resize(1 + unsigned(theta_select_count), 2));
                DS_2_count         <= std_logic_vector(resize(1 + unsigned(DS_2_count), 2));
                if ds_3_valid = '1' then
                    next_state <= DS_0;
                end if;
            when DS_1 =>
					 valid_start <= '1';
                next_size_count    <= size_count + 1;
                theta_select_count <= std_logic_vector(resize(1 + unsigned(theta_select_count), 2));
                DS_2_count         <= std_logic_vector(resize(1 + unsigned(DS_2_count), 2));
                DS_3_select_sig    <= not(DS_3_select_sig);
                if valid_end = '1' then
                    next_state <= MAIN;
                end if;
            when MAIN =>
					 valid_start <= '1';
                next_size_count    <= size_count + 1;
                theta_select_count <= std_logic_vector(resize(1 + unsigned(theta_select_count), 2));
                DS_2_count         <= std_logic_vector(resize(1 + unsigned(DS_2_count), 2));
                DS_3_select_sig    <= not(DS_3_select_sig);
                if size_count >= (to_integer(unsigned(size_reg)) - 1) then
                    next_state <= DRAIN;
                end if;
            when DRAIN =>
                theta_select_count <= std_logic_vector(resize(1 + unsigned(theta_select_count), 2));
                DS_2_count         <= std_logic_vector(resize(1 + unsigned(DS_2_count), 2));
                DS_3_select_sig    <= not(DS_3_select_sig);
                if valid_end = '0' then
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

    -- use the upper bit of the 2 bit count vector to toggle every 2 cycles
    ds_select_2    <= DS_2_count(1);
    ds_select_3    <= DS_3_select_sig;
    theta_select_2 <= theta_select_count;
end BHV;