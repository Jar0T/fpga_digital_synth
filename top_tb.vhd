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
        i_rx : in std_logic;
        o_result : out std_logic;
        o_ready : out std_logic;
        o_error : out std_logic
        );
    end component;

    --Inputs
    signal i_clk : std_logic := '0';
    signal i_reset : std_logic := '1';
    signal i_rx : std_logic := '1';

    --Outputs
    signal o_result : std_logic;
    signal o_ready : std_logic;
    signal o_error : std_logic;

    -- Clock period definitions
    constant i_clk_period : time := 10 ns;

    constant baud_period : time := 40 ns;
    
    type byte_array is array(0 to 35) of std_logic_vector(7 downto 0);
    signal s_tx_data : byte_array := (
        X"00", X"02", X"FF", X"FF", X"FF", X"FF", -- Attack 0xFFFFFFFF
        X"00", X"03", X"FF", X"FF", X"FF", X"FF", -- Decay 0xFFFFFFFF
        X"00", X"04", X"FF", X"FF", X"FF", X"FF", -- Sustain 0xFFFFFFFF
        X"00", X"05", X"FF", X"FF", X"FF", X"FF", -- Release 0xFFFFFFFF
        X"00", X"00", X"47", X"27", X"01", X"00", -- Phase step 0x00012747
        X"00", X"01", X"01", X"00", X"00", X"00"  -- Turn note on
    );
 
begin
 
    -- Instantiate the Unit Under Test (UUT)
    uut: top Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_rx => i_rx,
        o_result => o_result,
        o_ready => o_ready,
        o_error => o_error
        );

    -- Clock process definitions
    i_clk_process :process
    begin
        i_clk <= not i_clk;
        wait for i_clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
        procedure send_uart_byte(data : in std_logic_vector(7 downto 0)) is
        begin
            -- start bit
            i_rx <= '0';
            wait for baud_period;
            
            for i in 0 to 7 loop
                i_rx <= data(i);
                wait for baud_period;
            end loop;
            
            i_rx <= '1';
            wait for baud_period;
        end send_uart_byte;
    begin		
        -- insert stimulus here
        wait for baud_period * 5.5;
        
        for i in 0 to 35 loop
            send_uart_byte(s_tx_data(i));
            wait for baud_period;
        end loop;

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
