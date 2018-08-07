Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.misc.all;
use work.mypackage2.all;

entity SRAM is
	generic(constant data_width: integer := 16;
			constant kernel_size:integer:= 4;
			CONSTANT m: INTEGER := 16; --Number of rows in the original image taken each time	
			CONSTANT n: INTEGER := 16);

PORT ( 	rd_addr : in unsigned (log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1 downto 0);
       	data_out: out signed (data_width-1 downto 0);
		data_in:in signed (data_width-1 downto 0);
		clock: in std_logic;
		wr_addr: in unsigned (log2_ceil((m+kernel_size-1)*(n+kernel_size-1))-1 downto 0);
		wr_en_sram: in std_logic;
		reset: in std_logic);
END SRAM;

ARCHITECTURE behavior OF SRAM IS 
	
signal all_coeffs: coeff_ROM((m+kernel_size-1)*(n+kernel_size-1)-1 downto 0);

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
			