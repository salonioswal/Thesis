library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all;
use work.all;

entity multiplication_basic_element is
  port(clock      : in  std_logic;
       reset      : in  std_logic;
       A_1_data   : in  signed(data_width-1 downto 0); --row data from matrix 1
       A_2_data   : in  signed(data_width-1 downto 0); --row data from matrix 1
       B_data     : in  signed(data_width-1 downto 0); --column data from matrix 2
       Result_1   : out signed(2*data_width-1 downto 0); --even rows (starting from 0)
       Result_2   : out signed(2*data_width-1 downto 0); --odd rows
       store_r    : in  std_logic;
       mac_en     : in  std_logic;
       mac_reset  : in  std_logic
       );
end multiplication_basic_element;

architecture arch_MBE of multiplication_basic_element is

  component mac is
    port (Q0     : in  signed (data_width-1 downto 0);
          Q1     : in  signed (data_width-1 downto 0);
          clock  : in  std_logic;
          reset  : in  std_logic;
          acc    : out signed(2*data_width-1 downto 0);
          mac_en : in  std_logic);
  end component;


  signal acc_1 : signed(2*data_width-1 downto 0);
  signal acc_2 : signed(2*data_width-1 downto 0);

begin

  map_mac_1 : mac port map (Q0     => A_1_data,
                            Q1     => B_data,
                            clock  => clock,
                            reset  => mac_reset,
                            acc    => acc_1,
                            mac_en => mac_en);

  map_mac_2 : mac port map (Q0     => A_2_data,
                            Q1     => B_data,
                            clock  => clock,
                            reset  => mac_reset,
                            acc    => acc_2,
                            mac_en => mac_en);


  clocked_process : process(clock, reset)
  begin
    if(reset = '0') then
      Result_1 <= (others => '0');
      Result_2 <= (others => '0');
    elsif(rising_edge(clock)) then
      if(store_r = '1') then
        Result_1 <= acc_1;
        Result_2 <= acc_2;
      end if;
    end if;
  end process;

end arch_MBE;
