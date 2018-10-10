library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity comb_match is
	port(clock:in std_logic;
		 reset:in std_logic;
		 Des_1_input:in signed(data_width-1 downto 0);
		 Des_2_input:in signed(data_width-1 downto 0);
		 start:in std_logic
		);
end comb_match;
	
architecture arch_cm of comb_match is

component FSM_match_BE is
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
end component;

component matching_be is
	port(input_des_1:in signed(data_width-1 downto 0);--vector of descriptor from image 1
		 input_des_2:in signed(data_width-1 downto 0);
		 clock: in std_logic;
		 reset:in std_logic;
		 mac_en:in std_logic;
		 mac_reset:in std_logic;
		 module_enable:in std_logic;
		 output_distance: out signed(2*data_width-1 downto 0)
		 );
end component;	

component RF_Match is
	port(input_data	: in signed(data_width-1 downto 0);
		 output_data: out signed(data_width-1 downto 0);
		 clock		: in std_logic;
		 reset		: in std_logic;
		 rd_ptr		: in unsigned(6 downto 0);
		 wr_ptr		: in unsigned(6 downto 0);
		 wr_en		: std_logic);
end component;

signal output_distance_new: signed(data_width-1 downto 0);
signal output_distance: signed(2*data_width-1 downto 0);
signal min_1: signed(data_width-1 downto 0); --nearest neighbour
signal min_2: signeD(data_width-1 downto 0); --second nearest neighbours
signal rd_addr_1	:unsigned(6 downto 0);
signal rd_addr_2	:unsigned(6 downto 0);
signal wr_addr_1	:unsigned(6 downto 0);
signal wr_addr_2	:unsigned(6 downto 0);
signal wr_en_1      :std_logic; --enable for RF_1 (descriptors of 1st image)
signal wr_en_2	:std_logic; --enable for RF_2 (descriptors of 2nd image)
signal mac_en	:std_logic;
signal mac_reset	:std_logic;
signal en_be	:std_logic;
signal input_des_1:signed(data_width-1 downto 0);--vector of descriptor from image 1
signal input_des_2:signed(data_width-1 downto 0);
signal store_s		:std_logic;
begin
	
FSM_match_map: FSM_match_BE port map(reset=>reset,
		clock=>clock,
		start=>start,
		rd_addr_1=>rd_addr_1,	
		rd_addr_2=>rd_addr_2,
		wr_addr_1=>wr_addr_1,
		wr_addr_2=>wr_addr_2,
		wr_en_1=>wr_en_1,     
		wr_en_2=>wr_en_2,		
		mac_en=>mac_en,		
		mac_reset=>mac_reset,	
		en_be=>en_be,		
		store_s=>store_s);
	
Match_BE_map:  matching_be port map(input_des_1=>input_des_1,
		 input_des_2=>input_des_2,
		 clock=>clock,
		 reset=>reset,
		 mac_en=>mac_en,
		 mac_reset=>mac_reset,
		 module_enable=>en_be,
		 output_distance=>output_distance);
	
RF_map_1:RF_match port map(input_data=> Des_1_input,
		 output_data=>input_des_1,
		 clock=>clock,	
		 reset=>reset,
		 rd_ptr=>rd_addr_1,		
		 wr_ptr=>wr_addr_1,		
		 wr_en=>wr_en_1);
	
RF_map_2: RF_match port map(input_data=> Des_2_input,
		 output_data=>input_des_2,
		 clock=>clock,	
		 reset=>reset,
		 rd_ptr=>rd_addr_2,		
		 wr_ptr=>wr_addr_2,		
		 wr_en=>wr_en_2);
	
output_distance_new<=resize(output_distance, data_width);
														
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			min_1<=(others=>'0');
			min_2<=(others=>'0');
		elsif(rising_edge(clock)) then
			if(store_s='1') then
				if(output_distance_new<min_1) then
					min_1<=output_distance_new;
					min_2<=min_1;
					--add match index
				elsif(output_distance_new<min_2) then
					min_2<=output_distance_new;
				end if;
			end if;
		end if;
	end process;
	
	
end arch_cm;
	

