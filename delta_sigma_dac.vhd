----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:51:13 05/05/2025 
-- Design Name: 
-- Module Name:    delta_sigma_dac - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.adsr_multiplier_pkg.all;

entity delta_sigma_dac is
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_sample : in signed(SIGNAL_WIDTH - 1 downto 0);
        o_result : out std_logic
    );
end delta_sigma_dac;

architecture Behavioral of delta_sigma_dac is

    constant ACC_WIDTH : integer := SIGNAL_WIDTH + 2;
    constant MAX_SAMPLE_VAL : integer := 2**(SIGNAL_WIDTH - 1) - 1;
    constant MIN_SAMPLE_VAL : integer := -MAX_SAMPLE_VAL - 1;
    
    signal s_accumulator : signed(ACC_WIDTH - 1 downto 0) := (others => '0');
    signal s_feedback : signed(ACC_WIDTH - 1 downto 0) := (others => '0');
    signal s_result : std_logic := '0';

begin

    o_result <= s_result;
    s_feedback <= to_signed(MIN_SAMPLE_VAL, s_feedback'length) when s_result = '1' else
                  to_signed(MAX_SAMPLE_VAL, s_feedback'length);
    
    process(i_clk)
        variable v_new_acc : signed(ACC_WIDTH - 1 downto 0);
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_accumulator <= (others => '0');
                s_result <= '0';
            else
                v_new_acc := s_accumulator + i_sample + s_feedback;
                if v_new_acc < 0 then
                    s_result <= '0';
                else
                    s_result <= '1';
                end if;
                s_accumulator <= v_new_acc;
            end if;
        end if;
    end process;

end Behavioral;

