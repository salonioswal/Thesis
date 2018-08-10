library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
use ieee.math_real.all;
package mypackage2 is 
 
constant data_width: integer := 16; --input data widths
constant kernel_size:integer:= 4;--kernel size
CONSTANT m: INTEGER := 16; --Number of rows in the original image taken each time	
CONSTANT n: INTEGER := 16; --Number of columns in the original image taken each time	
constant coeff_width:integer:=integer(ceil(log2(real((m+kernel_size-1)*(n+kernel_size-1)))));
constant n_coeff:integer:=(m+kernel_size-1)*(n+kernel_size-1);
			
   type reg_file is array (Natural range<>) of signed(data_width-1 downto 0);
   type coeff_ROM is array (Natural range <>) of signed(15 downto 0);						 
	type output_ROM is array (Natural range <>) of signed(2*data_width-1 downto 0);			
end mypackage2; 


package body mypackage2 is 

end mypackage2;