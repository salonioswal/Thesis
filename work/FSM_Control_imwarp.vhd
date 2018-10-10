library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity fsm_imwarp is
	port(clock		: in std_logic;
		 reset		: in std_logic;
		 en_FSM_mac	: out std_logic;
		 en_FSM_div	: out std_logic;
		 wr_en		: out std_logic;
		 wr_add_h	:out unsigned(3 downto 0);
		 done_FSM_mac: out std_logic;
		 done_FSM_div: out std_logic;
		 start		: in std_logic
		);
end fsm_imwarp;
	
architecture arch_imwarp of fsm_imwarp is
type FSM_state is (IDLE,fill_RF_homo_inv,en_FSM_1_2,done);
signal state			: FSM_state;
signal next_state	 	: FSM_state;
signal next_en_FSM_mac	: std_logic;
signal next_en_FSM_div	: std_logic;
signal next_wr_en		: std_logic;--for homography matrix
signal next_wr_add_h	: unsigned(3 downto 0);
signal next_done_FSM_mac: std_logic;
signal next_done_FSM_div: std_logic;
signal count			: unsigned(data_width-1 downto 0);
signal next_count		: unsigned(data_width-1 downto 0);
signal element_count	: unsigned(data_width-1 downto 0);
signal next_element_count: unsigned(data_width-1 downto 0);

begin

clocked_process: process(clock,reset)
begin
	if(reset='0') then
		state<=IDLE;
		en_FSM_mac<='0';
		en_FSM_div<='0';
		wr_en<='1';
		wr_add_h<=(others=>'0');
		done_FSM_mac<='0';
		done_FSM_div<='0';
		count<=(others=>'0');
		element_count<=(others=>'0');
	elsif(rising_edge(clock)) then
		state<=next_state;
		en_FSM_mac<=next_en_FSM_mac;
		en_FSM_div<=next_en_FSM_div;
		wr_en<=next_wr_en;
		wr_add_h<=next_wr_add_h;
		done_FSM_mac<=next_done_FSM_mac;
		done_FSM_div<=next_done_FSM_div;
		count<=next_count;
		element_count<=next_element_count;
	end if;		
end process;

FSM_status: process(all)
	begin
		--default values
		next_state<=state;
		next_en_FSM_mac<=en_FSM_mac;
		next_en_FSM_div<=en_FSM_div;
		next_wr_en<=wr_en;
		next_wr_add_h<=wr_add_h;
		next_done_FSM_mac<=done_FSM_mac;
		next_done_FSM_div<=done_FSM_div;
		next_count<=count;
		next_element_count<=element_count;
	case state is
		when IDLE=>
		if(start='1') then
			next_state<=fill_RF_homo_inv;
			next_wr_en<='1';
		end if;
			
		when fill_RF_homo_inv=>
			next_wr_add_h<=wr_add_h+1;
			next_count<=count+1;
		if(to_integer(count)=8) then
			next_state<=en_FSM_1_2;
			next_count<=(others=>'0');
			
			next_wr_en<='0';
			next_wr_add_h<=(others=>'0');
		end if;
		
		when en_FSM_1_2=>
			
				
			
			next_count<=count+1;
			if(count=2) then
				if(element_count=0) then
				next_en_FSM_div<='0';
				end if;
				next_en_FSM_div<='1';
			elsif(count=3) then
				next_done_FSM_mac<='1';
			elsif(count=4) then
				next_en_FSM_mac<='1';
				next_done_FSM_mac<='0';
			elsif(count=5) then
				next_element_count<=element_count+1;
				next_done_FSM_div<='1';
				next_count<=(others=>'0');
				next_state<=en_FSM_1_2;
				next_en_FSM_mac<='1';
			end if;
		when done=>
			next_state<=IDLE;
		end case;
	end process;
end arch_imwarp;
			
		
			
		
		
		
		
		
		
		
		