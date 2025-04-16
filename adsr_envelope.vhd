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
        i_adsr_ctrl : in t_adsr_ctrl;
        o_envelope : out unsigned(ENVELOPE_WIDTH - 1 downto 0);
        o_active : out std_logic
    );
end adsr_envelope;

architecture Behavioral of adsr_envelope is

    signal s_amplitude : unsigned(ADSR_WIDTH - 1 downto 0) := (others => '0');
    signal s_attack_step : unsigned(ADSR_WIDTH - 1 downto 0) := (others => '0');
    signal s_decay_step : unsigned(ADSR_WIDTH - 1 downto 0) := (others => '0');
    signal s_sustain_level : unsigned(ADSR_WIDTH - 1 downto 0) := (others => '0');
    signal s_release_step : unsigned(ADSR_WIDTH - 1 downto 0) := (others => '0');
    signal s_active : std_logic := '0';
    
    signal s_adsr_state : t_adsr_state := IDLE;

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_adsr_state <= IDLE;
                s_amplitude <= (others => '0');
                s_active <= '0';
            else
                case s_adsr_state is
                    when IDLE =>
                        s_active <= '0';
                        s_amplitude <= (others => '0');
                        s_attack_step <= i_adsr_ctrl.attack_step;
                        s_decay_step <= i_adsr_ctrl.decay_step;
                        s_sustain_level <= i_adsr_ctrl.sustain_level;
                        s_release_step <= i_adsr_ctrl.release_step;
                        if i_note_on = '1' then
                            s_adsr_state <= ATTACK;
                        end if;
                    
                    when ATTACK =>
                        s_active <= '1';
                        if i_en = '1' then
                            if s_amplitude < MAX_AMPLITUDE - s_attack_step then
                                s_amplitude <= s_amplitude + s_attack_step;
                            else
                                s_amplitude <= MAX_AMPLITUDE;
                                s_adsr_state <= DECAY;
                            end if;
                        end if;
                    
                    when DECAY =>
                        s_active <= '1';
                        if i_en = '1' then
                            if s_amplitude > s_sustain_level + s_decay_step then
                                s_amplitude <= s_amplitude - s_decay_step;
                            else
                                s_amplitude <= s_sustain_level;
                                s_adsr_state <= SUSTAIN;
                            end if;
                        end if;
                    
                    when SUSTAIN =>
                        s_active <= '1';
                        if i_note_off = '1' then
                            s_adsr_state <= RELEASE;
                        end if;
                    
                    when RELEASE =>
                        s_active <= '1';
                        if i_en = '1' then
                            if s_amplitude <= s_release_step then
                                s_amplitude <= (others => '0');
                                s_adsr_state <= IDLE;
                            else
                                s_amplitude <= s_amplitude - s_release_step;
                            end if;
                        end if;
                    
                end case;
                
                o_active <= s_active;
                o_envelope <= s_amplitude(ADSR_WIDTH - 1 downto ADSR_WIDTH - ENVELOPE_WIDTH);
            end if;
        end if;
    end process;

end Behavioral;

