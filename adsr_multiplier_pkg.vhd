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

package adsr_multiplier_pkg is

    constant SIGNAL_WIDTH : integer := 16;
    
    type t_signal is record
        value : signed(SIGNAL_WIDTH - 1 downto 0);
        active : std_logic;
    end record t_signal;
    
    type t_signal_array is array(0 to N_CHANNELS - 1) of t_signal;

end adsr_multiplier_pkg;

package body adsr_multiplier_pkg is
 
end adsr_multiplier_pkg;
