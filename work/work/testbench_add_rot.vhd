library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity testbench_rot is 
	end testbench_rot;

architecture arch of testbench_rot is
signal clock: std_logic;
signal reset: std_logic;
signal enable: std_logic;
signal output_x:signed(data_width-1 downto 0);
signal output_y:signed(data_width-1 downto 0);
signal bin: unsigned(5 downto 0)
constant time_delay : time := 10 ns;

begin
dut: entity work.address_rot
	port map(clock=>clock,
		reset=>reset,
		enable=>enable,
		output_x=>output_x,
		output_y=>output_y,
		bin=>bin);

simulation: process
	begin
		
		reset<='0';
		en<='0';
		bin<=(others=>'0');
		wait for time_delay;
		reset<='1';
		en<='1';
		wait for 5*time_delay;
		wait for time_delay;
		en<='0';
		wait for time_delay;
		wait for time_delay;
		wait for time_delay;
		en<='1';
		wait for 5*time_delay;
	end process;
			
clkgeneration_FC:process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
end process clkgeneration_FC;
			
end arch;		
			
			
		
		
		
		