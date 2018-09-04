library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use ieee.math_real.all;
use work.all;

entity fsm_norm is
	port(clock		: in std_logic;
		 reset		: in std_logic;--negative reset
		 rd_ptr		: out unsigned(ptr_width_norm-1 downto 0);--8 elements(histogram intervals)
		 wr_ptr 	: out unsigned(ptr_width_norm-1 downto 0);
		 wr_en 		: out std_logic;
		 mac_en		: out std_logic;
		 div_en		: out std_logic;
		 reset_mac  : out std_logic;
		 start		: in std_logic);
end fsm_norm;
	
architecture arch_norm of fsm_norm is

type FSM_state is (IDLE,REG_FILL,SUM_SQ,DIVIDE,DONE);
signal state		 : FSM_state;
signal next_state	 : FSM_state;
signal next_rd_ptr	: unsigned(ptr_width_norm-1 downto 0);--8 elements(histogram intervals)
signal next_wr_ptr 	: unsigned(ptr_width_norm-1 downto 0);
signal next_wr_en 	: std_logic;
signal next_mac_en	: std_logic;
signal next_div_en	: std_logic;
signal next_reset_mac : std_logic;
signal rf_count		  :unsigned(ptr_width_norm-1 downto 0);
signal next_rf_count  :unsigned(ptr_width_norm-1 downto 0);
signal op_count		  :unsigned(ptr_width_norm-1 downto 0);
signal next_op_count  :unsigned(ptr_width_norm-1 downto 0);

BEGIN
clocked_process: process(clock,reset)
begin
	if(reset='0') then
		rd_ptr<=(others=>'0');
		wr_ptr<=(others=>'0');
		wr_en<='0';
		mac_en<='0';
		div_en<='0';
		reset_mac<='0';
		rf_count<=(others=>'0');
		op_count<=(others=>'0');
		state<=IDLE;
	elsif(rising_edge(clock)) then
		rd_ptr<=next_rd_ptr;
		wr_ptr<=next_wr_ptr;
		wr_en<=next_wr_en;
		mac_en<=next_mac_en;
		div_en<=next_div_en;
		reset_mac<=next_reset_mac;
		rf_count<=next_rf_count;
		op_count<=next_op_count;
		state<=next_state;
	end if;
end process;
		
FSM_process:process(all)
	begin
--default values
next_rd_ptr<=rd_ptr;
next_wr_ptr<=wr_ptr;
next_wr_en<=wr_en;
next_mac_en<=mac_en;
next_div_en<=div_en;
next_reset_mac<=reset_mac;
next_rf_count<=rf_count;
next_op_count<=op_count;
next_state<=state;

case state is
	when IDLE=>
		next_rd_ptr<=(others=>'0');
		next_wr_ptr<=(others=>'0');
		next_wr_en<='0';
		next_mac_en<='0';
		next_div_en<='0';
		next_reset_mac<='0';
		next_rf_count<=(others=>'0');
		next_op_count<=(others=>'0');
	    if(start='1') then
			next_wr_en<='1';
			next_state<=REG_FILL;
		end if;
	when REG_FILL=>
		next_wr_ptr<=wr_ptr+1;
		next_wr_en<='1';
		next_rf_count<=rf_count+1;
		if(rf_count=7) then
			next_state<=SUM_SQ;
			next_wr_en<='0';
			next_reset_mac<='1';
			next_mac_en<='1';
			next_rf_count<=(others=>'0');
		end if;
	when SUM_SQ=>
		next_mac_en<='1';
		next_op_count<=op_count+1;
		next_reset_mac<='1';
		next_rd_ptr<=rd_ptr+1;
		if(op_count=7) then
			next_state<=DIVIDE;
			next_op_count<=(others=>'0');
			next_div_en<='1';
			next_mac_en<='0';
			next_rd_ptr<=(others=>'0');
		end if;
	when DIVIDE=>
			next_div_en<='1';
			next_rd_ptr<=rd_ptr+1;
			next_op_count<=op_count+1;
			next_mac_en<='0';
			if(op_count=7) then
				next_state<=DONE;
				next_div_en<='0';
			end if;
	when DONE=>
			next_state<=IDLE;
end case;
end process;
end arch_norm;
			
			
			
			
			
			
	







						
		
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		
	
	
	
