library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;

package mypackage2 is 
 constant row: integer:= 3;
 constant col: integer:= 3;
 constant data_width: integer:=16;
			
   type reg_file is array (Natural range<>) of signed(data_width-1 downto 0);
   --type image_x is array (Natural range<>) of reg_file;
	
	type coeff_ROM is array (Natural range <>) of signed(15 downto 0);						 

end mypackage2; 


package body mypackage2 is 

end mypackage2;