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
        o_sample: out signed(SAMPLE_WIDTH - 1 downto 0);
        
        o_envelope : out t_adsr_envelope
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
    signal s_sel : integer range 0 to N_CHANNELS - 1 := 0;

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
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if s_sel = N_CHANNELS - 1 then
                s_sel <= 0;
            else
                s_sel <= s_sel + 1;
            end if;
            
            s_phase_step(s_sel) <= i_phase_step;
            
            o_sample <= s_sample(s_sel);
            
            s_note_on(s_sel) <= not s_note_on(s_sel);
            s_note_off(s_sel) <= not s_note_off(s_sel);
            
            s_adsr_ctrl(s_sel).attack_step <=  s_adsr_ctrl(s_sel).attack_step + 1;
            s_adsr_ctrl(s_sel).decay_step <= s_adsr_ctrl(s_sel).decay_step + 1;
            s_adsr_ctrl(s_sel).sustain_level <= s_adsr_ctrl(s_sel).sustain_level + 1;
            s_adsr_ctrl(s_sel).release_step <= s_adsr_ctrl(s_sel).release_step + 1;
            
            o_envelope <= s_envelope(s_sel);
        end if;
    end process;

end Behavioral;

