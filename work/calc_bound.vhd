library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity calc_bound is
	port(coordinate_input:in signed(data_width-1 downto 0);
		 Homography_input_1:in signed(data_width-1 downto 0);
		 Homography_input_2:in signed(data_width-1 downto 0);
		 Homography_input_3:in signed(data_width-1 downto 0);
		 div_en	: in std_logic;
		 clock	: in std_logic;
		 reset	: in std_logic;
		 column	: in std_logic;
		 mac_en	: in std_logic;
		 mac_reset: in std_logic;
		 result_out: out signed(data_width-1 downto 0)
		 );
end calc_bound;
	
architecture calc_bound_arch of calc_bound is
	
component mac is
	port (Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
end component;
	
--divider module		
component DW_div_pipe is
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
    a           : in  signed(a_width-1 downto 0);  -- divisor
    b           : in  signed(b_width-1 downto 0);  -- dividend
    quotient    : out signed(a_width-1 downto 0);  -- quotient
    remainder   : out signed(b_width-1 downto 0);  -- remainder
    divide_by_0 : out std_logic);                            -- divide by                                                            -- zero flag
end component;
	
	
signal div_in_1: signed(2*data_width-1 downto 0);
signal div_in_2: signed(data_width-1 downto 0);
signal acc_x	: signed(2*data_width-1 downto 0);
signal acc_y	: signed(2*data_width-1 downto 0);
signal acc_z	: signed(2*data_width-1 downto 0);
signal result: signed(2*data_width-1 downto 0);
begin
map_mac_1: mac port map(Q0=>coordinate_input,
		 		Q1=>Homography_input_1,
		  		clock=>clock,
		  		reset=>mac_reset,
		  		acc=>acc_x,
		  		mac_en=>mac_en);
map_mac_2: mac port map(Q0=>coordinate_input,
		 		Q1=>Homography_input_2,
		  		clock=>clock,
		  		reset=>mac_reset,
		  		acc=>acc_y,
		  		mac_en=>mac_en);
map_mac_3: mac port map(Q0=>coordinate_input,
		 		Q1=>Homography_input_3,
		  		clock=>clock,
		  		reset=>mac_reset,
		  		acc=>acc_z,
		  		mac_en=>mac_en);
	
DIVIDER_map:  	DW_div_pipe 			     
				generic map(a_width=>32,                           -- divisor word width
							b_width=>16,                           -- dividend word width
							tc_mode=>1,         -- '0' : unsigned, '1' : 2's compl.
							rem_mode=>0,         -- '0' : modulus, '1' : remainder
							num_stages=>3,                      -- number of pipeline stages
							stall_mode=>1,         -- '0' : non-stallable, '1' : stallable
							rst_mode=>1,        -- '0' : none, '1' : async, '2' : sync
							op_iso_mode=>4)        -- operand isolation selection							
port map(clk=>clock,                      -- register clock
	 	rst_n=> reset,                      -- register reset
         en=>div_en,                      -- register enable
	 	 a=>div_in_1,  --dividend
         b=>div_in_2,  -- divisor
         quotient=>result,  -- quotient 
         remainder=>OPEN,   -- remainder
		 divide_by_0=>OPEN);
	


clocked_process: process(clock,reset)
	begin
	if(reset='0') then
		div_in_1<=(others=>'0');
		div_in_2<=(others=>'0');

		result_out<=(others=>'0');
		
   elsif(rising_edge(clock)) then
	   result_out<=result(data_width-1 downto 0);
	   if(div_en='1') then
	   div_in_2<=acc_z(15 downto 0);
	   if(column='0') then
		   div_in_1<=acc_x;
	   else
		   div_in_1<=acc_y;
	   end if;
	end if;
	end if;
end process;
		   
end calc_bound_arch;



