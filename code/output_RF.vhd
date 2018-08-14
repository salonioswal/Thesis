library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all; 
use work.all;


entity RF_output is
	
PORT ( 	rd_addr	 	: in unsigned (coeff_width-1 downto 0);
       	dataout 	: out signed (2*data_width-1 downto 0);
		datain 		: in signed (2*data_width-1 downto 0);
		clock		: in std_logic;
		wr_addr		: in unsigned (coeff_width-1 downto 0);
		wr_en_rf	: in std_logic;
		reset		: in std_logic);
END RF_output;

ARCHITECTURE behavior OF RF_output IS 
	
signal all_coeffs: output_ROM(n_coeff-1 downto 0);

begin
	process (rd_addr,all_coeffs)
		variable address : integer := 0;
	begin
		address := to_integer(rd_addr);
		dataout <= all_coeffs(address);
	end process;
--data_out<=all_coeffs(to_integer(rd_addr)); 					
	

write_procedure: process(reset, clock) 
begin
	if reset= '0' then
	all_coeffs <= (others =>(others => '0'));  
	elsif rising_edge(clock) then 
			if(wr_en_rf='1') then
				all_coeffs(to_integer(wr_addr))<= datain; --write the input data 
			end if;
	end if;
end process;
 

END behavior;
			