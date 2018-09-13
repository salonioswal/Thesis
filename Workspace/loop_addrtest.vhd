library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity address_calc is
	port(clock:in std_logic;
		 reset:in std_logic;
		 input_x:out signed(data_width-1 downto 0);
		 input_y:out signed(data_width-1 downto 0);
		 module_en:in std_logic
		 
		);
end address_calc;
	
architecture arch_addr of address_calc is
	
begin

process(clock,reset);
variable val_x,val_y: signed(data_wdith-1 downto 0);
val_x:=to_signed(-7,data_width);
val_y:=to_signed(8,data_width);
if(reset='0') then
	input_x<=(others=>'0');
	input_y<=(others=>'0');
elsif(rising_edge(clock)) then
	if(module_en='1') then
		for 
				
end process;
end arch_addr;
				
						