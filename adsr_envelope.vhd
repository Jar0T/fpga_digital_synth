----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:40:06 04/07/2025 
-- Design Name: 
-- Module Name:    adsr_envelope - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.adsr_envelope_pkg.all;
use work.osc_pkg.all;

entity adsr_envelope is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_note_on : in std_logic;
        i_note_off : in std_logic;
        i_attack_step : in unsigned(31 downto 0);
        i_decay_step : in unsigned(31 downto 0);
        i_sustain_level : in unsigned(31 downto 0);
        i_release_step : in unsigned(31 downto 0);
        i_sample : in signed(15 downto 0);
        o_signal : out signed(15 downto 0)
    );
end adsr_envelope;

architecture Behavioral of adsr_envelope is

    signal s_amplitude : unsigned(31 downto 0) := (others => '0');
    signal s_attack_step : unsigned(31 downto 0) := (others => '0');
    signal s_decay_step : unsigned(31 downto 0) := (others => '0');
    signal s_sustain_level : unsigned(31 downto 0) := (others => '0');
    signal s_release_step : unsigned(31 downto 0) := (others => '0');
    
    signal s_adsr_state : t_adsr_state := IDLE;
    
    signal s_mult_result : unsigned(31 downto 0) := (others => '0');

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_adsr_state <= IDLE;
                s_amplitude <= (others => '0');
            else
                case s_adsr_state is
                    when IDLE =>
                        s_amplitude <= (others => '0');
                        s_attack_step <= i_attack_step;
                        s_decay_step <= i_decay_step;
                        s_sustain_level <= i_sustain_level;
                        s_release_step <= i_release_step;
                        if i_note_on = '1' then
                            s_adsr_state <= ATTACK;
                        end if;
                    
                    when ATTACK =>
                        if i_en = '1' then
                            if s_amplitude < MAX_AMPLITUDE - s_attack_step then
                                s_amplitude <= s_amplitude + s_attack_step;
                            else
                                s_amplitude <= MAX_AMPLITUDE;
                                s_adsr_state <= DECAY;
                            end if;
                        end if;
                    
                    when DECAY =>
                        if i_en = '1' then
                            if s_amplitude > s_sustain_level + s_decay_step then
                                s_amplitude <= s_amplitude - s_decay_step;
                            else
                                s_amplitude <= s_sustain_level;
                                s_adsr_state <= SUSTAIN;
                            end if;
                        end if;
                    
                    when SUSTAIN =>
                        if i_note_off = '1' then
                            s_adsr_state <= RELEASE;
                        end if;
                    
                    when RELEASE =>
                        if i_en = '1' then
                            if s_amplitude <= s_release_step then
                                s_amplitude <= (others => '0');
                                s_adsr_state <= IDLE;
                            else
                                s_amplitude <= s_amplitude - s_release_step;
                            end if;
                        end if;
                    
                end case;
                
                s_mult_result <= unsigned(i_sample) * s_amplitude(31 downto 16);
                o_signal <= signed(s_mult_result(31 downto 16));
            end if;
        end if;
    end process;

end Behavioral;

