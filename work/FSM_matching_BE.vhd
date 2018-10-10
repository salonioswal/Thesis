library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity FSM_match_BE is
	port(reset:in std_logic;
		clock: in std_logic;
		start: in std_logic;
		rd_addr_1	:out unsigned(6 downto 0);
		rd_addr_2	:out unsigned(6 downto 0);
		wr_addr_1	:out unsigned(6 downto 0);
		wr_addr_2	:out unsigned(6 downto 0);
		wr_en_1      :out std_logic; --enable for RF_1 (descriptors of 1st image)
		wr_en_2		:out std_logic; --enable for RF_2 (descriptors of 2nd image)
		mac_en		:out std_logic;
		mac_reset	:out std_logic;
		en_be		:out std_logic;
		store_s		:out std_logic
		);
end FSM_match_BE;
	
architecture arch_FSM_match of FSM_match_BE is

type FSM_state is (IDLE,fill_RF_1_2,Basic_Element,Store,DONE);
signal state			: FSM_state;
signal next_state	 	: FSM_state;
signal next_rd_addr_1	:unsigned(6 downto 0);
signal next_rd_addr_2	:unsigned(6 downto 0);
signal next_wr_addr_1	:unsigned(6 downto 0);
signal next_wr_addr_2	:unsigned(6 downto 0);
signal next_wr_en_1      :std_logic; --enable for RF_1 (descriptors of 1st image)
signal next_wr_en_2	:std_logic; --enable for RF_2 (descriptors of 2nd image)
signal next_mac_en	:std_logic;
signal next_mac_reset	:std_logic;
signal next_en_be	:std_logic;
signal counter_rf	:unsigned(6 downto 0);
signal next_counter_rf	:unsigned(6 downto 0);
signal des_count	:unsigned(6 downto 0);
signal next_des_count	:unsigned(6 downto 0);
signal index_count	:unsigned(6 downto 0); --change later
signal next_index_count	:unsigned(6 downto 0); 
begin
	
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			state<=IDLE;
			rd_addr_1<=(others=>'0');
			rd_addr_2<=(others=>'0');
			wr_addr_1<=(others=>'0');
			wr_addr_2<=(others=>'0');
			wr_en_1<='0';
			wr_en_2<='0';
			mac_en<='0';
			mac_reset<='0';
			en_be<='0';
			counter_rf<=(others=>'0');
			des_count<=(others=>'0');
			index_count<=(others=>'0');
			store_s	<='0';
		elsif(rising_edge(clock)) then
			state<=next_state;
			rd_addr_1<=next_rd_addr_1;
			rd_addr_2<=next_rd_addr_2;
			wr_addr_1<=next_wr_addr_1;
			wr_addr_2<=next_wr_addr_2;
			wr_en_1<=next_wr_en_1;
			wr_en_2<=next_wr_en_2;
			mac_en<=next_mac_en;
			mac_reset<=next_mac_reset;
			en_be<=next_en_be;
			counter_rf<=next_counter_rf;
			des_count<=next_des_count;
			index_count<=next_index_count;
	 end if;
end process;
		 
FSM_status: process(all)
	begin
	--default values
	store_s<='0';
	next_state<=state;
	next_rd_addr_1<=rd_addr_1;
	next_rd_addr_2<=rd_addr_2;
	next_wr_addr_1<=wr_addr_1;
	next_wr_addr_2<=wr_addr_2;
	next_wr_en_1<=wr_en_1;
	next_wr_en_2<=wr_en_2;
	next_mac_en<=mac_en;
	next_mac_reset<=mac_reset;
	next_en_be<=en_be;
	next_counter_rf<=counter_rf;
	next_des_count<=des_count;	
	next_index_count<=index_count;

 case state is
	when IDLE=>
	next_rd_addr_1<=(others=>'0');
	next_rd_addr_2<=(others=>'0');
	next_wr_addr_1<=(others=>'0');
	next_wr_addr_2<=(others=>'0');
	next_wr_en_1<='0';
	next_wr_en_2<='0';
	next_mac_en<='0';
	next_mac_reset<='0';
	next_en_be<='0';
	next_counter_rf<=(others=>'0');
	next_des_count<=(others=>'0');
 	if(start='1') then
		next_state<=fill_RF_1_2;
		next_wr_en_1<='1';
		next_wr_en_2<='1';
	end if;
		
	when fill_RF_1_2=>
		next_mac_reset<='0';
		next_wr_en_1<='1';
		next_wr_en_2<='1';
		next_wr_addr_1<=wr_addr_1+1;
		next_wr_addr_2<=wr_addr_2+1;
		next_counter_rf<=counter_rf+1;
		if(counter_rf = 127) then
			next_state<=Basic_Element;
			next_wr_en_1<='0';
			next_wr_en_2<='0';
			next_wr_addr_1<=(others=>'0');
			next_wr_addr_2<=(others=>'0');
			next_en_be<='1';
			next_mac_en<='1';
			next_mac_reset<='1';
			next_counter_rf<=(others=>'0');
		end if;
		
	when Basic_Element=>
		next_rd_addr_1<=rd_addr_1+1;
		next_rd_addr_2<=rd_addr_2+1;
		next_mac_reset<='1';
		next_mac_en<='1';
		next_en_be<='1';
		next_des_count<=des_count+1;
		if(des_count=127) then
			next_state<=store;
			next_mac_en<='0';
			next_des_count<=(others=>'0');
		end if;
	 when store=>
		 store_s<='1';
		 next_index_count<=index_count+1;
		 next_en_be<='0';
		 next_state<=fill_RF_1_2;
		 next_wr_en_1<='1';
		 next_wr_en_2<='1';
		 if(index_count= 126) then--change later make equal to number of extrema
	 		next_state<=done;
		 end if;
			 
	when done=>
		next_state<=IDLE;
 end case;
end process;
end arch_FSM_match;


		
		
		
		
		
		
		
		
		
	
	
	
	


