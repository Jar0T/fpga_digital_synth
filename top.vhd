----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:47:10 04/06/2025 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use work.osc_pkg.all;
use work.common_pkg.all;
use work.adsr_envelope_pkg.all;
use work.adsr_multiplier_pkg.all;

entity top is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        
        i_ch_sel : in integer range 0 to N_CHANNELS - 1;
        i_en : in std_logic;
        
        i_note_on : in std_logic;
        i_note_off : in std_logic;
        i_phase_step : in unsigned(PHASE_WIDTH - 1 downto 0);
        
        o_signal : out signed(SIGNAL_WIDTH - 1 downto 0)
    );
end top;

architecture Behavioral of top is

    component oscillator
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_phase_step : in t_phase_step_array;
        o_sample : out t_sample_array;
        i_sample_addr : in unsigned(SAMPLE_ADDR_WIDTH - 1 downto 0);
        i_sample_we : in std_logic;
        i_sample : in signed(SAMPLE_WIDTH - 1 downto 0)
        );
    end component;
    
    component adsr_envelope_top
    Port (
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        i_note_on : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_note_off : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_adsr_ctrl : in t_adsr_ctrl_array;
        o_envelope : out t_envelope_array
        );
    end component;
    
    component adsr_multiplier
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_sample : in t_sample_array;
        i_envelope : in t_envelope_array;
        o_signal : out t_signal_array
        );
    end component;
    
    component mixer
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_channels : in t_signal_array;
        o_mixed_channels : out signed(SIGNAL_WIDTH - 1 downto 0)
        );
    end component;
    
    signal s_phase_step : t_phase_step_array := (others => (others => '0'));
    signal s_sample : t_sample_array := (others => (others => '0'));
    signal s_note_on : std_logic_vector(N_CHANNELS - 1 downto 0) := (others => '0');
    signal s_note_off : std_logic_vector(N_CHANNELS - 1 downto 0) := (others => '0');
    signal s_adsr_ctrl : t_adsr_ctrl_array := (others => (
        attack_step => (others => '0'),
        decay_step => (others => '0'),
        sustain_level => (others => '0'),
        release_step => (others => '0')
    ));
    signal s_envelope : t_envelope_array := (others => (
        envelope => (others => '0'),
        active => '0'
    ));
    signal s_scaled_signal : t_signal_array := (others => (
        value => (others => '0'),
        active => '0'
    ));

begin

    Inst_oscillator: oscillator Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_phase_step => s_phase_step,
        o_sample => s_sample,
        i_sample_addr => (others => '0'),
        i_sample_we => '0',
        i_sample => (others => '0')
    );
    
    Inst_adsr_envelope_top: adsr_envelope_top Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_note_on => s_note_on,
        i_note_off => s_note_off,
        i_adsr_ctrl => s_adsr_ctrl,
        o_envelope => s_envelope
    );
    
    Inst_adsr_multiplier: adsr_multiplier Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_sample => s_sample,
        i_envelope => s_envelope,
        o_signal => s_scaled_signal
        );
    
    Inst_mixer: mixer Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_channels => s_scaled_signal,
        o_mixed_channels => o_signal
        );
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_en = '1' then
                s_phase_step(i_ch_sel) <= i_phase_step;
                s_note_on(i_ch_sel) <= i_note_on;
                s_note_off(i_ch_sel) <= i_note_off;
            end if;
            
            s_adsr_ctrl(i_ch_sel).attack_step <= (others => '1');
            s_adsr_ctrl(i_ch_sel).decay_step <= (others => '1');
            s_adsr_ctrl(i_ch_sel).sustain_level <= (others => '1');
            s_adsr_ctrl(i_ch_sel).release_step <= (others => '1');
        end if;
    end process;

end Behavioral;

