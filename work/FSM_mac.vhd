library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity fsm_mac is
	port(clock:in std_logic;
		 reset:in std_logic;
		 fsm_en:in std_logic;
		 mac_en		:out std_logic;
		 mac_reset	:out std_logic;
		 rd_add_h	:out unsigned(3 downto 0);
		 done_fsm	:in std_logic;
		store_s		:out std_logic);
end fsm_mac;
	
architecture arch_mac_f of fsm_mac is
	
type FSM_state is (IDLE,calc_coord,store);
signal state			: FSM_state;
signal next_state	 	: FSM_state;
signal count			: unsigned(2 downto 0);
signal next_count		: unsigned(2 downto 0);
signal next_mac_en		: std_logic;
signal next_mac_reset	: std_logic;
signal next_rd_add_h	: unsigned(3 downto 0);
signal next_store_s		:std_logic;

begin
	
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			state<=IDLE;
			count<=(others=>'0');
			mac_en<='0';
			mac_reset<='0';
			rd_add_h<=(others=>'0');
			store_s<='0';
		elsif(rising_edge(clock)) then
			state<=next_state;
			count<=next_count;
			mac_en<=next_mac_en;
			mac_reset<=next_mac_reset;
			rd_add_h<=next_rd_add_h;
			store_s<=next_store_s;
		end if;
	end process;
			
fsm_status: process(all) 
	begin
		--default values
			next_state<=state;
			next_count<=count;
			next_mac_en<=mac_en;
			next_mac_reset<=mac_reset;
			next_rd_add_h<=rd_add_h;
			next_store_s<=store_s;
	case state is
		when IDLE=>
		if(fsm_en='1') then 
			next_state<=calc_coord;
			next_rd_add_H<=(others=>'0');
			next_count<=(others=>'0');
			next_mac_en<='1';
			next_mac_reset<='1';
		end if;
		
		when calc_coord=>
			next_mac_en<='1';
			next_rd_add_H<=rd_add_H+1;
			next_count<=count+1;
			IF(count=2) then
				next_state<=store;
				next_count<=(others=>'0');
				next_rd_add_H<=(others=>'0');
			END if;
				
		when store=>
				next_mac_en<='1';
				next_store_s<='1';
			if(done_fsm='1') then
				next_state<=IDLE;
				next_mac_reset<='0';
				next_store_s<='0';
			end if;
			
	end case;
end process;
		
end arch_mac_f;