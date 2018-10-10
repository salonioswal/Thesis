library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity RF_INVERSE is
	port(input_data	: in signed(data_width-1 downto 0);
		 output_data: out signed(data_width-1 downto 0);
		 clock		: in std_logic;
		 reset		: in std_logic;
		 rd_ptr		: in unsigned(ptr_width_inv-1  downto 0);
		 wr_ptr		: in unsigned(ptr_width_inv-1  downto 0);
		 wr_en		: in std_logic;
		 row_counter   :in unsigned(ptr_width_inv-1 downto 0);
		 diagonal_ele:out signed(data_width-1 downto 0)
		);
	end RF_INVERSE;

architecture beha_reg of RF_INVERSE is
	signal register_file: RF(rows-1 downto 0);
begin

diagonal_ele<=register_file((to_integer(row_counter)));
output_data<=register_file(to_integer(rd_ptr));
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
	
	
end beha_reg;