library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;
------------------------------------------------------------------
entity FSM_strassen is
------------------------------------------------------------------
	port(SRAM_wr_ptr	: out unsigned(ptr_width+1 downto 0); --sram write addr
		 RF_wr_ptr		: out unsigned(ptr_width+1 downto 0); --regsiter file write addr
		 SRAM_rd_prt	: out unsigned(ptr_width+1 downto 0); --sram read pointer
		 RF_rd_ptr		: out unsigned(ptr_width-1 downto 0); --regsiter file read pointer
		 reset			: in std_logic; --reset
		 clock			: in std_logic; --clock
		 reset_RF       : out std_logic; --register file reset(negative)
		 reset_SRAM     : out std_logic; --sram reset(negative)
		 reset_BE       : out std_logic; --basic element reset(negative)
		 wr_en_sram		: out std_logic; --write enable sram
		 wr_en_rf		: out std_logic); --write enable register file
	end FSM_strassen;
	
architecture beh_FSM of FSM_strassen is
	type FSM_state is(sram_fill,row_reg_fill,col_reg_fill,basic_element,row_complete,store);
	signal state: FSM_state;
	signal next_state: FSM_state;
	signal rf_count: unsigned(ptr_width-1 downto 0);
	signal next_rf_count: unsigned(ptr_width-1 downto 0);
	signal count_op:
	signal next_count_op:
	signal next_sram_wr_ptr:
	signal next_RF_wr_ptr		: unsigned(ptr_width+1 downto 0); 
	signal next_SRAM_rd_prt	: unsigned(ptr_width+1 downto 0);
	signal next_RF_rd_ptr		: unsigned(ptr_width-1 downto 0); 
	signal next_reset_RF       : std_logic; 
	signal next_reset_SRAM     : std_logic; 
	signal next_reset_BE       : std_logic; 
	signal next_wr_en_sram		: std_logic; 
	signal next_wr_en_rf		: std_logic;
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 