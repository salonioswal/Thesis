library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use ieee.math_real.all;
use work.all;
---------------------------------------------------
entity normr is
---------------------------------------------------
	port(data_input	: in signed(data_width-1 downto 0);--from SRAM
		 clock		: in std_logic;
		 reset		: in std_logic;--negative reset
		 data_output: out signed(data_width-1 downto 0);
		 rd_ptr		: in unsigned(ptr_width_norm-1 downto 0);--8 elements(histogram intervals)
		 wr_ptr 	: in unsigned(ptr_width_norm-1 downto 0);
		 wr_en 		: in std_logic;
		 mac_en		:in std_logic;
		 div_en		:in std_logic;
		 reset_mac  :in std_logic;
		 en_root	:in std_logic --add in fsm
		 );
end normr;
	
architecture arch of normr is
--divider module		
component DW_div_pipe is
  generic (
    a_width     : positive;                           -- divisor word width
    b_width     : positive;                           -- dividend word width
    tc_mode     : natural   := 0;         -- '0' : unsigned, '1' : 2's compl.
    rem_mode    : natural   := 1;         -- '0' : modulus, '1' : remainder
    num_stages  : positive := 3;                      -- number of pipeline stages
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
    divide_by_0 : out std_logic);                            -- divide by zero flag
end component;

--sqaure root module
component DW_sqrt_pipe is
	generic( width:positive;
   tc_mode:natural	:= 1;
   num_stages:positive	:= 3;
   stall_mode :natural	:= 1;
   rst_mode :natural	:= 1;
    op_iso_mode :natural:= 0);
port(   
   	clk		:in std_logic;
  	rst_n	:in std_logic;
  	a		: in signed(2*data_width-1 downto 0);
 	en		:in std_logic;
  	root	:out signed(data_width-1 downto 0));
end component;	
	
	
	
--mac module		
component mac is
port (Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
	end component;

component reg_n_file is
	port(input_data	: in signed(data_width-1 downto 0);
		 output_data: out signed(data_width-1 downto 0);
		 clock		: in std_logic;
		 reset		: in std_logic;
		 rd_ptr		: in unsigned(ptr_width_norm-1 downto 0);
		 wr_ptr		: in unsigned(ptr_width_norm-1 downto 0);
		 wr_en		: std_logic);
end component;

signal mac_input: signed(data_width-1 downto 0);
signal acc		  : signed(2*data_width-1 downto 0);
signal div_in_1	  : signed(2*data_width-2 downto 0);
signal div_in_2   : signed(data_width-1 downto 0);
signal result 	  :	signed(2*data_width-2 downto 0);
signal sqrt_var	  : signed(data_width-1 downto 0);
signal concat	  : signed(14 downto 0);
begin

RF_map: reg_n_file port map(input_data=>data_input,
							output_data=>mac_input,
		 					clock=>clock,
							reset=>reset,
							rd_ptr=>rd_ptr,
							wr_ptr=>wr_ptr,
							wr_en=>wr_en);
		 
mac_map: mac port map(Q0=>mac_input,
					  Q1=>mac_input,
					  clock=>clock,
					  reset=>reset_mac,
					  acc=>acc,
					  mac_en=>mac_en);
DIVIDER:  			  DW_div_pipe 			     
				generic map(a_width=>31,                           -- divisor word width
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

	
root_map: DW_sqrt_pipe
	generic map(width=>32,
   tc_mode=>1,
   num_stages=>3,
   stall_mode=>1,	
   rst_mode=>1, 	
    op_iso_mode=>4)
port map(   
   	clk=>clock,	
  	rst_n=>reset,	
  	a=>acc,	
 	en=>en_root,		
  	root=>sqrt_var);	

concat<=(others=>'0');
------------------
process(clock,reset)

begin

if(reset='0') then
		div_in_1<=(others=>'0');
		div_in_2<=(others=>'0');
		data_output<=(others=>'0');
		
elsif(rising_edge(clock)) then
			--rounding up/down
			
		
		if(div_en='1') then
			data_output<= result(15 downto 0);
		
			div_in_1<=mac_input&concat; --sll by 15 
			div_in_2<=sqrt_var;
		
		else 
			div_in_1<=(others=>'0');
			div_in_2<=(others=>'0');
		end if;
end if;
end process;
end arch;