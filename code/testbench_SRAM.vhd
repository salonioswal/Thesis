Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.misc.all;
use work.mypackage2.all;

entity testbench_SRAM is 
		generic(constant data_width: integer := 16;
			constant kernel_size:integer:= 4;
			CONSTANT m: INTEGER := 16; --Number of rows in the original image taken each time	
			CONSTANT n: INTEGER := 16);
	end testbench_SRAM;
	
architecture b_tb of testbench_SRAM is
	signal rd_addr : unsigned (log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1 downto 0):=(others=>'0');
    signal data_out:  signed (data_width-1 downto 0);
   signal data_in:signed (data_width-1 downto 0);
		signal clock: std_logic;
		signal wr_addr:  unsigned (log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1 downto 0);
		signal wr_en_sram: std_logic;
		signal in_rst_n: std_logic;
	constant time_delay : time := 10 ns;
begin
dut: entity work.SRAM 
port map(rd_addr=>rd_addr,
			 data_out=>data_out,
			 clock=>clock,
			 data_in=>data_in,
			 reset=>in_rst_n,
			 wr_en_sram=>wr_en_sram,
			 wr_addr=>wr_addr);
	
begin
    in_rst_n<= '1';
	
	wr_en_sram<='1';
	data_in<= x"0001";
	wait for time_delay;
	wr_addr<=wr_addr+to_unsigned(1,log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1);
	data_in<= x"0002";
	wait for time_delay;
	wr_addr<=wr_addr+to_unsigned(1,log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1);
	data_in<= x"0003";
	wait for time_delay;
	wr_addr<=wr_addr+to_unsigned(1,log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1);
	data_in<= x"0004";
	wait for time_delay;
	wr_addr<=wr_addr+to_unsigned(1,log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1);
	data_in<= x"0005";
	wait for time_delay;
	wr_en_sram<='0';
	
	wait for 10*time_delay;
	end process;

clkgeneration_FC: process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
	end process clkgeneration_FC;
				
	
end b_tb;