library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity normr_comb is
	port(data_input	:in signed(data_width-1 downto 0);
		 clock	   	:in std_logic;
		 reset	   	:in std_logic;
		 data_output:out signed(data_width-1 downto 0);
		 start		:in std_logic);
end normr_comb;

architecture arch_com of normr_comb is

component fsm_norm is
	port(clock		: in std_logic;
		 reset		: in std_logic;--negative reset
		 rd_ptr		: out unsigned(ptr_width_norm-1 downto 0);--8 elements(histogram intervals)
		 wr_ptr 	: out unsigned(ptr_width_norm-1 downto 0);
		 wr_en 		: out std_logic;
		 mac_en		: out std_logic;
		 div_en		: out std_logic;
		 reset_mac  : out std_logic;
		 start		: in std_logic);
end component;


component normr is
	port(data_input	: in signed(data_width-1 downto 0);--from SRAM
		 clock		: in std_logic;
		 reset		: in std_logic;--negative reset
		 data_output: out signed(data_width-1 downto 0);
		 rd_ptr		: in unsigned(ptr_width_norm-1 downto 0);--8 elements(histogram intervals)
		 wr_ptr 	: in unsigned(ptr_width_norm-1 downto 0);
		 wr_en 		: in std_logic;
		 mac_en		:in std_logic;
		 div_en		:in std_logic;
		 reset_mac  : in std_logic
		 );
end component;
	

signal rd_ptr	: unsigned(ptr_width_norm-1 downto 0);--8 elements(histogram intervals)
signal wr_ptr 	: unsigned(ptr_width_norm-1 downto 0);
signal wr_en 	: std_logic;
signal mac_en	: std_logic;
signal div_en	: std_logic;
signal reset_mac : std_logic;	

begin
	
fsm_map: fsm_norm port map(
		 clock=>clock,
		 reset=>reset,	
		 rd_ptr=>rd_ptr,		
		 wr_ptr=>wr_ptr,	
		 wr_en=>wr_en,		
		 mac_en=>mac_en,		
		 div_en=>div_en,	
		 reset_mac=>reset_mac, 
		 start=>start);
norm_map: normr port map(
		 data_input=>data_input,	
		 clock=>clock,		
		 reset=>reset,		
		 data_output=>data_output,
		 rd_ptr=>rd_ptr,		
		 wr_ptr=>wr_ptr, 	
		 wr_en=>wr_en,		
		 mac_en=>mac_en,		
		 div_en=>div_en,		
		 reset_mac=>reset_mac);  
	
end arch_com;
	
	
	
	
	
	
	
	
	