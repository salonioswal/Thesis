library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity reg_inv_file is
	port(input_data	: in signed(data_width-1 downto 0);
		 output_data: out signed(data_width-1 downto 0);
		 clock		: in std_logic;
		 reset		: in std_logic;
		 rd_ptr		: in unsigned(ptr_width_inv-1 downto 0);
		 wr_ptr		: in unsigned(ptr_width_inv-1 downto 0);
		 wr_en		: std_logic);
	end reg_inv_file;

architecture beha_reg of reg_inv_file is
	signal register_file: regis_file;
begin


process(clock,reset)
		output_data<=register_file(to_integer(rd_ptr));
begin
	
	if (reset='0') then
		register_file<=((others=>(others=>'0')));
	elsif(rising_edge(clock)) then
		if(wr_en='1') then
		register_file(to_integer(wr_ptr))<=input_data;
		end if;
	end if;
end process;
	
	
end beha_reg;