--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:03:18 04/07/2025
-- Design Name:   
-- Module Name:   /home/jarek/sources/vhdl/digital_synth/adsr_envelope_tb.vhd
-- Project Name:  digital_synth
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adsr_envelope
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

library work;
use work.adsr_envelope_pkg.all;
 
entity adsr_envelope_tb is
end adsr_envelope_tb;
 
architecture behavior of adsr_envelope_tb is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component adsr_envelope
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_en : in std_logic;
        i_note_on : in std_logic;
        i_adsr_ctrl : in t_adsr_ctrl;
        o_envelope : out t_adsr_envelope
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_en : std_logic := '0';
    signal i_note_on : std_logic := '0';
    signal i_adsr_ctrl : t_adsr_ctrl := (
        attack_step => (others => '0'),
        decay_step => (others => '0'),
        sustain_level => (others => '0'),
        release_step => (others => '0')
    );

 	--Outputs
    signal o_envelope : t_adsr_envelope;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
   
    constant i_clk_freq : integer := 100_000_000;
    constant sample_freq : integer := 48_000;
    constant sample_period : time := 1 sec / sample_freq;
   
    signal clk_en_cnt : integer := 0;

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
    uut: adsr_envelope Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_en => i_en,
        i_note_on => i_note_on,
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

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if clk_en_cnt = (i_clk_freq / sample_freq) - 1 then
                clk_en_cnt <= 0;
                i_en <= '1';
            else
                clk_en_cnt <= clk_en_cnt + 1;
                i_en <= '0';
            end if;
        end if;
    end process;


    -- Stimulus process
    stim_proc: process
    begin		
        -- insert stimulus here
        i_adsr_ctrl.attack_step <= attack_step;
        i_adsr_ctrl.decay_step <= decay_step;
        i_adsr_ctrl.release_step <= release_step;
        i_adsr_ctrl.sustain_level <= sustain_level;
        wait for i_clk_period * 10;

        i_note_on <= '1';
        wait for i_clk_period;
        wait for attack_time;
        wait for decay_time;
        wait for sustain_time;
        i_note_on <= '0';
        wait for i_clk_period;

        wait;
    end process;
   
    -- Process for logging output samples to csv file
    process
        file out_file : text open write_mode is "adsr_dump.csv";
        variable line_buf : line;
    begin
        write(line_buf, "Time,env");
        writeline(out_file, line_buf);
        
        loop
            write(line_buf, now);
            write(line_buf, ",");
            write(line_buf, to_integer(o_envelope.envelope));
            writeline(out_file, line_buf);
            wait until i_en = '1';
        end loop;
    end process;

end;
