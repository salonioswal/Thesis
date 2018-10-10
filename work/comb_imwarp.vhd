library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity comb_imwarp is
	port(clock	: in std_logic;
		reset	: in std_logic;
		start	: in std_logic;
		coordinate_input: in signed(data_width-1 downto 0);
		input_data: in signed(data_width-1 downto 0);
		store_result: out std_logic;
		result_out			:out signed(data_width-1 downto 0));
end comb_imwarp;
	
architecture arch_c_imwarp of comb_imwarp is
	
component calc_coordinate is
	port(coordinate_input:in signed(data_width-1 downto 0);
		 Homography_input_1:in signed(data_width-1 downto 0);
		 Homography_input_2:in signed(data_width-1 downto 0);
		 Homography_input_3:in signed(data_width-1 downto 0);
		 clock	: in std_logic;
		 reset	: in std_logic;
		 mac_en	: in std_logic;
		 mac_reset: in std_logic;
		 acc_x	:out signed(2*data_width-1 downto 0);
		 acc_y	:out signed(2*data_width-1 downto 0);
 		 acc_z	:out signed(2*data_width-1 downto 0)
		 );
end component;

component division_FSM is
	port(FSM_en	:in std_logic;
		clock	:in std_logic;
		reset	:in std_logic;
		column	:out std_logic;
		div_en	:out std_logic;
		 store_res: out std_logic
		--done_div:in std_logic
		);
end component;
	
component fsm_mac is
	port(clock:in std_logic;
		 reset:in std_logic;
		 fsm_en:in std_logic;
		 mac_en		:out std_logic;
		 mac_reset	:out std_logic;
		 rd_add_h	:out unsigned(3 downto 0);
		 done_fsm	:in std_logic;
		store_s		:out std_logic);
end component;

component fsm_imwarp is
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
end component;
	
component RF_homo_inv is
port(input_data: in signed(data_width-1 downto 0); --data width is the parameter which gives the input size, kept in myPackage
	 output_data_1: out signed(data_width-1 downto 0); 
	 output_data_2: out signed(data_width-1 downto 0);
	 output_data_3: out signed(data_width-1 downto 0);
	 wr_en: in std_logic;
	 rst_n: in std_logic;
	 clock: in std_logic;
	 wr_add: in unsigned(3 downto 0);
	 rd_add: in unsigned(3 downto 0));
end component;
	
--divider module		
component DW_div_pipe is
  generic (
    a_width     : positive;                           -- divisor word width
    b_width     : positive;                           -- dividend word width
    tc_mode     : natural   := 0;         -- '0' : unsigned, '1' : 2's compl.
    rem_mode    : natural   := 1;         -- '0' : modulus, '1' : remainder
    num_stages  : positive := 3;                      -- number of pipeline stages
    stall_mode  : natural   := 1;         -- '0' : non-stallable, '1' : stallable
    rst_mode    : natural   := 1;         -- '0' : none, '1' : async, '2' : sync
    op_iso_mode : natural   := 0);        -- operand isolation selection
  port (
    clk         : in  std_logic;                      -- register clock
    rst_n       : in  std_logic;                      -- register reset
    en          : in  std_logic;                      -- register enable
    a           : in  signed(a_width-1 downto 0);  -- divisor
    b           : in  signed(b_width-1 downto 0);  -- dividend
    quotient    : out signed(a_width-1 downto 0);  -- quotient
    remainder   : out signed(b_width-1 downto 0);  -- remainder
    divide_by_0 : out std_logic);                  -- divide by zero flag
end component;


signal Homography_input_1	:signed(data_width-1 downto 0);
signal Homography_input_2	:signed(data_width-1 downto 0);
signal  Homography_input_3	:signed(data_width-1 downto 0);
signal  mac_en				: std_logic;
signal  mac_reset			: std_logic;
signal  acc_x				: signed(2*data_width-1 downto 0);
signal  acc_y				: signed(2*data_width-1 downto 0);
signal  acc_z				: signed(2*data_width-1 downto 0);
signal  FSM_en_div			: std_logic;
signal	column				: std_logic;
signal	div_en				: std_logic;
signal	FSM_done_div		: std_logic;
signal  fsm_en_mac			: std_logic;
signal	rd_add_h			: unsigned(3 downto 0);
signal	done_fsm_mac		: std_logic;
signal  wr_en				: std_logic;
signal	wr_add_h			: unsigned(3 downto 0);
signal  div_in_1			: signed(2*data_width-1 downto 0);
signal  div_in_2			: signed(data_width-1 downto 0);	
signal  result				: signed(2*data_width-1 downto 0);

signal store_s				: std_logic;
signal reg_x				: signed(2*data_width-1 downto 0);
signal reg_y				: signed(2*data_width-1 downto 0);
signal reg_z				: signed(2*data_width-1 downto 0);
signal reset_div			: std_logic;
signal store_res			:std_logic;
begin
	
--Mapping component
calc_coordinate_map: calc_coordinate port map(coordinate_input=>coordinate_input,
		 Homography_input_1=>Homography_input_1,
		 Homography_input_2=>Homography_input_2,
		 Homography_input_3=>Homography_input_3,
		 clock=>clock,
		 reset=>reset,	
		 mac_en=>mac_en,	
		 mac_reset=>mac_reset,
		 acc_x=>acc_x,
		 acc_y=>acc_y,
 		 acc_z=>acc_z);

 division_FSM_map:  division_FSM port map(FSM_en=>store_s,
		clock=>clock,	
		reset=>reset,	
		column=>column,	
		div_en=>div_en,
		store_res=>store_res
										  
		);
		--reset_div=>reset_div)
	 
fsm_mac_map: fsm_mac port map(clock=>clock,
		 reset=>reset,
		 fsm_en=>fsm_en_mac,
		 mac_en=>mac_en,
		 mac_reset=>mac_reset,
		 rd_add_h=>rd_add_h,
		 done_fsm=>done_fsm_mac,
		store_s=>store_s);	

fsm_imwarp_map: fsm_imwarp port map(clock=>clock,
		 reset=>reset,
		 en_FSM_mac=>fsm_en_mac,
		 en_FSM_div=>fsm_en_div,
		 wr_en=>wr_en,
		 wr_add_h=>wr_add_h,	
		 done_FSM_mac=>done_FSM_mac,
		 done_FSM_div=>FSM_done_div,
		 start=>start);
	
RF_homo_inv_map: RF_homo_inv port map(input_data=>input_data,
	 output_data_1=>Homography_input_1,
	 output_data_2=>Homography_input_2,
	 output_data_3=>Homography_input_3,
	 wr_en=>wr_en,
	 rst_n=>reset,
	 clock=>clock,
	 wr_add=>wr_add_h,
	 rd_add=>rd_add_h);
	
DIVIDER_map:  DW_div_pipe 			     
				generic map(a_width=>32,    -- divisor word width
							b_width=>16,    -- dividend word width
							tc_mode=>1,     -- '0' : unsigned, '1' : 2's compl.
							rem_mode=>0,    -- '0' : modulus, '1' : remainder
							num_stages=>3,  -- number of pipeline stages
							stall_mode=>1,  -- '0' : non-stallable, '1' : stallable
							rst_mode=>1,    -- '0' : none, '1' : async, '2' : sync
							op_iso_mode=>4) -- operand isolation selection							
port map(clk=>clock,                        -- register clock
	 	rst_n=> reset,                      -- register reset
         en=>div_en,                        -- register enable
	 	 a=>div_in_1,  --dividend
         b=>div_in_2,  -- divisor
         quotient=>result,  -- quotient 
         remainder=>OPEN,   -- remainder
		 divide_by_0=>OPEN);
	
store_result<=store_res;
result_out<=result(data_width-1 downto 0);

clocked_process: process(clock,reset)
	begin
	if(reset='0') then
		div_in_1<=(others=>'0');
		div_in_2<=(others=>'0');
		reg_x<=(others=>'0');
		reg_y<=(others=>'0');
	    reg_z<=(others=>'0');
		--result_out<=(others=>'0');
		
  elsif(rising_edge(clock)) then
	   div_in_2<=reg_z(15 downto 0);
		--if(store_res='1') then
		--result_out<=result(data_width-1 downto 0);
		--end if;
	if(div_en='1') then
	   if(column='0') then
		   div_in_1<=reg_x;
	   elsif(column='1') then
		   div_in_1<=reg_y;
	   end if;
	end if;	
	if(store_s='1') then
		reg_x<=acc_x;
		reg_y<=acc_y;
		reg_z<=acc_z;
	end if;
		   
	end if;
--end if;

		
end process;
end arch_c_imwarp;