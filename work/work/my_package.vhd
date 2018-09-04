library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
use ieee.math_real.all;
package my_package is 
 
constant data_width: integer := 16; --input data widths
CONSTANT n: INTEGER := 2; --Number of rows in the original image taken each time	
constant m: integer:= n*4;
constant c: integer:=8; --histogram intervals
constant ptr_width:integer:=integer(ceil(log2(real(n))));
constant rows: integer:=3;			
constant ptr_width_inv:integer:=integer(ceil(log2(real(rows)))); 
constant ptr_width_norm:integer:=integer(ceil(log2(real(c)))); 


  	 type r_file is array (1 downto 0) of signed(data_width-1 downto 0);
   	type m_file is array (1 downto 0) of r_file;
   	type reg_file is array (n-1 downto 0) of m_file;
   	type sram_coeff is array (m-1 downto 0) of signed(data_width-1 downto 0);
	type regis_file is array (rows-1 downto 0) of signed(data_width-1 downto 0);
	type regis_file_n is array (c-1 downto 0) of signed(data_width-1 downto 0);
	type RF is array (natural range <>) of signed(data_width-1 downto 0);
end my_package; 


package body my_package is 

end my_package;