--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:07:26 05/05/2025
-- Design Name:   
-- Module Name:   /home/jarek/sources/vhdl/digital_synth/mixer_tb.vhd
-- Project Name:  digital_synth
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mixer
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
use work.common_pkg.all;
use work.adsr_multiplier_pkg.all;
 
entity mixer_tb is
end mixer_tb;
 
architecture behavior of mixer_tb is
 
    -- Component Declaration for the Unit Under Test (UUT)

    component mixer
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_channels : in t_signal_array;
        o_mixed_channels : out signed(SIGNAL_WIDTH - 1 downto 0)
        );
    end component;
    

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '0';
    signal i_channels : t_signal_array := (others => (
        value => (others => '0'),
        active => '0'
    ));

 	--Outputs
    signal o_mixed_channels : signed(SIGNAL_WIDTH - 1 downto 0);

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: mixer Port map (
        i_clk => i_clk,
        i_reset => i_reset,
        i_channels => i_channels,
        o_mixed_channels => o_mixed_channels
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
        for i in N_CHANNELS - 1 downto 0 loop
            i_channels(i).value <= (others => '1');
            wait for i_clk_period * N_CHANNELS;
        end loop;
        for i in N_CHANNELS - 1 downto 0 loop
            i_channels(i).value <= (others => '0');
            wait for i_clk_period * N_CHANNELS;
        end loop;
        
        for i in N_CHANNELS - 1 downto 0 loop
            i_channels(i).value <= (others => '1');
            i_channels(i).active <= '1';
            wait for i_clk_period * N_CHANNELS;
        end loop;
        for i in N_CHANNELS - 1 downto 0 loop
            i_channels(i).active <= '0';
            wait for i_clk_period * N_CHANNELS;
        end loop;
        for i in N_CHANNELS - 1 downto 0 loop
            i_channels(i).value <= (others => '0');
            wait for i_clk_period * N_CHANNELS;
        end loop;
        
        -- half positive value
        i_channels(0).value <= X"7FFF";
        i_channels(0).active <= '1';
        i_channels(1).value <= X"0000";
        i_channels(1).active <= '1';
        wait for i_clk_period * N_CHANNELS;
        -- zero
        i_channels(1).value <= X"8000";
        i_channels(1).active <= '1';
        wait for i_clk_period * N_CHANNELS;
        -- half negative value
        i_channels(0).value <= X"0000";
        i_channels(0).active <= '1';
        wait for i_clk_period * N_CHANNELS;
        
        for i in 0 to N_CHANNELS - 1 loop
            i_channels(i).value <= (others => '0');
            i_channels(i).active <= '0';
        end loop;
        wait for i_clk_period * N_CHANNELS;
        
        -- all channels active, but only 1 has non zero value
        for i in N_CHANNELS - 1 downto 0 loop
            i_channels(i).value <= (others => '0');
            i_channels(i).active <= '1';
        end loop;
        i_channels(0).value <= to_signed(2**(SIGNAL_WIDTH - 1) - 1, SIGNAL_WIDTH);
        wait for i_clk_period * N_CHANNELS;
        
        for i in 0 to N_CHANNELS - 1 loop
            i_channels(i).value <= (others => '0');
            i_channels(i).active <= '0';
        end loop;
        wait for i_clk_period * N_CHANNELS;

        wait;
    end process;

end;
