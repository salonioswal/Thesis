library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity division_FSM is
	port(FSM_en	:in std_logic;
		clock	:in std_logic;
		reset	:in std_logic;
		column	:out std_logic;
		div_en	:out std_logic;
		store_res: out std_logic
		--done_div:in std_logic
		--reset_div: out std_logic
		);
end division_FSM;
	
architecture arch_div of division_FSM is
	
type FSM_state is (IDLE,divide_x,divide_y,store);
signal state			: FSM_state;
signal next_state	 	: FSM_state;	
signal next_div_en		:std_logic;
signal next_column		:std_logic;
signal count			:unsigned(2 downto 0);
signal next_count		:unsigned(2 downto 0);
signal next_store_res	:std_logic;
--signal next_reset_div	:std_logic;

begin
	
clocked_process: process(reset,clock)
	begin
		if(reset='0') then
			state<=IDLE;
			div_en<='0';
			column<='0';
			count<=(others=>'0');
			store_res<='0';
			--reset_div<='0';
		elsif(rising_edge(clock)) then
			state<=next_state;
			div_en<=next_div_en;
			count<=next_count;
			column<=next_column;
			store_res<=next_store_res;
			--reset_div<=next_reset_div;
		end if;
	end process;
			
FSM_status: process(all)
begin
	--default values
	next_store_res<=store_res;
	next_state<=state;
	next_div_en<=div_en;
	next_count<=count;
	next_column<=column;
	--next_reset_div<=reset_div;
	case state is
		
	when IDLE=>
		if(FSM_en='1') then
			next_state<=divide_x;
			--next_reset_div<='1';
		end if;
			
	when divide_x=>
			 next_count<=count+1;
			 next_div_en<='1';
			 if(to_integer(count)=1) then
			 next_state<=divide_y;
			 next_count<=(others=>'0');
			 next_column<='1';
			end if;
		
	when divide_y=>
			next_column<='0';
			next_state<=store;

	when store=>
		next_count<=count+1;
		next_store_res<='1';	
		--if(count=5) then
			if(count=2) then
			next_state<=divide_x;
		--elsif(done_div='1') then
			--next_state<=IDLE;
			--next_reset_div<='0';
			next_store_res<='0';
			next_count<=(others=>'0');
			next_div_en<='0';
		end if;
			
	
	END CASE;
end process;
end arch_div;
		
		
		
		
		

			  