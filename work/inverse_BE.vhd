library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all;

use work.all;

entity BE_inverse is
  port(data_input     : in  signed(data_width-1 downto 0);
       clock          : in  std_logic;
       reset          : in  std_logic;
       column_counter : in  unsigned(ptr_width_inv-1 downto 0);
       row_counter    : in  unsigned(ptr_width_inv-1 downto 0);
       mac_en         : in  std_logic;
       mac_reset      : in  std_logic;
       addr           : in  unsigned(ptr_width_inv-1 downto 0);
       subtract_en    : in  std_logic;
       div_en         : in  std_logic;
       store_en       : in  std_logic;
       diagonal_ele   : in  signed(data_width-1 downto 0);
       store_result   : in  std_logic;
       result_out     : out signed(data_width-1 downto 0);
       store_ptr      : in  unsigned(ptr_width_inv-1 downto 0)
       );
end BE_inverse;

architecture inv_beh of BE_inverse is

  component mac is
    port (Q0     : in  signed (data_width-1 downto 0);
          Q1     : in  signed (data_width-1 downto 0);
          clock  : in  std_logic;
          reset  : in  std_logic;
          acc    : out signed(2*data_width-1 downto 0);
          mac_en : in  std_logic
          );
  end component;

--divider module                
  component DW_div_pipe is
    generic (
      a_width     : positive;           -- divisor word width
      b_width     : positive;           -- dividend word width
      tc_mode     : natural  := 0;      -- '0' : unsigned, '1' : 2's compl.
      rem_mode    : natural  := 1;      -- '0' : modulus, '1' : remainder
      num_stages  : positive := 2;      -- number of pipeline stages
      stall_mode  : natural  := 1;  -- '0' : non-stallable, '1' : stallable
      rst_mode    : natural  := 1;      -- '0' : none, '1' : async, '2' : sync
      op_iso_mode : natural  := 0);     -- operand isolation selection
    port (
      clk         : in  std_logic;      -- register clock
      rst_n       : in  std_logic;      -- register reset
      en          : in  std_logic;      -- register enable
      a           : in  signed(a_width-1 downto 0);  -- divisor
      b           : in  signed(b_width-1 downto 0);  -- dividend
      quotient    : out signed(a_width-1 downto 0);  -- quotient
      remainder   : out signed(b_width-1 downto 0);  -- remainder
      divide_by_0 : out std_logic);  -- divide by                                                            -- zero flag
  end component;


  signal acc      : signed(2*data_width-1 downto 0);  --accumulator_mac
  signal x        : output_ROM(rows-1 downto 0);    --column output
  signal B        : output_ROM(rows-1 downto 0);    --column of identity matrix
  signal ele_x    : signed(data_width-1 downto 0);  --element of column for multiplication
--SIGNAL data_in        :signed(data_width-1 downto 0);         --data_input from RF
  signal result   : signed(2*data_width-1 downto 0);
  signal div_in_1 : signed(2*data_width-1 downto 0);
  signal div_in_2 : signed(data_width-1 downto 0);

begin

  mac_map : mac port map(Q0     => data_input,
                         Q1     => ele_x,
                         clock  => clock,
                         reset  => mac_reset,
                         acc    => acc,
                         mac_en => mac_en);


  DIVIDER_map : DW_div_pipe
    generic map(a_width     => 32,      -- divisor word width
                b_width     => 16,      -- dividend word width
                tc_mode     => 1,       -- '0' : unsigned, '1' : 2's compl.
                rem_mode    => 0,       -- '0' : modulus, '1' : remainder
                num_stages  => 3,       -- number of pipeline stages
                stall_mode  => 1,       -- '0' : non-stallable, '1' : stallable
                rst_mode    => 1,       -- '0' : none, '1' : async, '2' : sync
                op_iso_mode => 4)  -- operand isolation selection                                                       
    port map(clk         => clock,      -- register clock
             rst_n       => reset,      -- register reset
             en          => div_en,     -- register enable
             a           =>div_in_1,    --dividend
             b           =>div_in_2,    -- divisor
             quotient    => result,     -- quotient 
             remainder   => open,       -- remainder
             divide_by_0 => open);

  result_out <= x(to_integer(store_ptr))(data_width-1 downto 0);


  process(clock, reset, addr)
  begin
    if(reset = '0') then
      x        <=(others  => (others => '0'));
      ele_x    <= (others => '0');
      --data_in<=(others=>'0');
      B        <=(others  => (others => '0'));
      div_in_1 <= (others => '0');
      div_in_2 <= (others => '0');
    else
      B(to_integer(column_counter)) <= x"00000001";
      --data_in<=data_input;
      ele_x                         <= x(to_integer(addr))(data_width-1 downto 0);
    end if;


    if(rising_edge(clock)) then


      if(subtract_en = '1') then
        x(to_integer(row_counter)) <= B(to_integer(row_counter))-acc;
      end if;
      if(div_en = '1') then
        div_in_1 <= x(to_integer(row_counter));
        div_in_2 <= diagonal_ele;
      end if;
      if(store_en = '1')then
        x(to_integer(row_counter)) <= result;
      end if;
    end if;
  end process;

end inv_beh;



















