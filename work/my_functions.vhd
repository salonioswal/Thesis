library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.my_package.all; 

PACKAGE my_functions IS

FUNCTION add_truncate (SIGNAL a, b: SIGNED; size: INTEGER)

RETURN SIGNED;
  END my_functions;
----------------------------------------------------------
 PACKAGE BODY my_functions IS
   FUNCTION add_truncate (SIGNAL a, b: SIGNED; size: INTEGER)
          RETURN SIGNED IS
       VARIABLE result: SIGNED (2*data_width-1 DOWNTO 0);
    BEGIN
       result := a + b;
       IF (a(a'left)=b(b'left)) AND
             (result(result'LEFT)/=a(a'left)) THEN
          result := (result'LEFT => a(a'LEFT),
                     OTHERS => NOT a(a'left));
       END IF;
       RETURN result;
    END add_truncate;
 END my_functions;