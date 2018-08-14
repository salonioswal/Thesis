library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all; 
use work.all;

entity testbench_FSC is
	end testbench_FSc;

architecture tb_FSC of testbench_FSC is
	
signal	data_input	:signed(data_width-1 downto 0);
signal data_output	:signed(2*data_width-1 downto 0);
signal	clock		:std_logic;
signal	start   	:std_logic; --! start signal
signal	rst_n	 	:std_logic; --! reset negative
signal	reset		:std_logic; --sram reset
signal	wr_addr		:unsigned (coeff_width-1 downto 0);
signal	wr_en_sram	:std_logic;

constant time_delay : time := 10 ns;
begin
	dut: entity work.final_sram_con
		port map(data_input=>data_input,
				 data_output=>data_output,
				 clock=>clock,
				 start=>start,
				 rst_n=>rst_n,
				 reset=>reset,
				 wr_addr=>wr_addr,
				 wr_en_sram=>wr_en_sram);

simulation: process
begin
	reset<='0';
	rst_n<='0';
	start<='0';
	wr_addr<=(others => '0');
	wait for time_delay;
		reset<='1';
	wr_en_sram<='1';
	data_input<=x"0000";
	wait for time_delay;
	wr_addr<= wr_addr+1;
	data_input<=x"0001";
	wait for time_delay;
	wr_addr<= wr_addr+1;
	data_input<=x"0002";
	wait for time_delay;
	wr_addr<= wr_addr+1;
	data_input<=x"0003";
	wait for time_delay;
	rst_n<='1';	
	start<='1';
	wait for 15*time_delay;
end process;
	
	clkgeneration_FC: process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
end process clkgeneration_FC;
	
end tb_FSC;	
	
	