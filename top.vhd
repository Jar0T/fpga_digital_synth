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

entity top is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        
        i_phase_step : in unsigned(PHASE_WIDTH - 1 downto 0);
        i_sample_addr : in unsigned(8 downto 0);
        i_sample_we : in std_logic;
        i_sample : in signed(15 downto 0);
        
        i_note_on : in std_logic;
        i_note_off : in std_logic;
        i_adsr_ctrl : in t_adsr_ctrl;
        
        o_signal: out signed(SIGNAL_WIDTH - 1 downto 0)
    );
end top;

architecture Behavioral of top is

    component oscillator
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_phase_step : in t_phase_step_array;
        o_sample : out t_sample_array;
        i_sample_addr : in unsigned(8 downto 0);
        i_sample_we : in std_logic;
        i_sample : in signed(15 downto 0)
        );
    end component;
    
    component adsr_envelope_top
    Port (
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        i_note_on : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_note_off : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_adsr_ctrl : in t_adsr_ctrl_array;
        i_sample : in t_sample_array;
        o_signal : out t_signal_array
        );
    end component;
    
    signal s_phase_step : t_phase_step_array := (others => (others => '0'));
    signal s_sample : t_sample_array := (others => (others => '0'));
    signal s_signal : t_signal_array := (others => (others => '0'));
    signal s_note_on : std_logic_vector(N_CHANNELS - 1 downto 0) := (others => '0');
    signal s_note_off : std_logic_vector(N_CHANNELS - 1 downto 0) := (others => '0');
    signal s_adsr_ctrl : t_adsr_ctrl_array := (others => (
        attack_step => (others => '0'),
        decay_step => (others => '0'),
        sustain_level => (others => '0'),
        release_step => (others => '0')
    ));
    signal s_sel : integer range 0 to N_CHANNELS - 1 := 0;

begin

    Inst_oscillator: oscillator Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_phase_step => s_phase_step,
        o_sample => s_sample,
        i_sample_addr => i_sample_addr,
        i_sample_we => i_sample_we,
        i_sample => i_sample
    );
    
    Inst_adsr_envelope_top: adsr_envelope_top Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_note_on => s_note_on,
        i_note_off => s_note_off,
        i_adsr_ctrl => s_adsr_ctrl,
        i_sample => s_sample,
        o_signal => s_signal
    );
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            s_sel <= s_sel + 1;
            s_phase_step(s_sel) <= i_phase_step;
            
            s_note_on(s_sel) <= i_note_on;
            s_note_off(s_sel) <= i_note_off;
            s_adsr_ctrl(s_sel) <= i_adsr_ctrl;
            
            o_signal <= s_signal(s_sel);
        end if;
    end process;

end Behavioral;

