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
		 SRAM_rd_ptr	: out unsigned(ptr_width+1 downto 0); --sram read pointer
		 RF_rd_ptr		: out unsigned(ptr_width-1 downto 0); --regsiter file read pointer
		 reset			: in std_logic; --reset
		 clock			: in std_logic; --clock
		 reset_RF       : out std_logic; --register file reset(negative)
		 reset_SRAM     : out std_logic; --sram reset(negative)
		 reset_BE       : out std_logic; --basic element reset(negative)
		 wr_en_sram		: out std_logic; --write enable sram
		 wr_en_rf		: out std_logic; --write enable for register file
		 start			: in std_logic); --write enable register file
	end FSM_strassen;
	
architecture beh_FSM of FSM_strassen is
	type FSM_state is(idle,sram_fill,row_reg_fill,basic_element,done);
	signal state			: FSM_state;
	signal next_state		: FSM_state;
	signal rf_count			: unsigned(1 downto 0);
	signal next_rf_count	: unsigned(1 downto 0);
	signal count_op			: unsigned(ptr_width+1 downto 0); 
	signal next_count_op	: unsigned(ptr_width+1 downto 0); 
	signal next_sram_wr_ptr	: unsigned(ptr_width+1 downto 0);
	signal next_RF_wr_ptr	: unsigned(ptr_width+1 downto 0); 
	signal next_SRAM_rd_ptr	: unsigned(ptr_width+1 downto 0);
	signal next_RF_rd_ptr	: unsigned(ptr_width-1 downto 0); 
	signal next_reset_RF    : std_logic; 
	signal next_reset_SRAM  : std_logic; 
	signal next_reset_BE    : std_logic; 
	signal next_wr_en_sram  : std_logic; 
	signal next_wr_en_rf	: std_logic;
	signal sram_count       : unsigned(ptr_width-1 downto 0);	
	signal next_sram_count  : unsigned(ptr_width-1 downto 0);
			 
begin
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			
			state<= idle;
			rf_count<=(others=>'0');
			count_op <= (OTHERS =>'0');
			SRAM_wr_ptr<=(others=>'0');
			RF_wr_ptr<=(others=>'0');
			SRAM_rd_ptr	<=(others=>'0'); 
			RF_rd_ptr<=(others=>'0');
			reset_RF <='0';
			reset_SRAM<='0'; 
			reset_BE <='0';
			wr_en_sram <='0';
			wr_en_rf <='0';
			sram_count<=(others=>'0');

      ELSIF (rising_edge(clock)) then

			state<=next_state;
			rf_count<=next_rf_count;
			count_op <= next_count_op;
			SRAM_wr_ptr<=next_SRAM_wr_ptr;
			RF_wr_ptr<=next_RF_wr_ptr;
			SRAM_rd_ptr	<=next_SRAM_rd_ptr; 
			RF_rd_ptr<=next_RF_rd_ptr;
			reset_RF <=next_reset_RF;
			reset_SRAM<=next_reset_SRAM; 
			reset_BE <=next_reset_BE;
			wr_en_sram <=next_wr_en_sram;
			wr_en_rf <=next_wr_en_rf;
			sram_count<=next_sram_count;

end if;
end process;
	
FSM_status: process(ALL)
	BEGIN
		--default values
		next_state<=state;
		next_rf_count<=rf_count;
		next_count_op<=count_op;
		next_SRAM_wr_ptr<=SRAM_wr_ptr;
		next_RF_wr_ptr<=RF_wr_ptr;
		next_SRAM_rd_ptr<=SRAM_rd_ptr;
		next_reset_RF<=reset_RF;
		next_reset_SRAM<=reset_SRAM;
		next_reset_BE<=reset_BE;
		next_wr_en_sram<=wr_en_sram;
		next_wr_en_rf<=wr_en_rf;
		next_sram_count<=sram_count;
case state is
	when IDLE=>
			next_rf_count<=(others=>'0');
			next_count_op <= (OTHERS =>'0');
			next_SRAM_wr_ptr<=(others=>'0');
			next_RF_wr_ptr<=(others=>'0');
			next_SRAM_rd_ptr	<=(others=>'0'); 
			next_RF_rd_ptr<=(others=>'0');
			next_reset_RF <='0';
			next_reset_SRAM<='0'; 
			next_reset_BE <='0';
			next_wr_en_sram <='0';
			next_wr_en_rf <='0';

		if (start='1') then
			next_state<=sram_fill; 
			next_wr_en_sram <='1';
			next_SRAM_wr_ptr<=(others=>'0');
			next_reset_SRAM<='1';
		end if;
		
	when sram_fill=>
			next_reset_SRAM<='1';
			next_wr_en_sram <='1';
			next_SRAM_wr_ptr<=SRAM_wr_ptr+1;
			if(SRAM_wr_ptr=4*n-1) then
				next_state<=row_reg_fill;
				next_reset_RF <='1';
				next_wr_en_rf <='1';
				next_wr_en_SRAM <='0';
			end if;
	when row_reg_fill=>
				next_wr_en_SRAM <='0';
				next_reset_RF <='1';
				next_SRAM_rd_ptr<=SRAM_rd_ptr+1;
				next_RF_wr_ptr<=RF_wr_ptr+1;
			if(RF_wr_ptr=4*n-1) then
				next_state<=basic_element;
				next_reset_BE <='1';
				next_wr_en_rf <='0';
			end if;
				
	when basic_element=>
				next_reset_RF <='1';
				next_reset_SRAM<='1';
				next_reset_BE <='1';
				next_rf_count<=rf_count+1;
				next_count_op<=count_op+1;
				next_RF_rd_ptr<=RF_rd_ptr+4;	
			
		if(count_op= n) then
			next_state<=done;
		end if;
	--when row_complete=>
	--when store=>
	
			
	when done=>	
			
				next_reset_BE <='0';
				next_state <= Idle;
	when OTHERS=>
		next_state<=idle;
end case;
end process;
end beh_FSM;
	
	
	
			 