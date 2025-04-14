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

package common_pkg is

    constant N_CHANNELS : integer := 8;
    
    constant clk_freq : integer := 100_000_000;
    constant sample_freq : integer := 48_000;

end common_pkg;

package body common_pkg is
 
end common_pkg;
