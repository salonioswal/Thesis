library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity FSM_CB is
	port(div_en		:out std_logic;
		 column		:out std_logic;
		 mac_en		:out std_logic;
		 mac_reset	:out std_logic;
		 wr_en		:out std_logic;
		 wr_add_h	:out unsigned(2 downto 0);
		 rd_add_h	:out unsigned(2 downto 0);
		 corner		:out unsigned(1 downto 0);
		 start		:in std_logic;
		 clock		:in std_logic;
		 reset		:in std_logic;
		 done_s		:out std_logic;
		 en_x		:out std_logic;
		 en_y		:out std_logic
	);
end FSM_CB;
	
architecture CB_ARCH_FSM of FSM_CB is
	
type FSM_state is (IDLE,fill_RF_homo,calc_coord,divide_x,divide_y,store,done);
signal state			: FSM_state;
signal next_state	 	: FSM_state;	
signal next_div_en		:std_logic;
signal next_column		:std_logic;
signal next_mac_en		:std_logic;
signal next_mac_reset	:std_logic;
signal next_wr_en		:std_logic;--for homography matrix
signal next_wr_add_h	:unsigned(2 downto 0);
signal next_rd_add_h	:unsigned(2 downto 0);
--signal next_x_input		:signed(data_wdith-1 downto 0);
--signal next_y_input		:signed(data_width-1 downto 0);
--signal next_z_input		:signed(data_width-1 downto 0);
signal count_H			:unsigned(2 downto 0);--count for homography matrix
signal next_count_H		:unsigned(2 downto 0);
signal next_en_y		:std_logic;
signal next_en_x		:std_logic;
signal next_corner		:unsigned(1 downto 0);

begin
	
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			en_x<='0';
			en_y<='0';
			done_s<='0';
			state	<=IDLE; 		
			div_en	<='0';				
			column	<='0';		
			mac_en	<='0';		
			mac_reset<='0';	
			wr_en	<='0';		
			wr_add_h<=(others=>'0');	
			rd_add_h<=(others=>'0');		
			--x_input	<=(others=>'0');			
			--y_input	<=(others=>'0');			
			--z_input	<=(others=>'0');			
			count_H	<=(others=>'0');	
			corner	<=(others=>'0');
	elsif(rising_edge(clock)) then
			state	<=next_state;	
			div_en	<=next_div_en;			
			column	<=next_column;		
			mac_en	<=next_mac_en;		
			mac_reset<=next_mac_reset;
			wr_en	<=next_wr_en;		
			wr_add_h<=next_wr_add_h;
			rd_add_h<=next_rd_add_h;		
			--x_input	<=next_x_input;			
			--y_input	<=next_y_input;			
			--z_input	<=next_z_input;			
			count_H	<=next_count_H;
			corner	<=next_corner;
			en_x<=next_en_x;
			en_y<=next_en_y;
	end if;
end process;
	
FSM_status: process(all)
	begin
		--default values
		next_state	<=state;	
		next_div_en	<=div_en;			
		next_column	<=column;		
		next_mac_en	<=mac_en;		
		next_mac_reset<=mac_reset;
		next_wr_en	<=wr_en;		
		next_wr_add_h<=wr_add_h;
		next_rd_add_h<=rd_add_h;		
		--next_x_input<=x_input;			
		--next_y_input<=y_input;			
		--next_z_input<=z_input;			
		next_count_H<=count_H;
		next_corner<=corner;
		next_en_x<=en_x;
		next_en_y<=en_y;
	case state is
		when IDLE=>
		if(start='1') then
			next_state<=fill_RF_homo;
			next_count_H	<=(others=>'0');
			next_wr_en<='1';
		end if;
		
	   when fill_RF_homo=>
			next_wr_en<='1';
			next_wr_add_h<=wr_add_h+1;
			next_count_H<=count_H+1;
		if(to_integer(count_H)=7) then
			next_state<=calc_coord;
			next_rd_add_H<=(others=>'0');
			next_count_H<=(others=>'0');
			next_mac_en<='1';
			next_mac_reset<='1';
		end if;
			
		when calc_coord=>
			next_mac_en<='1';
			next_rd_add_H<=rd_add_H+1;
			next_count_H<=count_H+1;
			if(to_integer(count_H)=2) then
				next_state<=divide_x;
				next_count_H<=(others=>'0');
				next_rd_add_H<=(others=>'0');
				
			end if;

		when divide_x=>
			 next_mac_en<='0';
			 next_count_H<=count_H+1;
			 next_div_en<='1';
			 if(to_integer(count_H)=2) then
			 next_state<=divide_y;
			 next_count_H<=(others=>'0');
			 next_column<='1';
			end if;
		
		when divide_y=>
			next_column<='0';
			next_state<=store;
		
		
		when store=>
			next_mac_reset<='0';
			next_count_H<=count_H+1;
if(count_H=1) then
				next_en_x<='1';
				next_en_y<='0';
end if;
			if(count_H=2) then
			if(en_x='1')
				then next_en_y<='1';
				next_en_x<='0';
			end if;
			end if;
			if(to_integer(count_H)=3) then
				next_en_y<='0';
			if(to_integer(corner)=3) then
				next_state<=done;
			else
				next_state<=calc_coord;
				next_rd_add_H<=(others=>'0');
				next_count_H<=(others=>'0');
				next_mac_en<='1';
				next_mac_reset<='1';
				next_div_en<='0';
				next_corner<=corner+1;
				
			end if;
			end if;
		when done=>
			next_state<= IDLE;
			done_s<='1';
			
end case;
end process;
	
end CB_ARCH_FSM;
		
	