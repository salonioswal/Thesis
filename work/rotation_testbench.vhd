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
signal output_x: signed(data_width-1 downto 0);
signal output_y: signed(data_width-1 downto 0);
signal bin: unsigned(5 downto 0);--36 bins(orientation of keypoint for rotation)
signal input_x: signed(data_width-1 downto 0);
signal input_y: signed(data_width-1 downto 0);
signal en: std_logic;
constant time_delay : time := 10 ns;

begin
dut: entity work.rotation 
	port map(clock=>clock,
			 reset=>reset,
			 output_x=>output_x,
			 output_y=>output_y,
			 bin=>bin,
			 input_x=>input_x,
			 input_y=>input_y,
			 en=>en);

simulation: process
	begin
		input_x<=x"0000";
		input_y<=x"0000";
		reset<='0';
		en<='0';
		bin<=(others=>'0');
		wait for time_delay;
		reset<='1';
		en<='1';
		input_x<=x"0001";
		input_y<=x"0002";
		wait for time_delay;
		input_x<=x"0002";
		input_y<=x"0001";
		wait for time_delay;
		input_x<=x"0003";
		input_y<=x"0004";
		wait for time_delay;
		wait for time_delay;
		wait for time_delay;
	end process;
			
clkgeneration_FC:process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
end process clkgeneration_FC;
			
end arch;		
			
			
		
		
		
		