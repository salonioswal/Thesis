library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity combined is
	port(clock:in std_logic;
		 reset:in std_logic;
		 SRAM_1_in:in signed(data_width-1 downto 0);
		 weight:in signed(data_width-1 downto 0);
		 start: in std_logic
		 );
end combined;
	
architecture arch_com of combined is
	

component des_DP is
port(SRAM_1_in		:in signed(data_width-1 downto 0);
	 SRAM_2_in		:out signed(data_width-1 downto 0);
	 SRAM_2_out		:in signed(data_width-1 downto 0);
	 clock			:in std_logic;
	 reset			:in std_logic;
	 weight			:in signed(data_width-1 downto 0);
	 make_histogram	:in std_logic;
	 bin_cnt		:in unsigned(2 downto 0); --read pointer foor register file
	 en_A			:in std_logic;-- is register file ready?
	 en_B			:in std_logic;
	 en_C			:in std_logic;
	 en_D			:in std_logic;
	 mux_CD_sel		:in std_logic;
	 reset_mac		:in std_logic;
	 wr_en_RF		:in std_logic;
	 mac_en			:in std_logic;
	 mag_ori_mux	:in std_logic;
	 en_cal			:in std_logic);
end component;
	
component make_histogram_module is
	port(clock:in std_logic;
		 reset:in std_logic;
		 bin_cnt:in unsigned(2 downto 0);
		 bin_inc:out std_logic;
		 input_data:in signed(data_width-1 downto 0);
		 rd_addr_weights:out unsigned(3 downto 0);
		 rd_addr_SRAM_2:in unsigned(3 downto 0);
		 data_count: in unsigned(3 downto 0);
		 mac_en: out std_logic;
		 enable: in std_logic);
end component;
	
component fsm_descriptor is
	port(start			:in std_logic;
		clock			:in std_logic;
		reset			:in std_logic;
		make_histogram	:out std_logic;
		bin_cnt			:out unsigned(2 downto 0); --read pointer foor register file
		en_A			:out std_logic;-- is register file ready?
		en_B			:out std_logic;
		en_C			:out std_logic;--x coordinate of gradient
		en_D			:out std_logic;--y coordinate of gradient
		mux_CD_sel		:out std_logic;--input for mac
		reset_mac		:out std_logic;
		wr_en_RF		:out std_logic;--register file for histogram
		--mac_en			:out std_logic;
		mag_ori_mux		:out std_logic;--input for sram (mag or orientation)
		bin_inc			:in std_logic; -- change angle bin
		en_cal			:out std_logic;--enable angle calculation
		done_s			:out std_logic;
		RF_wr_addr		:out unsigned(3 downto 0); --register file to store angles-- SRAM_2 in this case
		rd_addr_SRAM_2	:out unsigned(3 downto 0)
		);
end component;
	
--sram to store orientation
component SRAM_Descriptor is
PORT ( 	rd_addr	 	: in unsigned (3 downto 0);
       	data_out 	: out signed (data_width-1 downto 0);
		data_in 	:in signed (data_width-1 downto 0);
		clock		: in std_logic;
		wr_addr		: in unsigned (3 downto 0);
		wr_en_sram	: in std_logic;
		reset		: in std_logic);
END component;

----------signals------
signal make_histogram		:std_logic;
signal bin_cnt			:unsigned(2 downto 0); --read pointer foor register file
signal en_A			:std_logic;-- is register file ready?
signal en_B			:std_logic;
signal en_C			:std_logic;--x coordinate of gradient
signal en_D			:std_logic;--y coordinate of gradient
signal mux_CD_sel		:std_logic;--input for mac
signal reset_mac		:std_logic;
signal wr_en_RF			:std_logic;--register file for histogram
signal mag_ori_mux		:std_logic;--input for sram (mag or orientation)
signal bin_inc			:std_logic; -- change angle bin
signal en_cal			:std_logic;--enable angle calculation
signal done_s			:std_logic;
signal RF_wr_addr		:unsigned(3 downto 0); --register file to store angles-- SRAM_2 in this case
signal rd_addr_SRAM_2		:unsigned(3 downto 0);
signal SRAM_2_in		:signed(data_width-1 downto 0);
signal SRAM_2_out		:signed(data_width-1 downto 0);	
signal mac_en			:std_logic;
signal  rd_addr_weights		:unsigned(3 downto 0);

begin
	
map_sram_2:SRAM_descriptor port map(rd_addr=>rd_addr_sram_2,
     							  	data_out=>SRAM_2_out,	
									data_in=>SRAM_2_in,
									clock=>clock,		
									wr_addr=>RF_wr_addr,			
									wr_en_sram=>en_cal,	
									reset=>reset);

map_fsm_descriptor: fsm_descriptor port map (start=>start,
		clock=>clock,
		reset=>reset,
		make_histogram=>make_histogram,
		bin_cnt=>bin_cnt,
		en_A=>en_A,
		en_B=>en_B,	
		en_C=>en_C,		
		en_D=>en_D,			
		mux_CD_sel=>mux_CD_sel,		
		reset_mac=>reset_mac,		
		wr_en_RF=>wr_en_RF,		
		mag_ori_mux=>mag_ori_mux,		
		bin_inc=>bin_inc,			
		en_cal=>en_cal,			
		done_s=>done_s,			
		RF_wr_addr=>RF_wr_addr,
		rd_addr_SRAM_2=>rd_addr_SRAM_2	);		
	
map_des_DP: des_DP port map(SRAM_1_in=>SRAM_1_in,
	 SRAM_2_in=>SRAM_2_in,
	 SRAM_2_out=>SRAM_2_out,	
	 clock=>clock,	
	 reset=>reset,	
	 weight=>weight,			
	 make_histogram=>make_histogram,	
	 bin_cnt=>bin_cnt,		
	 en_A=>en_A,			
	 en_B=>en_B,			
	 en_C=>en_C,			
	 en_D=>en_D,			
	 mux_CD_sel=>mux_CD_sel,		
	 reset_mac=>reset_mac,		
	 wr_en_RF=>wr_en_RF,		
	 mac_en=>mac_en,			
	 mag_ori_mux=>mag_ori_mux,	
	 en_cal=>en_cal);	
	
map_make_histogram_module: make_histogram_module port map(
		 clock=>clock,
		 reset=>reset,
		 bin_cnt=>bin_cnt,
		 bin_inc=>bin_inc,
		 input_data=>SRAM_2_out,
		 rd_addr_weights=>rd_addr_weights,
		 rd_addr_SRAM_2=>rd_addr_SRAM_2,
		 data_count=>rd_addr_SRAM_2,
		 mac_en=>mac_en,
		 enable=>make_histogram);
end arch_com;
