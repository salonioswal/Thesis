library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity abs_mod is
  generic (
    g_size : integer := 16
    );
  port (
    input  : in signed(g_size-1 downto 0);
    output : out unsigned(g_size-1 downto 0)
    );        
end abs_mod;  

architecture behavioral of abs_mod is

begin

  process(input)
  begin
    if (input < 0) then
      output <= unsigned(-input);
    else
      output <= unsigned(input);
    end if;
  end process;
   
end behavioral;


  
