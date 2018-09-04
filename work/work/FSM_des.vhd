library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity fsm_descriptor is
	port(start			:in std_logic;
		clock			:in std_logic;
		reset			:in std_logic;
		make_histogram	:out std_logic;
		bin_cnt			:out unsigned(2 downto 0); --read pointer foor register file
		en_A			:out std_logic;-- is register file ready?
		en_B			:out std_logic;
		en_C			:out std_logic;
		en_D			:out std_logic;
		mux_CD_sel		:out std_logic;
		reset_mac		:out std_logic;
		wr_en_RF		:out std_logic;
		mac_en			:out std_logic;
		mag_ori_mux		:out std_logic;
		bin_inc			:in std_logic;
		en_cal			:out std_logic;
		done_s			:out std_logic
		);
end fsm_descriptor;

architecture arch_des of fsm_descriptor is
	
--signal bin_inc
type FSM_state is (IDLE,Calculate_x,Calculate_y,Angle,HISTOGRAM,DONE);
signal state		 : FSM_state;
signal next_state	 : FSM_state;
signal next_make_histogram	:std_logic;
signal next_bin_cnt			:unsigned(2 downto 0); --read pointer foor register file
signal next_en_A			:std_logic;-- is register file ready?
signal next_en_B			:std_logic;
signal next_en_C			:std_logic;
signal next_en_D			:std_logic;
signal next_mux_CD_sel		:std_logic;
signal next_reset_mac		:std_logic;
signal next_wr_en_RF		:std_logic;
signal next_mac_en			:std_logic;
signal next_mag_ori_mux		:std_logic;

signal sram_count			:unsigned(7 downto 0);
signal next_sram_count		:unsigned(7 downto 0);
signal next_en_cal			:std_logic;

begin
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			state<=IDLE;
			make_histogram<='0';
			bin_cnt<=(others=>'0');
			en_A<='0';
			en_B<='0';
			en_D<='0';
			en_C<='0';
			mux_CD_sel<='0';
			reset_mac<='0';
			wr_en_RF<='0';
			mac_en<='0';
			mag_ori_mux<='0';
			done_s<='0';
			
			sram_count<=(others=>'0');
			en_cal<='0';
		elsif(rising_edge(clock)) then
			state<=next_state;
			make_histogram<=next_make_histogram;
			bin_cnt<=next_bin_cnt;
			en_A<=next_en_A;
			en_B<=next_en_B;
			en_D<=next_en_D;
			en_C<=next_en_C;
			mux_CD_sel<=next_mux_CD_sel;
			reset_mac<=next_reset_mac;
			wr_en_RF<=next_wr_en_RF;
			mac_en<=next_mac_en;
			mag_ori_mux<=next_mag_ori_mux;
			
			sram_count<=next_sram_count;
			en_cal<=next_en_cal;
		end if;
end process;
			
FSM_status: process(all)
begin
	--default values
	next_state<=state;
	next_make_histogram<=make_histogram;
	next_bin_cnt<=bin_cnt;
	next_en_A<=en_A;
	next_en_B<=en_B;
	next_en_D<=en_D;
	next_en_C<=en_C;
	next_mux_CD_sel<=mux_CD_sel;
	next_reset_mac<=reset_mac;
	next_wr_en_RF<=wr_en_RF;
	next_mac_en<=mac_en;
	next_mag_ori_mux<=mag_ori_mux;
	done_s<='0';

	next_sram_count<=sram_count;
	next_en_cal<=en_cal;
case state is
	when IDLE=>
		next_make_histogram<='0';
		next_bin_cnt<=(others=>'0');
		next_en_A<='0';
		next_en_B<='0';
		next_en_D<='0';
		next_en_C<='0';
		next_en_cal<='0';
		next_mux_CD_sel<='0';
		next_reset_mac<='0';
		next_wr_en_RF<='0';
		next_mac_en<='0';
		next_mag_ori_mux<='0';
		
		next_sram_count<=(others=>'0');
		if(start='1') then
			next_en_A<='1';
			next_state<=calculate_x;
	end if;
		
	when calculate_X=>
		
		if(en_A='1') then
			next_en_B<='1';
			next_en_A<='0';
	    end if;
		if(en_B='1') then
			next_en_C<='1';
			next_en_B<='0';
		end if;
		if(en_C='1')then
			next_state<=calculate_y;
			next_en_C<='0';
			next_en_B<='1';
		end if;
			
	when calculate_y=>
			
			if(en_B='1') then
				next_en_D<='1';
				next_en_B<='0';
			end if;
			if(en_D='1') then
				next_sram_count<=sram_count+1;
				next_state<=angle;
				next_en_cal<='1';
				next_mag_ori_mux<='0';
			end if;
	when Angle=>next_en_cal<='0';
				if(sram_count=3)then--change late
					next_state<=histogram;
					next_make_histogram<='1';
					next_reset_mac<='1';
					next_mac_en<='1';
				else
					next_en_A<='1';
					next_state<=calculate_x;
				end if;
					
	
	when histogram=>
					next_reset_mac<='1';
					next_mac_en<='1';
					if(bin_inc='1') then
						next_bin_cnt<=bin_cnt+1;
						next_wr_en_RF<='1';
						next_reset_mac<='0';
					end if;
					if(bin_cnt=7) then
						next_state<=done;
					END IF;
	when done=>
				done_s<='1';
				next_state<=idle;						
end case;					
end process;
end arch_des;				
						
			
				
			
				






			
			
			
			
			
			
			
			
	
			
			
			
			
			
			
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		