library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity tb_sram is
	end tb_sram;
	
architecture tb_sram_beh of tb_sram is
		 signal input_data:signed(data_width-1 downto 0);
		 signal output_data:signed(data_width-1 downto 0);
		 signal wr_ptr:unsigned(ptr_width+1 downto 0):=(others=>'0');
		 signal rd_ptr: unsigned(ptr_width+1 downto 0):=(others=>'0');
		 signal clock: std_logic;
		 signal reset: std_logic;
		 signal wr_en: std_logic:='0';
constant time_delay : time := 10 ns;
begin
	
dut: entity work.sram_strassen 
	port map( input_data=>input_data,
			 output_data=>output_data,
			 wr_ptr=>wr_ptr,
			 rd_ptr=>rd_ptr,
			 clock=>clock,
			 reset=>reset,
			 wr_en=>wr_en);

simulation: process
	begin
	reset<='0';
	wait for time_delay;
	input_data<=x"0000";
	reset<='1';
	wr_en<='1';
	wait for time_delay;
	input_data<=x"0000";
	wait for time_delay;
	wr_ptr<=wr_ptr+1;
	input_data<=x"0001";
	wait for time_delay;
	input_data<=x"0000";
	wr_ptr<=wr_ptr+1;
	wait for time_delay;
	wr_ptr<=wr_ptr+1;
	input_data<=x"0001";
	rd_ptr<=rd_ptr+1;
	wait for time_delay;
	rd_ptr<=rd_ptr+1;
	wait for time_delay;
	rd_ptr<=rd_ptr+1;
	
	wait for 200*time_delay;
end process;

clkgeneration_FC: process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
	end process clkgeneration_FC;
end tb_sram_beh;