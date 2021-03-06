library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity test is
	end test;

architecture test_invb of test is
	
		 signal data_input		: signed(data_width-1 downto 0);
		 signal clock			: std_logic;
		 signal reset			: std_logic;
		 signal start			: std_logic;
		 constant time_delay : time := 10 ns;
begin
dut: entity work.inv_comb
	port map(data_input=>data_input,
			 clock=>clock,
			 reset=>reset,
			 start=>start);
	
simulation: process
	begin
data_input<=x"0000";
reset<='0';
start<='0';
wait for time_delay;
reset<='1';
start<='1';

wait for time_delay;
wait for time_delay;
data_input<=x"0001";
wait for time_delay;	
data_input<=x"0000";	
wait for time_delay;
data_input<=x"0000";
wait for time_delay;
wait for time_delay;
wait for time_delay;
wait for time_delay;
data_input<=x"0001";
wait for time_delay;
data_input<=x"0000";
wait for time_delay;
wait for time_delay;
wait for time_delay;
data_input<=x"0001";
wait for time_delay;	
data_input<=x"0001";	
wait for time_delay;	
data_input<=x"0007";
wait for time_delay;	
wait for time_delay;	
wait for time_delay;	
data_input<=x"0001";
wait for time_delay;	
data_input<=x"0000";	
wait for time_delay;	
data_input<=x"0000";
wait for time_delay;
wait for time_delay;
wait for time_delay;
wait for time_delay;
data_input<=x"0001";
wait for time_delay;
data_input<=x"0001";
wait for time_delay;
data_input<=x"0001";
wait for time_delay;
wait for time_delay;
wait for time_delay;
wait for time_delay;
data_input<=x"0003";
wait for time_delay;	
data_input<=x"0007";	
wait for time_delay;	
data_input<=x"0001";
wait for 20*time_delay;	
end process;
	
clkgeneration_FC: process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
	end process clkgeneration_FC;
				
end test_invb;	
	
