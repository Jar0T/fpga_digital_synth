
-- VHDL Instantiation Created from source file oscillator.vhd -- 23:46:15 04/06/2025
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT oscillator
	PORT(
		i_clk : IN std_logic;
		i_reset : IN std_logic;
		i_step : IN std_logic_vector(31 downto 0);          
		o_sample : OUT std_logic_vector(15 downto 0)
		);
	END COMPONENT;

	Inst_oscillator: oscillator PORT MAP(
		i_clk => ,
		i_reset => ,
		i_step => ,
		o_sample => 
	);


