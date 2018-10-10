library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;


entity test_bound is
	end test_bound;
	
architecture bench of test_bound is
	
	signal clock: std_logic;
	signal reset: std_logic;
	signal start: std_logic;
	signal input_data: signed(data_width-1 downto 0);
	constant time_delay : time := 10 ns;

begin
dut: entity work.comb_cal
	port map(clock=>clock,
			 reset=>reset,
			 start=>start,
			 input_data=>input_data);
process
	begin
	reset<='0';
	start<='0';
input_data<=to_signed(1,data_width);
	wait for time_delay;
input_data<=to_signed(1,data_width);
reset<='1';
start<='1';
wait for time_delay;
wait for time_delay;
wait for time_delay;
input_data<=(others=>'0');	
wait for time_delay;
input_data<=(others=>'0');
wait for time_delay;
input_data<=(others=>'0');
wait for time_delay;
input_data<=to_signed(1,data_width);	
wait for time_delay;
input_data<=(others=>'0');
wait for time_delay;
input_data<=(others=>'0');	
wait for time_delay;
input_data<=(others=>'0');
wait for time_delay;
input_data<=to_signed(1,data_width);
wait for time_delay;
wait for 50*time_delay;
end process;
	
clkgeneration_FC: process
	
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
end process clkgeneration_FC;
end  bench;				