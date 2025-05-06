----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:37 05/05/2025 
-- Design Name: 
-- Module Name:    mixer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.common_pkg.all;
use work.adsr_multiplier_pkg.all;

entity mixer is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_channels : in t_signal_array;
        o_mixed_channels : out signed(SIGNAL_WIDTH - 1 downto 0) := (others => '0')
    );
end mixer;

architecture Behavioral of mixer is

    signal s_channel_select : integer range 0 to N_CHANNELS - 1 := N_CHANNELS - 1;
    signal s_mixed_channels : signed(SIGNAL_WIDTH downto 0) := (others => '0');
    signal s_active : std_logic := '0';

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_mixed_channels <= (others => '0');
                s_active <= '0';
            else
                if s_channel_select = N_CHANNELS - 1 then
                    if i_channels(s_channel_select).active = '1' then
                        s_mixed_channels <= resize(i_channels(s_channel_select).value, s_mixed_channels'length);
                        s_active <= '1';
                    else
                        s_mixed_channels <= (others => '0');
                        s_active <= '0';
                    end if;
                    o_mixed_channels <= s_mixed_channels(SIGNAL_WIDTH - 1 downto 0);
                else
                    if i_channels(s_channel_select).active = '1' then
                        if s_active = '1' then
                            s_mixed_channels <= shift_right(s_mixed_channels + resize(i_channels(s_channel_select).value, s_mixed_channels'length), 1);
                        else
                            s_mixed_channels <= resize(i_channels(s_channel_select).value, s_mixed_channels'length);
                            s_active <= '1';
                        end if;
                    else
                        s_mixed_channels <= s_mixed_channels;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_channel_select <= N_CHANNELS - 1;
            else
                if s_channel_select = 0 then
                    s_channel_select <= N_CHANNELS - 1;
                else
                    s_channel_select <= s_channel_select - 1;
                end if;
            end if;
        end if;
    end process;


end Behavioral;

