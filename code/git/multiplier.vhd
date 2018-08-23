library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
  generic (
    g_size : integer := 16
    );
  port (
    in1   : in unsigned(g_size-1 downto 0);
    in2   : in unsigned(g_size-1 downto 0); 
    output : out unsigned(2*g_size-1 downto 0)
    );        
end multiplier;  

architecture behavioral of multiplier is
  
begin

  output <= in1*in2;

end behavioral;


  
