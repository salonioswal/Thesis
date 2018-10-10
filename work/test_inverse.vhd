library ieee;
library work;
use std.textio.all;           -- basic logic types
use IEEE.std_logic_textio.all; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity test_inverse is
	end test_inverse;

architecture test_invb of test_inverse is
	
		 signal data_input		: signed(data_width-1 downto 0);
		 signal clock			: std_logic;
		 signal reset			: std_logic;
		 signal start			: std_logic;
		 signal wr_en_r			:std_logic;
		 constant time_delay : time := 10 ns;
		 signal store_result_s: std_logic;
		 signal result_output:signed(data_width-1 downto 0);
	
begin
dut: entity work.inv_comb
	port map(data_input=>data_input,
			 clock=>clock,
			 reset=>reset,
			 start=>start,
			wr_en_r=>wr_en_r,
			store_result_s=>store_result_s,
			result_output=>result_output);

	
simulation: process
	begin

reset<='0';
start<='0';
wait for time_delay;
reset<='1';
start<='1';
wait for 1000*time_delay;
end process;

	
process_write: process(clock)
	file my_output : TEXT open WRITE_MODE is "file_io.txt";
	 variable my_line : LINE;
	begin
	if(rising_edge(clock)) then
	 if(store_result_s='1') then
		 write(my_LINE,result_output);
		 writeline(my_output, my_line);
	end if;
	end if;
end process;
		
		
READ_FILE: process
  variable VEC_LINE : line;
  variable VEC_VAR : signed(data_width-1 downto 0);
  file VEC_FILE : text is in "/home/saloni/Documents/Workspace/data_in.txt";
begin
  while not endfile(VEC_FILE) loop
	if(wr_en_r='1') then
    readline (VEC_FILE, VEC_LINE);
    read (VEC_LINE, VEC_VAR);
    data_input <= VEC_VAR;
	end if;
    wait for 10 ns;
  end loop;
  wait;
end process READ_FILE;

	
clkgeneration_FC: process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
	end process clkgeneration_FC;
				
end test_invb;