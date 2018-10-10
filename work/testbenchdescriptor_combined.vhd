library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity test_decriptor_combined is
	end test_decriptor_combined;

architecture bench of test_decriptor_combined is
	

signal clock:std_logic;
signal reset:std_logic;
signal SRAM_1_in:signed(data_width-1 downto 0);
signal weight:signed(data_width-1 downto 0);
signal start: std_logic;
constant time_delay : time := 10 ns;

begin
dut: entity work.combined 
	port map(clock=>clock,
			 reset=>reset,
			 SRAM_1_in=>SRAM_1_in,
			 weight=>weight,
			 start=>start);
	
process
begin
reset<='0';
start<='0';
weight<=(others=>'0');
SRAM_1_in<=(others=>'0');
wait for time_delay;
reset<='1';
start<='1';
wait for time_delay;
for i in 15 downto 0 loop
	weight<=weight+1;
	SRAM_1_in<=SRAM_1_in +1;
wait for time_delay;
end loop;	
wait for 15*time_delay;
end process;
	
clkgeneration_FC: process
	
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
end process clkgeneration_FC;
				
end bench;		
		
		
		
	
	
	
	
	
	


