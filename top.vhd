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
        i_rx : in std_logic;
        o_result : out std_logic;
        o_ready : out std_logic;
        o_error : out std_logic
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
    
    component delta_sigma_dac
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_sample : in signed(SIGNAL_WIDTH - 1 downto 0);
        o_result : out std_logic
        );
    end component;
    
    component uart_receiver
    Generic (
        g_clk_freq : integer := 100_000_000;    -- 100 MHz
        g_baud_rate : integer := 115_200
        );
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_rx : in std_logic;
        o_data : out std_logic_vector (7 downto 0);
        o_valid : out std_logic
        );
    end component;
    
    signal s_phase_step : t_phase_step_array := (others => (others => '0'));
    signal s_sample : t_sample_array := (others => (others => '0'));
    signal s_note_on : std_logic_vector(N_CHANNELS - 1 downto 0) := (others => '0');
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
    signal s_mixed_signal : signed(SIGNAL_WIDTH - 1 downto 0) := (others => '0');
    
    signal s_rx_data : std_logic_vector(7 downto 0) := (others => '0');
    signal s_rx_valid : std_logic := '0';
    
    signal s_channel, s_register : integer range 0 to 255 := 0;
    signal s_rx_byte_num : integer range 0 to 5 := 0; -- channel + reg addr + 1-4 data bytes
    
    signal s_reset, s_ready, s_error : std_logic := '0';

begin

    s_reset <= not i_reset;
    o_ready <= s_ready;
    o_error <= s_error;

    Inst_oscillator: oscillator Port map(
        i_clk => i_clk,
        i_reset => s_reset,
        i_phase_step => s_phase_step,
        o_sample => s_sample,
        i_sample_addr => (others => '0'),
        i_sample_we => '0',
        i_sample => (others => '0')
    );
    
    Inst_adsr_envelope_top: adsr_envelope_top Port map(
        i_clk => i_clk,
        i_reset => s_reset,
        i_note_on => s_note_on,
        i_adsr_ctrl => s_adsr_ctrl,
        o_envelope => s_envelope
    );
    
    Inst_adsr_multiplier: adsr_multiplier Port map(
        i_clk => i_clk,
        i_reset => s_reset,
        i_sample => s_sample,
        i_envelope => s_envelope,
        o_signal => s_scaled_signal
        );
    
    Inst_mixer: mixer Port map(
        i_clk => i_clk,
        i_reset => s_reset,
        i_channels => s_scaled_signal,
        o_mixed_channels => s_mixed_signal
        );
    
    Inst_delta_sigma_dac: delta_sigma_dac Port map(
        i_clk => i_clk,
        i_reset => s_reset,
        i_sample => s_mixed_signal,
        o_result => o_result
        );
    
    Inst_uart_receiver: uart_receiver
    Generic map(
        g_clk_freq => clk_freq,
        g_baud_rate => 115_200
        )
    Port map(
        i_clk => i_clk,
        i_reset => s_reset,
        i_rx => i_rx,
        o_data => s_rx_data,
        o_valid => s_rx_valid
        );
    
    process(i_clk, s_rx_valid, s_reset)
    begin
        if rising_edge(i_clk) then
            if s_reset = '1' then
                s_rx_byte_num <= 0;
                s_error <= '0';
                s_note_on <= (others => '0');
            elsif s_rx_valid = '1' then
                case s_rx_byte_num is
                    when 0 =>
                        s_channel <= to_integer(unsigned(s_rx_data));
                        s_rx_byte_num <= s_rx_byte_num + 1;
                    
                    when 1 =>
                        s_register <= to_integer(unsigned(s_rx_data));
                        s_rx_byte_num <= s_rx_byte_num + 1;
                    
                    when 2 =>
                        s_rx_byte_num <= s_rx_byte_num + 1;
                        case s_register is
                            when 0 =>
                                s_phase_step(s_channel)(7 downto 0) <= unsigned(s_rx_data);
                            
                            when 1 =>
                                s_note_on(s_channel) <= s_rx_data(0);
                            
                            when 2 =>
                                s_adsr_ctrl(s_channel).attack_step(7 downto 0) <= unsigned(s_rx_data);
                            
                            when 3 =>
                                s_adsr_ctrl(s_channel).decay_step(7 downto 0) <= unsigned(s_rx_data);
                            
                            when 4 =>
                                s_adsr_ctrl(s_channel).sustain_level(7 downto 0) <= unsigned(s_rx_data);
                            
                            when 5 =>
                                s_adsr_ctrl(s_channel).release_step(7 downto 0) <= unsigned(s_rx_data);
                                
                            when others =>
                                s_error <= '1';
                            
                        end case;
                    
                    when 3 =>
                        s_rx_byte_num <= s_rx_byte_num + 1;
                        case s_register is
                            when 0 =>
                                s_phase_step(s_channel)(15 downto 8) <= unsigned(s_rx_data);
                            
                            when 1 =>
                            
                            when 2 =>
                                s_adsr_ctrl(s_channel).attack_step(15 downto 8) <= unsigned(s_rx_data);
                            
                            when 3 =>
                                s_adsr_ctrl(s_channel).decay_step(15 downto 8) <= unsigned(s_rx_data);
                            
                            when 4 =>
                                s_adsr_ctrl(s_channel).sustain_level(15 downto 8) <= unsigned(s_rx_data);
                            
                            when 5 =>
                                s_adsr_ctrl(s_channel).release_step(15 downto 8) <= unsigned(s_rx_data);
                                
                            when others =>
                                s_error <= '1';
                            
                        end case;
                    
                    when 4 =>
                        s_rx_byte_num <= s_rx_byte_num + 1;
                        case s_register is
                            when 0 =>
                                s_phase_step(s_channel)(23 downto 16) <= unsigned(s_rx_data);
                            
                            when 1 =>
                            
                            when 2 =>
                                s_adsr_ctrl(s_channel).attack_step(23 downto 16) <= unsigned(s_rx_data);
                            
                            when 3 =>
                                s_adsr_ctrl(s_channel).decay_step(23 downto 16) <= unsigned(s_rx_data);
                            
                            when 4 =>
                                s_adsr_ctrl(s_channel).sustain_level(23 downto 16) <= unsigned(s_rx_data);
                            
                            when 5 =>
                                s_adsr_ctrl(s_channel).release_step(23 downto 16) <= unsigned(s_rx_data);
                                
                            when others =>
                                s_error <= '1';
                            
                        end case;
                    
                    when 5 =>
                        s_rx_byte_num <= 0;
                        case s_register is
                            when 0 =>
                                s_phase_step(s_channel)(31 downto 24) <= unsigned(s_rx_data);
                            
                            when 1 =>
                            
                            when 2 =>
                                s_adsr_ctrl(s_channel).attack_step(31 downto 24) <= unsigned(s_rx_data);
                            
                            when 3 =>
                                s_adsr_ctrl(s_channel).decay_step(31 downto 24) <= unsigned(s_rx_data);
                            
                            when 4 =>
                                s_adsr_ctrl(s_channel).sustain_level(31 downto 24) <= unsigned(s_rx_data);
                            
                            when 5 =>
                                s_adsr_ctrl(s_channel).release_step(31 downto 24) <= unsigned(s_rx_data);
                                
                            when others =>
                                s_error <= '1';
                            
                        end case;
                    
                    when others =>
                        s_rx_byte_num <= 0;
                        s_error <= '1';
                        
                end case;
            end if;
        end if;
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if s_reset = '1' then
                s_ready <= '0';
            else
                if s_error = '1' then
                    s_ready <= '0';
                else
                    s_ready <= '1';
                end if;
            end if;
        end if;
    end process;

end Behavioral;

