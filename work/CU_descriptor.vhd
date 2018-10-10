library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity FSM_CU is
	port();
end FSM_CU;

architecture FSM_CU is

type FSM_state is (IDLE,SRAM_FILL_MAG, SRAM_FILL_HISTOGRAM,FIND_MAG,MAKE_HISTOGRAM,STORE,DONE);
signal state		 : FSM_state;
signal next_state	 : FSM_state;
signal next_en_mux_CD: std_logic;--multiplexer for squaring
signal next_en_mux_2:  std_logic;--multiplexer for mag/ori
signal next_en_C:  std_logic;
signal next_en_D:  std_logic;
signal next_en_A:  std_logic;
signal next_en_B:  std_logic;
signal next_mac_en: std_logic;
signal next_reset_mac: std_logic;
signal next_make_histogram: std_logic;--mux for mac
signal next_bin_cnt: unsigned(2 downto 0);
signal next_wr_en_RF: std_logic;
		 
