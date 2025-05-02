--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:56:30 05/02/2025
-- Design Name:   
-- Module Name:   /home/jarek/sources/vhdl/digital_synth/adsr_multiplier_tb.vhd
-- Project Name:  digital_synth
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: adsr_multiplier
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

library work;
use work.adsr_multiplier_pkg.all;
use work.adsr_envelope_pkg.all;
use work.common_pkg.all;
use work.osc_pkg.all;
 
entity adsr_multiplier_tb is
end adsr_multiplier_tb;
 
architecture behavior of adsr_multiplier_tb is 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    component adsr_multiplier
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_sample : in t_sample_array;
        i_envelope : in  t_envelope_array;
        o_signal : out t_signal_array
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_sample : t_sample_array := (others => (others => '0'));
    signal i_envelope : t_envelope_array := (others => (
        envelope => (others => '0'),
        active => '0'
    ));

 	--Outputs
    signal o_signal : t_signal_array;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;
 
begin
 
    -- Instantiate the Unit Under Test (UUT)
    uut: adsr_multiplier Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_sample => i_sample,
        i_envelope => i_envelope,
        o_signal => o_signal
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
        -- Test extreme values of i_sample vs max value of envelope
        i_envelope(0).envelope <= X"FFFF";
        
        i_sample(0) <= X"7FFF"; -- Max value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"8000"; -- Min value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"0000"; -- 0
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"0001"; -- 1
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"FFFF"; -- -1
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"4000"; -- Mid positive value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"C000"; -- Mid negative value
        wait for i_clk_period * N_CHANNELS;
        
        -- Test extreme values of i_sample vs small value of envelope
        i_envelope(0).envelope <= X"0001";
        
        i_sample(0) <= X"7FFF"; -- Max value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"8000"; -- Min value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"0000"; -- 0
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"0001"; -- 1
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"FFFF"; -- -1
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"4000"; -- Mid positive value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"C000"; -- Mid negative value
        wait for i_clk_period * N_CHANNELS;
        
        -- Test extreme values of i_sample vs mid value of envelope
        i_envelope(0).envelope <= X"7FFF";
        
        i_sample(0) <= X"7FFF"; -- Max value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"8000"; -- Min value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"0000"; -- 0
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"0001"; -- 1
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"FFFF"; -- -1
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"4000"; -- Mid positive value
        wait for i_clk_period * N_CHANNELS;
        i_sample(0) <= X"C000"; -- Mid negative value
        wait for i_clk_period * N_CHANNELS;
        
        -- Test sample channel correct assignment
        for i in 0 to N_CHANNELS - 1 loop
            i_sample(i) <= to_signed(i, i_sample(i)'length - 2) & "00";
            i_envelope(i).envelope <= X"FFFF";
        end loop;
        wait for i_clk_period * N_CHANNELS * 2;
        
        -- Test sample channel correct assignment
        for i in 0 to N_CHANNELS - 1 loop
            i_sample(i) <= X"8000";
            i_envelope(i).envelope <= to_unsigned(i, 4) & X"000";
        end loop;
        wait for i_clk_period * N_CHANNELS * 2;

        wait;
    end process;

end;
