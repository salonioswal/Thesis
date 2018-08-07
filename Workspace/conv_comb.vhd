library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all; 

entity fsm_comb is
	port(data_input		: in signed(data_width -1 downto 0);--input data
		 data_output 	: out signed(2*data_width-1 downto 0);--convolution output
		 rst_n			: IN  std_logic; --! reset negative
		 clk			: IN  std_logic; --! clk
		 start   		: IN  std_logic --! start signal
		 );
	
end fsm_comb;

architecture behav of fsm_comb is
	
signal reset_kernel  :std_logic;	
signal reset_mac     : std_logic; --! reset to mac (positive reset)
signal reset_shifter : std_logic; --! reset to the shifter (rf file) (positive reset)
signal rd_ptr        : unsigned(1 downto 0); --! rd pointer
signal wr_ptr        : unsigned(1 downto 0); --! wr pointer
signal done			 : std_logic;
signal sys_reset	 : std_logic:='1';
signal wr_en		 : std_logic;

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
          mac_en: in std_logic;
		  reset_kernel:in std_logic
		  );
  end component;

component fsm IS
	   port(rst_n	: IN  std_logic; --! reset negative
		clk		: IN  std_logic; --! clk
		start   : IN  std_logic; --! start signal
		wr_en			: out std_logic;
		reset_mac     : out std_logic; --! reset to mac (positive reset)
		reset_shifter : out std_logic; --! reset to the shifter (rf file) (positive reset)
		rd_ptr        : out unsigned(1 downto 0); --! rd pointer
		wr_ptr        : out unsigned(1 downto 0); --! wr pointer
		done          : out std_logic; --! Fsm completed	
		reset_kernel:out  std_logic
	);
END component;

begin

fsm_map: fsm port map(rst_n=>rst_n,
					  clk=>clk,
					  start=>start,
					  wr_en=>wr_en,
					  reset_mac=>reset_mac,
					  reset_shifter=>reset_shifter,
					  reset_kernel=>reset_kernel,
					  rd_ptr=>rd_ptr,
					  wr_ptr=>wr_ptr,
					  done=>done);
	
final_conv_map: final_conv port map(data_input=>data_input,
									data_output=>data_output,
									clock=>clk,
									sys_reset=>sys_reset,
									reset_shifter=>reset_shifter,
									reset_mac=>reset_mac,
									reset_kernel=>reset_kernel,
									wr_ptr=>wr_ptr,
									wr_en=>wr_en,
									rd_ptr=>rd_ptr,
									mac_en=>reset_mac);
end behav;	
					  


	