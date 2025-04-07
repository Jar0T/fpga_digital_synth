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

entity top is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_step : in unsigned(31 downto 0);
        o_sample : out signed(15 downto 0);
        o_signal : out std_logic;
        i_sample_addr : in unsigned(8 downto 0);
        i_sample_we : in std_logic;
        i_sample : in signed(15 downto 0)
    );
end top;

architecture Behavioral of top is

    component oscillator
    Port(
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_step : in unsigned(31 downto 0);          
        o_sample : out signed(15 downto 0);
        i_sample_addr : in unsigned(8 downto 0);
        i_sample_we : in std_logic;
        i_sample : in signed(15 downto 0)
        );
    end component;

begin

    Inst_oscillator: oscillator Port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_step => i_step,
        o_sample => o_sample,
        i_sample_addr => i_sample_addr,
        i_sample_we => i_sample_we,
        i_sample => i_sample
    );
    
    o_signal <= '0';

end Behavioral;

