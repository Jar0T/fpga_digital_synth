----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:41:31 04/16/2025 
-- Design Name: 
-- Module Name:    adsr_multiplier - Behavioral 
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
use work.adsr_multiplier_pkg.all;
use work.adsr_envelope_pkg.all;
use work.common_pkg.all;
use work.osc_pkg.all;

entity adsr_multiplier is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_sample : in t_sample_array;
        i_envelope : in t_envelope_array;
        o_signal : out t_signal_array
    );
end adsr_multiplier;

architecture Behavioral of adsr_multiplier is

    signal s_sample : signed(SAMPLE_WIDTH - 1 downto 0) := (others => '0');
    signal s_envelope : t_adsr_envelope := (
        envelope => (others => '0'),
        active => '0'
    );
    signal s_mult_result : signed(ENVELOPE_WIDTH + SAMPLE_WIDTH downto 0) := (others => '0');
    signal s_ch_sel, s_del0_ch_sel, s_del1_ch_sel : integer range 0 to N_CHANNELS - 1 := 0;

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_sample <= (others => '0');
                s_envelope <= (
                    envelope => (others => '0'),
                    active => '0'
                );
                s_mult_result <= (others => '0');
                s_ch_sel <= 0;
                s_del0_ch_sel <= 0;
            else
                -- stage 1 register inputs
                s_sample <= i_sample(s_ch_sel);
                s_envelope <= i_envelope(s_ch_sel);
                
                -- stage 2 multiply
                s_mult_result <= s_sample * signed('0' & s_envelope.envelope);
                
                -- stage 3 output scaled result
                o_signal(s_del1_ch_sel).value <= s_mult_result(ENVELOPE_WIDTH + SAMPLE_WIDTH - 1 downto ENVELOPE_WIDTH + SAMPLE_WIDTH - SIGNAL_WIDTH);
                o_signal(s_del1_ch_sel).active <= i_envelope(s_del1_ch_sel).active;
                
                if s_ch_sel = 0 then
                    s_ch_sel <= N_CHANNELS - 1;
                else
                    s_ch_sel <= s_ch_sel - 1;
                end if;
                s_del0_ch_sel <= s_ch_sel;
                s_del1_ch_sel <= s_del0_ch_sel;
            end if;
        end if;
    end process;

end Behavioral;

