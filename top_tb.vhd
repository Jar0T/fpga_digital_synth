--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:58:17 05/05/2025
-- Design Name:   
-- Module Name:   /home/jarek/sources/vhdl/digital_synth/top_tb.vhd
-- Project Name:  digital_synth
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
use work.common_pkg.all;
use work.osc_pkg.all;
use work.adsr_multiplier_pkg.all;
 
entity top_tb is
end top_tb;
 
architecture behavior of top_tb is 

    -- component declaration for the unit under test (uut)

    component top
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_ch_sel : in integer range 0 to N_CHANNELS - 1;
        i_en : in std_logic;
        i_note_on : in std_logic;
        i_note_off : in std_logic;
        i_phase_step : in unsigned(PHASE_WIDTH - 1 downto 0);
        o_result : out std_logic
        );
    end component;

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_ch_sel : integer range 0 to N_CHANNELS - 1 := 0;
    signal i_en : std_logic := '0';
    signal i_note_on : std_logic := '0';
    signal i_note_off : std_logic := '0';
    signal i_phase_step : unsigned(PHASE_WIDTH - 1 downto 0) := (others => '0');

    --Outputs
    signal o_result : std_logic;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;

    constant f_out_base : integer := 220;
    constant f_clk : integer := 100_000_000;
    constant base_phase_step : integer := (f_out_base * (2**PHASE_WIDTH)) / f_clk;
 
begin
 
    -- Instantiate the Unit Under Test (UUT)
    uut: top Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_ch_sel => i_ch_sel,
        i_en => i_en,
        i_note_on => i_note_on,
        i_note_off => i_note_off,
        i_phase_step => i_phase_step,
        o_result => o_result
        );

    -- Clock process definitions
    i_clk_process :process
    begin
        i_clk <= not i_clk;
        wait for i_clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- insert stimulus here
        i_note_on <= '1';
        i_en <= '1';
        for i in 1 to 1 loop
            i_phase_step <= to_unsigned(base_phase_step * i, PHASE_WIDTH);
            i_ch_sel <= i - 1;
            wait for i_clk_period;
        end loop;
        i_en <= '0';
        wait for i_clk_period;

        wait;
    end process;

    -- Process for logging output samples to csv file
--    process
--        file out_file : text open write_mode is "final_signal.csv";
--        variable line_buf : line;
--    begin
--        write(line_buf, "Time,signal");
--        writeline(out_file, line_buf);
--        
--        loop
--            write(line_buf, now);
--            write(line_buf, ",");
--            write(line_buf, to_integer(o_signal));
--            writeline(out_file, line_buf);
--            wait on o_signal;
--        end loop;
--    end process;

end;
