library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all; 

entity testbench_fcon is
	end testbench_fcon;

architecture behav_test of testbench_fcon is

signal data_input		:  signed(data_width -1 downto 0);--input data
signal data_output 	: signed(2*data_width-1 downto 0);--convolution output
signal rst_n			:  std_logic; --! reset negative
signal clk			:  std_logic; --! clk
signal start   		:  std_logic; --! start signal
		
constant time_delay : time := 10 ns;
begin
dut: entity work.fsm_comb

port map(data_input=>data_input,
		 data_output=>data_output,
		 clk=>clk,
		 start=>start,
		 rst_n=>rst_n
);
	
simulation: process
begin
	data_input<=x"0000";
	start<='0';
	rst_n<='0';
	wait for time_delay;
	rst_n<='1';	
	start<='1';
	wait for time_delay;
	wait for time_delay;
	data_input<=x"0000";
	wait for time_delay;
	data_input<=x"0001";
	wait for time_delay;
	data_input<=x"0002";
	wait for time_delay;
	data_input<=x"0003";
	wait for time_delay;
	wait for 4*time_delay;	
end process;	

clkgeneration_FC: process
	begin
		clk<= '1';
		wait for time_delay/2;
		clk<= '0';
	        wait for time_delay/2;
	end process clkgeneration_FC;
				
end behav_test;


	



		 