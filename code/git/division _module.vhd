library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity division is
  generic (
    a_width     : positive;                           -- divisor word width
    b_width     : positive;                           -- dividend word width
    tc_mode     : natural   := 0;         -- '0' : unsigned, '1' : 2's compl.
    rem_mode    : natural   := 1;         -- '0' : modulus, '1' : remainder
    num_stages  : positive := 2;                      -- number of pipeline stages
    stall_mode  : natural   := 1;         -- '0' : non-stallable, '1' : stallable
    rst_mode    : natural   := 1;         -- '0' : none, '1' : async, '2' : sync
    op_iso_mode : natural   := 0);        -- operand isolation selection
  port (
    clk         : in  std_logic;                      -- register clock
    rst_n       : in  std_logic;                      -- register reset
    en          : in  std_logic;                      -- register enable
    a           : in  std_logic_vector(a_width-1 downto 0);  -- divisor
    b           : in  std_logic_vector(b_width-1 downto 0);  -- dividend
    quotient    : out std_logic_vector(a_width-1 downto 0);  -- quotient
    remainder   : out std_logic_vector(b_width-1 downto 0);  -- remainder
    divide_by_0 : out std_logic;
  	div_en      : in std_logic);                            -- divide by                                                            -- zero flag
end division;
	