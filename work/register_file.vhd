library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity register_file is
	port(input_data	: in signed(data_width-1 downto 0);
		 output_mat	: out m_file;
		 clock		: in std_logic;
		 reset		: in std_logic;
		 rd_ptr		: in unsigned(ptr_width-1 downto 0);
		 wr_ptr		: in unsigned(ptr_width+1 downto 0);
		 wr_en		: std_logic);
	end register_file;

architecture beh_reg of register_file is
	signal register_file : sram_coeff;
begin
output_mat(0)(0)<=register_file(to_integer(rd_ptr));
output_mat(0)(1)<=register_file(to_integer(rd_ptr+1));
output_mat(1)(0)<=register_file(to_integer(rd_ptr+2));
output_mat(1)(1)<=register_file(to_integer(rd_ptr+3));

process(clock,reset)
	
begin
	
	if (reset='0') then
		register_file<=((others=>(others=>'0')));
	elsif(rising_edge(clock)) then
		if(wr_en='1') then
		register_file(to_integer(wr_ptr))<=input_data;
		end if;
	end if;
end process;
	
	
end beh_reg;