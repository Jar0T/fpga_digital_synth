--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common_pkg.all;

package adsr_envelope_pkg is

    constant ADSR_WIDTH : integer := 32;
    constant ENVELOPE_WIDTH : integer := 16;
    constant MAX_AMPLITUDE : unsigned(ADSR_WIDTH - 1 downto 0) := (others => '1');
    
    type t_adsr_ctrl is record
        attack_step : unsigned(ADSR_WIDTH - 1 downto 0);
        decay_step : unsigned(ADSR_WIDTH - 1 downto 0);
        sustain_level : unsigned(ADSR_WIDTH - 1 downto 0);
        release_step : unsigned(ADSR_WIDTH - 1 downto 0);
    end record t_adsr_ctrl;
    
    type t_adsr_ctrl_array is array(0 to N_CHANNELS - 1) of t_adsr_ctrl;
    
    type t_adsr_envelope is record
        envelope : unsigned(ENVELOPE_WIDTH - 1 downto 0);
        active : std_logic;
    end record t_adsr_envelope;
    
    type t_envelope_array is array(0 to N_CHANNELS - 1) of t_adsr_envelope;
    
    type t_adsr_state is (IDLE, ATTACK, DECAY, SUSTAIN, RELEASE);
    
end adsr_envelope_pkg;

package body adsr_envelope_pkg is
 
end adsr_envelope_pkg;
