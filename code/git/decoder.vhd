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
    out_comp : in std_logic_vector(7 downto 0);
    output : out signed(g_size-1 downto 0)
    );
end decoder;

architecture behavioral of decoder is

  signal inp : std_logic_vector(9 downto 0);
  
begin

  inp <= sign_x&sign_y&out_comp;
  
  dec: process(inp)
  begin
    case inp is
      -- First quadrant
      when "0000000000" => output <= to_signed(5,g_size);
      when "0000000001" => output <= to_signed(15,g_size);
      when "0000000011" => output <= to_signed(25,g_size);
      when "0000000111" => output <= to_signed(35,g_size);
      when "0000001111" => output <= to_signed(45,g_size);
      when "0000011111" => output <= to_signed(55,g_size);
      when "0000111111" => output <= to_signed(65,g_size);
      when "0001111111" => output <= to_signed(75,g_size);
      when "0011111111" => output <= to_signed(85,g_size);
      -- Second quadrant
      when "1000000000" => output <= to_signed(175,g_size);
      when "1000000001" => output <= to_signed(165,g_size);
      when "1000000011" => output <= to_signed(155,g_size);
      when "1000000111" => output <= to_signed(145,g_size);
      when "1000001111" => output <= to_signed(135,g_size);
      when "1000011111" => output <= to_signed(125,g_size);
      when "1000111111" => output <= to_signed(115,g_size);
      when "1001111111" => output <= to_signed(105,g_size);
      when "1011111111" => output <= to_signed(95,g_size);
      -- Fourth quadrant
      when "0100000000" => output <= to_signed(-5,g_size);
      when "0100000001" => output <= to_signed(-15,g_size);
      when "0100000011" => output <= to_signed(-25,g_size);
      when "0100000111" => output <= to_signed(-35,g_size);
      when "0100001111" => output <= to_signed(-45,g_size);
      when "0100011111" => output <= to_signed(-55,g_size);
      when "0100111111" => output <= to_signed(-65,g_size);
      when "0101111111" => output <= to_signed(-75,g_size);
      when "0111111111" => output <= to_signed(-85,g_size);
      -- Third quadrant
      when "1100000000" => output <= to_signed(-175,g_size);
      when "1100000001" => output <= to_signed(-165,g_size);
      when "1100000011" => output <= to_signed(-155,g_size);
      when "1100000111" => output <= to_signed(-145,g_size);
      when "1100001111" => output <= to_signed(-135,g_size);
      when "1100011111" => output <= to_signed(-125,g_size);
      when "1100111111" => output <= to_signed(-115,g_size);
      when "1101111111" => output <= to_signed(-105,g_size);
      when "1111111111" => output <= to_signed(-95,g_size);

      when others => output <= to_signed(-1,g_size);
    end case;
  end process;

end behavioral;
