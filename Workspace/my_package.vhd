library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
use ieee.math_real.all;
package my_package is 
 
constant data_width: integer := 16; --input data widths
CONSTANT n: INTEGER := 4; --Number of rows in the original image taken each time	

constant ptr_width:integer:=integer(ceil(log2(real(n))));
			
   
   type r_file is array (1 downto 0) of signed(data_width-1 downto 0);
   type m_file is array (1 downto 0) of r_file;
   type reg_file is array (n-1 downto 0) of m_file;
   type sram_coeff is array (4*n-1 downto 0) of signed(data_width-1 downto 0);
end my_package; 


package body my_package is 

end my_package;