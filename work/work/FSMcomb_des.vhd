library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity FSM_comb_d is
	port(clock: in std_logic;
		reset: in std_logic;
		rd_addr_d: out unsiged(9 downto 0);
		rd_addr_mo: out unsigned(8 downto 0);
		wr_en_d:out std_logic;
		wr_en_mo:out std_logic;
		wr_addr_d:out unsigned(9 downto 0);
		wr_addr_mo:out unsigned(8 downto 0);
		bin_cnt: out unsigned(2 downto 0);
		make_histogram: in std_logic;
		start: out std_logic;
		start_comp: in std_logic;
		rd_addr_w: out unsigned( 7 downto 0);
		done_s: in std_logic;
		out_reset: out std_logic);
end FSM_comb_d;
	
architecture arch_FCD of FSM_comb_d is
	
type FSM_state is (IDLE,fill_SRAM_1,FSM_2_mag_x,FSM_2_mag_y,make_hist,done);
signal state			: FSM_state;
signal next_state	 	: FSM_state;
signal sram_1_cnt		: unsigned(9 downto 0);
signal next_sram_1_cnt	: unsigned(9 downto 0);
signal next_rd_addr_d	: unsiged(9 downto 0);
signal next_rd_addr_mo	:unsiged(8 downto 0);
signal next_rd_addr_w	:unsiged(7 downto 0);
signal next_wr_en_d		:std_logic;
signal next_wr_en_mo	:std_logic;
signal next_bin_cnt		:unsigned(2 downto 0)
signal next_start		:std_logic;
signal out_reset		: std_logic;
signal next_wr_addr_d		:unsigned(9 downto 0);
signal next_wr_addr_mo		:unsigned(8 downto 0);
signal fill_cnt				:unsigned(7 downto 0);
signal next_fill_cnt		:unsigned(7 downto 0);
begin

clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			state<=IDLE;
			sram_1_cnt<=(others=>'0');
			rd_addr_d<=(others=>'0');
			rd_addr_mo<=(others=>'0');
			wr_en_d<='0';
			wr_en_mo<='0';
			rd_addr_w<=(others=>'0');
			bin_cnt<=(others=>'0');
			start<='0';
			out_reset<='0';
			wr_addr_d<=(others=>'0');
			wr_addr_mo<=(others=>'0');
			fill_cnt<=(others=>'0');
		elsif(rising_edge(clock)) then
			state<=next_state;
			rd_addr_d<=next_rd_addr_d;
			rd_addr_mo<=next_rd_addr_mo;
			rd_addr_w<=next_rd_addr_w;
			wr_en_d<=next_wr_en_d;
			wr_en_mo<=next_wr_en_mo;
			wr_addr_d<=next_wr_addr_d;
			wr_addr_mo<=next_wr_addr_mo;
			bin_cnt<=next_bin_cnt;
			start<=next_start;
			out_reset<=next_out_reset;
			sram_1_cnt<=next_sram_1_cnt;
			fill_cnt<=next_fill_cnt;
		end if;
	end process;
			
FSM_status: process(all)
	begin
		--default values
			next_state<=state;
			next_rd_addr_d<=rd_addr_d;
			next_rd_addr_mo<=rd_addr_mo;
			next_rd_addr_w<=rd_addr_w;
			next_wr_en_d<=wr_en_d;
			next_wr_en_mo<=wr_en_mo;
			next_bin_cnt<=bin_cnt;
			next_start<=start;
			next_out_reset<=out_reset;
			next_sram_1_cnt<=sram_1_cnt;
			next_wr_addr_mo<=wr_addr_mo;
			next_wr_addr_d<=wr_addr_d;
			next_fill_cnt<=fill_cnt;
case state is
	when IDLE=>
			sram_1_cnt<=(others=>'0');
			rd_addr_d<=(others=>'0');
			rd_addr_mo<=(others=>'0');
			wr_en_d<='0';
			wr_en_mo<='0';
			rd_addr_w<=(others=>'0');
			bin_cnt<=(others=>'0');
			start<='0';
			out_reset<='0';
		 	if(start_comp='1') then
				next_state<=fill_sram_1;
				next_wr_en_d<='1';
				reset_out<='0';
			end if;
	
	when fill_sram_1=>
			next_wr_en_d<='1';
			next_wr_addr_d<=wr_addr_d +1;
			next_sram_1_cnt<=sram_1_cnt +1;
			if(sram_1_cnt=1023) then --change for simulation
				next_state<=FSM_2_mag;
				next_out_reset<='1';
				next_start<='1';
				next_wr_en_d<='0';
			end if;
	when FSM_2_mag_x=>
			next_fill_cnt<=fill_cnt+1;
			next_rd_addr_d<=fill_cnt+1;
			next_state<=FSM_2_mag_y;
 	when FSM_2_mag_y=>
			next_rd_addr<=rd_addr+15; --column -1 (gets element vertically below)
			next_state<=FSM_2_mag_x;
			if(fill_cnt= 255)
				





	
	
	
	
	
	
	
	
	
