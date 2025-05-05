----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:00:37 04/06/2025 
-- Design Name: 
-- Module Name:    oscillator - Behavioral 
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

entity oscillator is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_phase_step : in t_phase_step_array;
        o_sample : out t_sample_array;
        i_sample_addr : in unsigned(SAMPLE_ADDR_WIDTH - 1 downto 0);
        i_sample_we : in std_logic;
        i_sample : in signed(SAMPLE_WIDTH - 1 downto 0)
    );
end oscillator;

architecture Behavioral of oscillator is

    type t_phase_acc_array is array(0 to N_CHANNELS - 1) of unsigned(PHASE_WIDTH - 1 downto 0);
    signal s_phase_acc : t_phase_acc_array := (others => (others => '0'));
    signal s_step : t_phase_step_array := (others => (others => '0'));
    signal s_sample : t_sample_array := (others => (others => '0'));
    signal s_sel, s_sel_del_1, s_sel_del_2 : integer range 0 to N_CHANNELS - 1 := 0;
    signal s_wave_lut : t_wave_lut := SINE_WAVE_INIT;
    signal s_lut_addr : integer range 0 to 2**SAMPLE_ADDR_WIDTH - 1 := 0;
    signal s_lut_data : signed(SAMPLE_WIDTH - 1 downto 0) := (others => '0');

begin

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_phase_acc <= (others => (others => '0'));
                s_step <= (others => (others => '0'));
                s_sample <= (others => (others => '0'));
                s_sel <= 0;
                s_sel_del_1 <= 0;
                s_sel_del_2 <= 0;
                s_lut_addr <= 0;
                s_lut_data <= (others => '0');
            else
                s_step <= i_phase_step;
                
                for i in 0 to N_CHANNELS - 1 loop
                    s_phase_acc(i) <= s_phase_acc(i) + s_step(i);
                end loop;
                
                s_lut_addr <= to_integer(s_phase_acc(s_sel)(PHASE_WIDTH - 1 downto PHASE_WIDTH - SAMPLE_ADDR_WIDTH));
                s_lut_data <= s_wave_lut(s_lut_addr);
                s_sample(s_sel_del_2) <= s_lut_data;
                s_sel_del_1 <= s_sel;
                s_sel_del_2 <= s_sel_del_1;
                if s_sel = N_CHANNELS - 1 then
                    s_sel <= 0;
                else
                    s_sel <= s_sel + 1;
                end if;
            end if;
        end if;
    end process;
    
    o_sample <= s_sample;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_sample_we = '1' then
                s_wave_lut(to_integer(i_sample_addr)) <= i_sample;
            end if;
        end if;
    end process;

end Behavioral;

