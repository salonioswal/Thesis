library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use ieee.math_real.all;
use work.all;

entity test_norm is
end test_norm;
	
architecture arch_norm of test_norm is


signal data_input	:signed(data_width-1 downto 0);
signal clock	   	:std_logic;
signal reset	   	:std_logic;
signal data_output	:signed(data_width-1 downto 0);
signal start		:std_logic;
constant time_delay : time := 10 ns;

begin
	
dut:entity work.normr_comb 
	port map(data_input=>data_input,
			 clock=>clock,
			 reset=>reset,
			 data_output=>data_output,
			 start=>start);
	
simulation: process
	begin
	reset<='0';
	start<='1';
	data_input<=x"1000";
	wait for time_delay;
	reset<='1';
	start<='1';
	wait for time_delay;
	data_input<=x"0800";
	wait for time_delay;
	data_input<=x"0800";
	wait for time_delay;
	data_input<=x"2000";
	wait for time_delay;
	data_input<=x"1000";
	wait for 50*time_delay;
	end process;
		
clkgeneration_FC:process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
end process clkgeneration_FC;
				
end arch_norm;
		