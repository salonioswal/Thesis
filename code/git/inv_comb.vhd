library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity inv_comb is
	port(data_input		: in signed(data_width-1 downto 0);
		 clock			: in std_logic;
		 reset			: in std_logic;
		 start			: in std_logic);
end inv_comb;

architecture beh_inv of inv_comb is
	
component BE_inverse is 
	port(data_input		: in signed(data_width-1 downto 0);
		 clock			: in std_logic;
		 reset			: in std_logic;
		 column_counter	: in unsigned(ptr_width_inv-1 downto 0);
		 row_counter	: in unsigned(ptr_width_inv-1 downto 0);
		 mac_en			: in std_logic;
		mac_reset		: in std_logic;
		addr			: in unsigned(ptr_width_inv-1 downto 0));
end component;
	
component FSM_inv is
	port(clock		  :in std_logic;
		reset		  :in std_logic;
		start		  :in std_logic;
		row_counter   :out unsigned(ptr_width_inv-1 downto 0);
		column_counter:out unsigned(ptr_width_inv-1 downto 0);
		mac_en		  :out std_logic;
		mac_reset	  :out std_logic;
     	wr_ptr_reg	  :out unsigned(ptr_width_inv-1 downto 0);
		rd_ptr		  :out unsigned(ptr_width_inv-1 downto 0);
	 	reset_reg	  :out std_logic;
		store_ptr	  :out unsigned(ptr_width_inv-1 downto 0);
		wr_en		  :out std_logic;
		addr		  :out unsigned(ptr_width_inv-1 downto 0);
		be_reset	  :OUT STD_LOGIC);
end component;
		SIGNAL be_reset		  :STD_LOGIC;
		signal row_counter    : unsigned(ptr_width_inv-1 downto 0);
		signal column_counter : unsigned(ptr_width_inv-1 downto 0);
		signal mac_en		  : std_logic;
		signal mac_reset	  : std_logic;
     	signal wr_ptr_reg	  : unsigned(ptr_width_inv-1 downto 0);
		signal rd_ptr		  : unsigned(ptr_width_inv-1 downto 0);
	 	signal reset_reg	  : std_logic;
		signal store_ptr	  : unsigned(ptr_width_inv-1 downto 0);
		signal wr_en		  : std_logic;	
		signal addr		  	  : unsigned(ptr_width_inv-1 downto 0);
begin
	
FSM_map: FSM_inv port map
		(clock=>clock,		 
		reset=>reset,		  
		start=>start,		  
		row_counter=>row_counter, 
		column_counter=>column_counter,
		mac_en=>mac_en,		 
		mac_reset=>mac_reset,	 
     	wr_ptr_reg=>wr_ptr_reg,	  
		rd_ptr=>rd_ptr,		 
	 	reset_reg=>reset_reg,	 
		store_ptr=>store_ptr,	  
		wr_en=>wr_en,
		addr=>addr,
		be_reset=>be_reset);

basic_el_map: BE_inverse port map
		(data_input=>data_input,		
		 clock=>clock,		
		 reset=>be_reset,			
		 column_counter=>column_counter,	
		 row_counter=>row_counter,	
		 mac_en=>mac_en,			
		 mac_reset=>mac_reset,
		 addr=>addr);
	
end beh_inv;
	
	
	
	
	