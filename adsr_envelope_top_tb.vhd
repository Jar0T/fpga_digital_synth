--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:00:16 04/14/2025
-- Design Name:   
-- Module Name:   /home/jarek/sources/vhdl/digital_synth/adsr_envelope_top_tb.vhd
-- Project Name:  digital_synth
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adsr_envelope_top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

library work;
use work.adsr_envelope_pkg.all;
use work.common_pkg.all;
use work.osc_pkg.all;
 
entity adsr_envelope_top_tb is
end adsr_envelope_top_tb;
 
architecture behavior of adsr_envelope_top_tb is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component adsr_envelope_top
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_note_on : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_note_off : in std_logic_vector(N_CHANNELS - 1 downto 0);
        i_adsr_ctrl : in t_adsr_ctrl_array;
        o_envelope : out t_envelope_array
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_note_on : std_logic_vector(N_CHANNELS - 1 downto 0) := (others => '0');
    signal i_note_off : std_logic_vector(N_CHANNELS - 1 downto 0) := (others => '0');
    signal i_adsr_ctrl : t_adsr_ctrl_array := (others => (
        attack_step => (others => '0'),
        decay_step => (others => '0'),
        sustain_level => (others => '0'),
        release_step => (others => '0')
    ));

 	--Outputs
    signal o_envelope : t_envelope_array;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
    
    constant sample_period : time := 1 sec / sample_freq;
    
    constant attack_time : time := 3 ms;
    constant decay_time : time := 4 ms;
    constant sustain_level : unsigned(31 downto 0) := X"3333_3333";
    constant release_time : time := 5 ms;
    constant sustain_time : time := 6 ms;
   
    constant attack_step : unsigned(31 downto 0) := MAX_AMPLITUDE / to_unsigned(integer(attack_time / sample_period), 32);
    constant decay_step : unsigned(31 downto 0) := (MAX_AMPLITUDE - sustain_level) / to_unsigned(integer(decay_time / sample_period), 32);
    constant release_step : unsigned(31 downto 0) := sustain_level / to_unsigned(integer(release_time / sample_period), 32);

begin
 
	-- Instantiate the Unit Under Test (UUT)
    uut: adsr_envelope_top Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_note_on => i_note_on,
        i_note_off => i_note_off,
        i_adsr_ctrl => i_adsr_ctrl,
        o_envelope => o_envelope
        );

    -- Clock process definitions
    i_clk_process :process
    begin
        i_clk <= '0';
        wait for i_clk_period/2;
        i_clk <= '1';
        wait for i_clk_period/2;
    end process;
 

    -- Stimulus process
    stim_proc: process
    begin		
        -- insert stimulus here
        for i in 0 to N_CHANNELS - 1 loop
            i_adsr_ctrl(i).attack_step <= attack_step;
            i_adsr_ctrl(i).decay_step <= decay_step;
            i_adsr_ctrl(i).release_step <= release_step;
            i_adsr_ctrl(i).sustain_level <= sustain_level;
        end loop;
        
        wait for i_clk_period * 10;
        
        i_note_on(0) <= '1';
        i_note_on(1) <= '1';
        wait for i_clk_period;
        i_note_on(0) <= '0';
        i_note_on(1) <= '0';
        wait for attack_time;
        wait for decay_time;
        wait for sustain_time;
        i_note_off(0) <= '1';
        i_note_off(1) <= '1';
        wait for i_clk_period;
        i_note_off(0) <= '0';
        i_note_off(1) <= '0';

        wait;
    end process;
    
    -- Process for logging output samples to csv file
    process
        file out_file : text open write_mode is "adsr_dump.csv";
        variable line_buf : line;
    begin
        write(line_buf, "Time");
        for i in 0 to N_CHANNELS - 1 loop
            write(line_buf, ",");
            write(line_buf, "env");
            write(line_buf, i);
        end loop;
        writeline(out_file, line_buf);
        
        loop
            write(line_buf, now);
            for i in 0 to N_CHANNELS - 1 loop
                write(line_buf, ",");
                write(line_buf, to_integer(o_envelope(i).envelope));
            end loop;
            writeline(out_file, line_buf);
            wait for sample_period;
        end loop;
    end process;

end;
