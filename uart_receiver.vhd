----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:50:20 05/06/2025 
-- Design Name: 
-- Module Name:    uart_receiver - Behavioral 
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

entity uart_receiver is
    Generic (
        g_clk_freq : integer := 100_000_000;    -- 100 MHz
        g_baud_rate : integer := 19200
    );
    Port (
        i_clk : in std_logic;
        i_reset : in std_logic;
        i_rx : in std_logic;
        o_data : out std_logic_vector (7 downto 0);
        o_valid : out std_logic
    );
end uart_receiver;

architecture Behavioral of uart_receiver is

    constant BAUD_TICKS : integer := g_clk_freq / g_baud_rate;
    
    type t_state is (IDLE, START, DATA, STOP);
    signal s_state, s_next_state : t_state := IDLE;
    signal s_baud_count : integer range 0 to BAUD_TICKS-1 := BAUD_TICKS - 1;
    signal s_bit_count : integer range 0 to 7 := 7;
    signal s_shift_reg   : std_logic_vector(7 downto 0) := (others => '0');
    signal s_sample_reg  : std_logic := '1';
    signal s_valid_reg   : std_logic := '0';

begin

    o_valid <= s_valid_reg;
    o_data  <= s_shift_reg;

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                s_state <= IDLE;
            else
                s_state <= s_next_state;
            end if;
        end if;
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if s_state = IDLE then
                s_baud_count <= BAUD_TICKS - 1;
            elsif s_baud_count = 0 then
                s_baud_count <= BAUD_TICKS - 1;
            else
                s_baud_count <= s_baud_count - 1;
            end if;
        end if;
    end process;
    
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if s_state = IDLE then
                s_bit_count <= 7;
                s_shift_reg <= (others => '0');
            elsif s_state = DATA then
                if s_baud_count = 0 then
                    if s_bit_count = 0 then
                        s_bit_count <= 7;
                    else
                        s_bit_count <= s_bit_count - 1;
                    end if;
                elsif s_baud_count = BAUD_TICKS / 2 then
                    s_shift_reg <= i_rx & s_shift_reg(7 downto 1);
                end if;
            end if;
        end if;
    end process;
    
    process(s_state, i_rx, s_baud_count, s_bit_count)
    begin
        case s_state is
            when IDLE =>
                s_valid_reg <= '0';
                if i_rx = '0' then
                    s_next_state <= START;
                else
                    s_next_state <= IDLE;
                end if;
            
            when START =>
                s_valid_reg <= '0';
                if s_baud_count = 0 then
                    s_next_state <= DATA;
                else
                    s_next_state <= START;
                end if;
            
            when DATA =>
                s_valid_reg <= '0';
                if s_baud_count = 0 then
                    if s_bit_count = 0 then
                        s_next_state <= STOP;
                    else
                        s_next_state <= DATA;
                    end if;
                else
                    s_next_state <= DATA;
                end if;
            
            when STOP =>
                if s_baud_count = 0 then
                    s_valid_reg <= '1';
                    s_next_state <= IDLE;
                else
                    s_valid_reg <= '0';
                    s_next_state <= STOP;
                end if;
        end case;
    end process;

end Behavioral;

