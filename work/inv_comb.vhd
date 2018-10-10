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
		 start			: in std_logic;
		 wr_en_r		: out std_logic;
		result_output	:out signed(data_width-1 downto 0);
		store_result_s	:out std_logic);
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
		addr			: in unsigned(ptr_width_inv-1 downto 0);
		subtract_en		: in std_logic;
		div_en			: in std_logic;
		store_en		: in std_logic;
		diagonal_ele	: in signed (data_width-1 downto 0);
		store_result	: in std_logic;
		result_out		:out signed(data_width-1 downto 0);
		store_ptr	  	:in unsigned(ptr_width_inv-1 downto 0));
end component;
	
component RF_INVERSE is
	port(input_data	: in signed(data_width-1 downto 0);
		 output_data: out signed(data_width-1 downto 0);
		 clock		: in std_logic;
		 reset		: in std_logic;
		 rd_ptr		: in unsigned(ptr_width_inv-1  downto 0);
		 wr_ptr		: in unsigned(ptr_width_inv-1  downto 0);
		 wr_en		: in std_logic;
		row_counter   :in unsigned(ptr_width_inv-1 downto 0);
		 diagonal_ele:out signed(data_width-1 downto 0));
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
		be_reset	  :OUT STD_LOGIC;
		subtract_en	  :out std_logic;
		divide_en	  :out std_logic;
		store_en	  :out std_logic;
		store_result  :out std_logic);
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
		signal subtract_en	  : std_logic;
		signal divide_en	  : std_logic;
		signal store_en	 	  : std_logic;
		signal diagonal_ele	  : signed(data_width-1 downto 0);
		signal input_data	  : signed(data_width-1 downto 0);
		signal store_result	: std_logic;
		signal result_out		:signed(data_width-1 downto 0);
		

begin
result_output<=result_out;	
wr_en_r<=wr_en;
store_result_s<=store_result;
RF_MAP: RF_INVERSE port map(input_data=>data_input,	
		 output_data=>input_data,
		 clock=>clock,		
		 reset=>reset_reg,		
		 rd_ptr=>rd_ptr,		
		 wr_ptr=>wr_ptr_reg,		
		 wr_en=>wr_en,
		 row_counter=>row_counter,
		 diagonal_ele=>diagonal_ele);		

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
		be_reset=>be_reset,
		subtract_en=>subtract_en,
		divide_en=>divide_en,
		store_en=>store_en,
		store_result=>store_result);

basic_el_map: BE_inverse port map
		(data_input=>input_data,		
		 clock=>clock,		
		 reset=>be_reset,			
		 column_counter=>column_counter,	
		 row_counter=>row_counter,	
		 mac_en=>mac_en,			
		 mac_reset=>mac_reset,
		 addr=>addr,
		 subtract_en=>subtract_en,
		 div_en=>divide_en,
		 store_en=>store_en,
		 diagonal_ele=>diagonal_ele,
		 store_result=>store_result,
		result_out=>result_out,
		store_ptr=>store_ptr
		);


end beh_inv;
	
	
	
	
	