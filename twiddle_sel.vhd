library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- twiddle factors array is stored here
use work.user_pkg.all;

entity twiddle_sel is
    generic (
        len_sequence  : positive range 1 to 65535 := 4;
        increment_amt : positive range 1 to 65535 := 2);
    port (
        clk : in std_logic;
        rst : in std_logic;

        count_en    : in std_logic;
        twiddle_idx : out natural range 0 to 65535);
end twiddle_sel;

architecture BHV of twiddle_sel is

    signal count                : natural range 0 to 65535;
    signal twiddle_idx_internal : natural range 0 to 65535;

begin
    process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count                <= 0;
                twiddle_idx_internal <= 0;
            elsif count_en = '1' then
                if count = len_sequence then
                    count                <= 0;
                    twiddle_idx_internal <= 0;
                else
                    count                <= count + 1;
                    twiddle_idx_internal <= twiddle_idx_internal + twiddle_idx_internal;
                end if;
            end if;
        end if;
    end process;

    twiddle_idx <= twiddle_idx_internal;

end BHV;