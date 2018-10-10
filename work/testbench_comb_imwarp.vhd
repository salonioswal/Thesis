library ieee;
library work;
use std.textio.all;
use IEEE.std_logic_1164.all;            -- basic logic types
use IEEE.std_logic_textio.all; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;


entity test_imwarp is
	end test_imwarp;

architecture arch_ti of test_imwarp is
	
signal clock	:std_logic;
signal reset	: std_logic;
signal start	:  std_logic;
signal coordinate_input: signed(data_width-1 downto 0);
signal input_data: signed(data_width-1 downto 0);
constant time_delay : time := 10 ns;
signal store_result: std_logic;
signal result_out:signed(data_width-1 downto 0);
begin

dut: entity work.comb_imwarp 
	port map(clock=>clock,
			 reset=>reset,
			 start=>start,
			 coordinate_input=>coordinate_input,
			 input_data=>input_data,
			 store_result=>store_result,
			 result_out=>result_out);
	
simulation: process
	begin
		reset<='0';
		start<='0';
		coordinate_input<=(others=>'0');
		input_data<=(others=>'0');
		wait for time_delay;
		reset<='1';
		start<='1';
		wait for time_delay;
		wait for time_delay;
		input_data<=to_signed(1,data_width);
		wait for time_delay;
		input_data<=to_signed(1,data_width);
		wait for time_delay;
		input_data<=to_signed(0,data_width);
		wait for time_delay;
		input_data<=to_signed(0,data_width);
		wait for time_delay;
		input_data<=to_signed(1,data_width);
		wait for time_delay;
		input_data<=to_signed(0,data_width);
		wait for time_delay;
		input_data<=to_signed(0,data_width);
		wait for time_delay;
		input_data<=to_signed(0,data_width);
		wait for time_delay;
		input_data<=to_signed(1,data_width);
		wait for 7*time_delay;
		coordinate_input<=to_signed(2,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(3,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(1,data_width);
		wait for 4*time_delay;
		coordinate_input<=to_signed(3,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(2,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(1,data_width);
		wait for 4*time_delay;
		coordinate_input<=to_signed(5,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(6,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(1,data_width);
		wait for 4*time_delay;
		coordinate_input<=to_signed(7,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(8,data_width);
		wait for time_delay;
		coordinate_input<=to_signed(1,data_width);
		wait for 50*time_delay;
	end process;

			
process_write: process(result_out)
	file my_output : TEXT open WRITE_MODE is "file_io.txt";
	 variable my_line : LINE;
	begin
	 if(store_result='1') then
		 write(my_LINE,result_out);
		 writeline(my_output, my_line);
	end if;
end process;




clkgeneration_FC:process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
end process clkgeneration_FC;
				
end arch_ti;
		
		


