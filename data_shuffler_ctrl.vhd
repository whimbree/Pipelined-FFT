library ieee;
use ieee.std_logic_1164.all;

entity data_shuffler_ctrl is
    generic (pulse_length : positive := 2);
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        input_valid : in std_logic;

        ds_select : out std_logic);
end data_shuffler_ctrl;

architecture BHV of data_shuffler_ctrl is

    signal count              : natural range 0 to pulse_length - 1;
    signal ds_select_internal : std_logic := '0';

begin

    process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count <= 0;
            elsif input_valid = '1' then
                if count = pulse_length - 1 then
                    -- pulse_length - 1, since it takes a cycle to change the output of the ds_select register
                    count              <= 0;
                    ds_select_internal <= not ds_select_internal;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;

    ds_select <= ds_select_internal;

end BHV;