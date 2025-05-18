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
use IEEE.math_real.all;

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

    constant ACCUMULATOR_WIDTH : integer := SIGNAL_WIDTH + integer(ceil(log2(real(N_CHANNELS))));
    constant RECIPROCAL_WIDTH : integer := 16;
    constant MULT_WIDTH : integer := ACCUMULATOR_WIDTH + RECIPROCAL_WIDTH;
    signal s_signal_acc : signed(ACCUMULATOR_WIDTH - 1 downto 0) := (others => '0');
    signal s_active_cnt : integer range 0 to N_CHANNELS := 0;
    signal s_channel_select : integer range 0 to N_CHANNELS - 1 := 0;
    signal s_signal_reg : signed(ACCUMULATOR_WIDTH - 1 downto 0) := (others => '0');
    signal s_reciprocal : signed(RECIPROCAL_WIDTH - 1 downto 0) := (others => '0');
    signal s_mult_result : signed(MULT_WIDTH - 1 downto 0) := (others => '0');
    
    type t_reciprocal_lut is array(0 to N_CHANNELS) of signed(RECIPROCAL_WIDTH - 1 downto 0);
    function gen_reciprocal_lut(n : integer) return t_reciprocal_lut is
        variable lut : t_reciprocal_lut;
    begin
        lut(0) := (others => '0');
        for i in 1 to n loop
            lut(i) := to_signed((2**(RECIPROCAL_WIDTH - 1) - 1) / i, RECIPROCAL_WIDTH);
        end loop;
        return lut;
    end function;
    constant RECIPROCAL_LUT : t_reciprocal_lut := gen_reciprocal_lut(N_CHANNELS);

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_channel_select <= 0;
                s_signal_acc <= (others => '0');
                s_active_cnt <= 0;
                s_signal_reg <= (others => '0');
                s_reciprocal <= (others => '0');
                s_mult_result <= (others => '0');
            else
                if s_channel_select = N_CHANNELS - 1 then
                    s_channel_select <= 0;
                else
                    s_channel_select <= s_channel_select + 1;
                end if;
                
                if s_channel_select = 0 then
                    if i_channels(s_channel_select).active = '1' then
                        s_signal_acc <= resize(i_channels(s_channel_select).value, s_signal_acc'length);
                        s_active_cnt <= 1;
                    else
                        s_signal_acc <= (others => '0');
                        s_active_cnt <= 0;
                    end if;
                    
                    s_signal_reg <= s_signal_acc;
                    s_reciprocal <= RECIPROCAL_LUT(s_active_cnt);
                else
                    if i_channels(s_channel_select).active = '1' then
                        s_signal_acc <= s_signal_acc + i_channels(s_channel_select).value;
                        s_active_cnt <= s_active_cnt + 1;
                    end if;
                end if;
                
                s_mult_result <= s_signal_reg * s_reciprocal;
            end if;
        end if;
    end process;
    
    o_mixed_channels <= s_mult_result(SIGNAL_WIDTH + RECIPROCAL_WIDTH - 2 downto RECIPROCAL_WIDTH - 1);

end Behavioral;

