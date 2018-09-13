library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
  generic (
    g_size : integer := 16
    );
  port (
    sign_x   : in std_logic;
    sign_y   : in std_logic;
    out_comp : in std_logic_vector(1 downto 0);
    output : out signed(g_size-1 downto 0)
    );
end decoder;

architecture behavioral of decoder is

  signal inp : std_logic_vector(3 downto 0);
  
begin

  inp <= sign_x&sign_y&out_comp;
  
  dec: process(inp)
  begin
    case inp is
      -- First quadrant
      when "0000" => output <= to_signed(1,g_size);
      when "0001" => output <= to_signed(2,g_size);
     
      -- Second quadrant
      when "1000" => output <= to_signed(3,g_size);
      when "1001" => output <= to_signed(4,g_size);
      
      -- Fourth quadrant
      when "0100" => output <= to_signed(5,g_size);
      when "0101" => output <= to_signed(6,g_size);
      
      -- Third quadrant
      when "1100" => output <= to_signed(7,g_size);
      when "1101" => output <= to_signed(8,g_size);
      

      when others => output <= to_signed(-1,g_size);
    end case;
  end process;

end behavioral;
