library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity SRAM_d is
	
PORT ( 	rd_addr	 	: in unsigned (9 downto 0);
       	data_out 	: out signed (data_width-1 downto 0);
		data_in 	: in signed (data_width-1 downto 0);
		clock		: in std_logic;
		wr_addr		: in unsigned (9 downto 0);
		wr_en_sram	: in std_logic;
		reset		: in std_logic);
END SRAM_d;

ARCHITECTURE behavior OF SRAM_d IS 
	
signal all_coeffs: RF(1023 downto 0);

begin
	process (rd_addr,all_coeffs)
		variable address : integer := 0;
	begin
		address := to_integer(rd_addr);
		data_out <= all_coeffs(address);
	end process;
--data_out<=all_coeffs(to_integer(rd_addr)); 					
	

write_procedure: process(reset, clock) 
begin
	if reset= '0' then
	all_coeffs <= (others =>(others => '0'));  
	elsif rising_edge(clock) then 
			if(wr_en_sram='1') then
				all_coeffs(to_integer(wr_addr))<= data_in; --write the input data 
			end if;
	end if;
end process;
 

END behavior;
			