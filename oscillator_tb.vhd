--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:48:24 04/07/2025
-- Design Name:   
-- Module Name:   /home/jarek/sources/vhdl/digital_synth/oscillator_tb.vhd
-- Project Name:  digital_synth
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: oscillator
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

use ieee.std_logic_textio.all;
use std.textio.all;

library work;
use work.osc_pkg.all;
 
ENTITY oscillator_tb IS
END oscillator_tb;
 
ARCHITECTURE behavior OF oscillator_tb IS
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_phase_step : t_phase_step_array := (others => (others => '0'));
    signal i_sample_addr : unsigned(8 downto 0) := (others => '0');
    signal i_sample_we : std_logic := '0';
    signal i_sample : signed(15 downto 0) := (others => '0');

 	--Outputs
    signal o_sample : t_sample_array;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
    
    constant f_out_base : integer := 110;
    constant f_clk : integer := 100_000_000;
    constant base_phase_step : integer := (f_out_base * (2**PHASE_WIDTH)) / f_clk;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
    uut: oscillator Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_phase_step => i_phase_step,
        o_sample => o_sample,
        i_sample_addr => i_sample_addr,
        i_sample_we => i_sample_we,
        i_sample => i_sample
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
        for i in 0 to N_OSC - 1 loop
            i_phase_step(i) <= to_unsigned(base_phase_step * 2**i, PHASE_WIDTH);
        end loop;

        wait;
    end process;
    
    -- Process for logging output samples to csv file
    process
        file out_file : text open write_mode is "signal_dump.csv";
        variable line_buf : line;
    begin
        write(line_buf, "Time");
        for i in 0 to N_OSC - 1 loop
            write(line_buf, string'(","));
            write(line_buf, "signal");
            write(line_buf, i);
        end loop;
        writeline(out_file, line_buf);
        
        loop
            write(line_buf, now);
            for i in 0 to N_OSC - 1 loop
                write(line_buf, string'(","));
                write(line_buf, to_integer(o_sample(i)));
            end loop;
            writeline(out_file, line_buf);
            wait on o_sample;
        end loop;
    end process;

end;
