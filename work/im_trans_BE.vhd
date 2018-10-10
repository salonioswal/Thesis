In library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity tran_Be is
	port(RF_H_in	: in signed(data_width-1 downto 0);
		 wr_en		: in std_logic;
		 rd_addr_H	: in unsigned(2 downto 0); --8 degrees of freedom
		 wr_addr_H	: in unsgined(2 downto 0);
		 x_input 	: in signed(data_width-1 downto 0);
		 y_input 	: in signed(data_width-1 downto 0);
		 x_min	 	: out signed(data_width-1 downto 0);
		 y_min	 	: out signed(data_width-1 downto 0);
		 clock	 	: in std_logic;
		 reset	 	: in std_logic;
		 mac_en		: in std_logic;
		 mac_reset	: in std_logic;
		 div_en		: in std_logic;
         coor_addr	: in unsigned(1 downto 0);
		 coor_en	: in std_logic;
		 en_x		: in std_logic;
		 en_y		: in std_logic;
		 en_z		: in std_logic
		 );	
end tran_Be;
	
architecture arch_t of tran_be is
	
component mac is
	port (Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
end mac;
	
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
	
component RF_homo is
port(input_data: in signed(data_width-1 downto 0); 
	 output_data: out signed(data_width-1 downto 0); 
	 wr_en: in std_logic;
	 rst_n: in std_logic;
	 clock: in std_logic;
	 wr_add: in unsigned(2 downto 0);
	 rd_add: in unsigned(2 downto 0));
end RF_homo;
	
signal RF_H_out: signed(data_width-1 downto 0);
signal in_coordinate: RF(1 downto 0);
signal div_in_1: signed(2*data_width-1 downto 0);
signal div_in_2: signed(data_width-1 downto 0);
signal out_coordinate: RF(1 downto 0);
signal acc: signed(2*data_width-1 downto 0);
begin
	
map_rf_homo: RF_homo port map(input data=>RF_H_in,
							 output_data=>RF_H_out,
							 wr_en=>wr_en,
	 						 rst_n=>reset,
							 clock=>clock,
							 wr_add=>wr_addr_H,
							 rd_add=>rd_addr_H);
	
map_mac: mac port map(Q0=>in_coordinate(addr), 
		 		Q1=> RF_H_out,
		  		clock=>clock,
		  		reset=>mac_reset,
		  		acc=>acc,
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

begin
if (reset='0') then
	in_coordinate<=(others=>(others=>'0'));
	div_in_1<=(others=>'0');
	div_in_2<=(others=>'0');
	
elsif(rising_edge(clock)) then
		if(coor_en ='1') then
			in_coordinate(addr)<=x_input;
			in_coordinate(addr+1)<=y_input;
			in_coordinate(addr+2)<=1;
		end if;
	   
		


	

	
		 