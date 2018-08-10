library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all; 
use work.all;

entity final_sram_con is
port(
	data_input	:in signed(data_width-1 downto 0);
	data_output	: out signed(2*data_width-1 downto 0);
	clock		:in std_logic;
	start   	: IN  std_logic; --! start signal
	rst_n	 	: IN  std_logic; --! reset negative
	reset		: in std_logic; --sram reset
	wr_addr		: in unsigned (coeff_width-1 downto 0);
	wr_en_sram	: in std_logic);

	end final_sram_con;
	
architecture beh_FSC of final_sram_con is
	component final_conv is	
	port( data_input	: in signed(data_width-1 downto 0);
		  data_output	: out signed(2*data_width-1 downto 0);
		  clock			: in std_logic;
		  sys_reset		: in std_logic;
		  reset_shifter	: in std_logic;
		  reset_mac		: in std_logic;
		  wr_ptr		: in unsigned (1 downto 0);
		  wr_en			: in std_logic;
		  rd_ptr		: in unsigned (1 downto 0);
          mac_en		: in std_logic;
		  reset_kernel	:in std_logic
		  );
end component;
	
component fsm IS
	   port(rst_n	  : IN  std_logic; --! reset negative
		clk			  : IN  std_logic; --! clk
		start   	  : IN  std_logic; --! start signal
		wr_en		  : out std_logic;
		reset_mac     : out std_logic; --! reset to mac (positive reset)
		reset_shifter : out std_logic; --! reset to the shifter (rf file) (positive reset)
		reset_rf_out  : out std_logic;	
		rd_ptr        : out unsigned(1 downto 0); --! rd pointer
		wr_ptr        : out unsigned(1 downto 0); --! wr pointer
		done          : out std_logic; --! Fsm completed	
		reset_kernel  :out  std_logic;
		rd_addr	 	: out unsigned (coeff_width-1 downto 0);
		wr_ptr_out: out unsigned (coeff_width-1 downto 0);
		wr_en_rf	: out std_logic
	);
END component;

component RF_output is
PORT ( 	rd_addr	 	: in unsigned (coeff_width-1 downto 0);
       	dataout 	: out signed (2*data_width-1 downto 0);
		datain 		: in signed (2*data_width-1 downto 0);
		clock		: in std_logic;
		wr_addr		: in unsigned (coeff_width-1 downto 0);
		wr_en_rf	: in std_logic;
		reset		: in std_logic);
END component;

component SRAM IS	
PORT ( 	rd_addr	 	: in unsigned (coeff_width-1 downto 0);
       	data_out 	: out signed (data_width-1 downto 0);
		data_in 	:in signed (data_width-1 downto 0);
		clock		: in std_logic;
		wr_addr		: in unsigned (coeff_width-1 downto 0);
		wr_en_sram	: in std_logic;
		reset		: in std_logic);
END component SRAM;	

signal reset_rf_out   : std_logic;	
signal  reset_mac     :  std_logic; --! reset to mac (positive reset)
signal  reset_shifter : std_logic; --! reset to the shifter (rf file) (positive reset)
signal	rd_ptr        :  unsigned(1 downto 0); --! rd pointer
signal	wr_ptr        :  unsigned(1 downto 0); --! wr pointer
signal	done          :  std_logic; --! Fsm completed	
signal	reset_kernel  :  std_logic ;
signal data_out 	  :  signed (data_width-1 downto 0); --sram data_out
signal sys_reset	  : std_logic:='1'; 	
signal rd_addr	 	  : unsigned (coeff_width-1 downto 0);
signal wr_en		  : std_logic;
signal wr_ptr_out	  : unsigned (coeff_width-1 downto 0);
signal wr_en_rf		  :  std_logic;
signal dataout 	: signed (2*data_width-1 downto 0);
begin
	
final_conv_map: 

final_conv port map( data_input	=> data_out,
		  data_output=>data_output,
		  clock=>clock,	
		  sys_reset=>sys_reset,	
		  reset_shifter=>reset_shifter,	
		  reset_mac=>reset_mac,	
		  wr_ptr=>wr_ptr,		
		  wr_en	=>wr_en,
		  rd_ptr=>rd_ptr,
          mac_en=>reset_mac,
		  reset_kernel=>reset_kernel
		  );

fsm_map: FSM port map(	rst_n=>rst_n,
		clk	=>clock,
		start =>start,
		wr_en=>wr_en,
		reset_mac =>reset_mac,
		reset_shifter=>reset_shifter,
		reset_rf_out=>reset_rf_out,
		rd_ptr =>rd_ptr,
		wr_ptr=>wr_ptr,
		done =>done,
		rd_addr=>rd_addr,
		reset_kernel =>reset_kernel,
		 wr_ptr_out=>wr_ptr_out,
		wr_en_rf=>wr_en_rf);
	
sram_map: SRAM port map(
		rd_addr	 =>rd_addr,
       	data_out =>data_out,
		data_in =>data_input,
		clock=>clock,
		wr_addr	=>wr_addr,
		wr_en_sram=>wr_en_sram,
		reset=>reset);
	
Rr_out_map: RF_output port map(rd_addr=>rd_addr,
       	dataout=>dataout,
		datain =>data_output,
		clock	=>clock,
		wr_addr	=>wr_ptr_out,
		wr_en_rf=>wr_en_rf,
		reset=>reset_rf_out);
							
	
	
end beh_FSC;	
	
	