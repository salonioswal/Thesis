library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
  generic (
    g_size : integer := 16
    );
  port (
    in1   : in unsigned(g_size-1 downto 0);
    in2   : in unsigned(2*g_size-1 downto 0); 
    output : out std_logic
    );        
end comparator;



architecture behavioral of comparator is

signal in_y : unsigned(12+g_size-1 downto 0);
begin

  in_y <= in1&"000000000000";
  process (in_y,in2)
  begin
    if in_y >= in2 then
      output <= '1';
    else 
      output <= '0';
    end if;
  end process;
end architecture;
