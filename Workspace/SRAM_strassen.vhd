library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity sram_strassen is
	port(input_data: in signed(data_width-1 downto 0);
		 output_data: out signed(data_width-1 downto 0);
		 wr_ptr: in unsigned(ptr_width+1 downto 0);
		 rd_ptr: in unsigned(ptr_width+1 downto 0);
		 clock: in std_logic;
		 reset: in std_logic;
		 wr_en: in std_logic);
	end sram_strassen;
	
architecture sram_beh of sram_strassen is
signal all_coeffs: sram_coeff;	
		

begin
	process (rd_ptr,all_coeffs)
		variable address : integer := 0;
	begin
		address := to_integer(rd_ptr);
		output_data <= all_coeffs(address);
	end process;

process(clock,reset)
begin
	if (reset='0') then
		all_coeffs <= (others =>(others => '0'));  
	elsif(rising_edge(clock)) then
		if(wr_en='1') then
		all_coeffs(to_integer(wr_ptr))<=input_data;
		end if;
	end if;
end process;
	
	
end sram_beh;