----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:13:49 04/13/2025 
-- Design Name: 
-- Module Name:    adsr_envelope_top - Behavioral 
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
use work.common_pkg.all;
use work.osc_pkg.all;

entity adsr_envelope_top is
    Port (
        i_clk : in  std_logic;
        i_reset : in  std_logic;
        i_note_on : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_note_off : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_adsr_ctrl : in t_adsr_ctrl_array;
        i_sample : in t_sample_array;
        o_signal : out t_signal_array
    );
end adsr_envelope_top;

architecture Behavioral of adsr_envelope_top is

    component adsr_envelope
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_note_on : in std_logic;
        i_note_off : in std_logic;
        i_adsr_ctrl : in t_adsr_ctrl;
        i_sample : in signed(SAMPLE_WIDTH - 1 downto 0);
        o_signal : out signed(SIGNAL_WIDTH - 1 downto 0)
    );
    end component;
    
    signal s_clk_div_cnt : integer := 0;
    signal s_en : std_logic := '0';

begin

    g_generate_envelopes: for i in 0 to N_CHANNELS - 1 generate
    inst_adsr_envelope: adsr_envelope Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => s_en,
        i_note_on => i_note_on(i),
        i_note_off => i_note_off(i),
        i_adsr_ctrl => i_adsr_ctrl(i),
        i_sample => i_sample(i),
        o_signal => o_signal(i)
    );
    end generate g_generate_envelopes;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if s_clk_div_cnt = (clk_freq / sample_freq) - 1 then
                s_clk_div_cnt <= 0;
                s_en <= '1';
            else
                s_clk_div_cnt <= s_clk_div_cnt + 1;
                s_en <= '0';
            end if;
        end if;
    end process;


end Behavioral;

