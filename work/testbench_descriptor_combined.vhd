library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity test_decriptor_combined is
	end test_decriptor_combined;

architecture bench of testbench_descriptor_combined
	
type FSM_state is (IDLE,start,data_in);
signal state: FSM_state;	
signal next_state: FSM_state;
signal clock:in std_logic;
signal reset:in std_logic;
signal SRAM_1_in:in signed(data_width-1 downto 0);
signal weight:in signed(data_width-1 downto 0);
signal start: in std_logic;
signal count: in unsigned(3 downto 0);
signal state: FSM_state;	
signal next_state: FSM_state;
signal next_reset:in std_logic;
signal next_SRAM_1_in:in signed(data_width-1 downto 0);
signal next_weight:in signed(data_width-1 downto 0);
signal next_start: in std_logic;
signal next_count: in unsigned(3 downto 0);
constant time_delay : time := 10 ns;

begin
dut: entity work.combined 
	port map(clock=>clock,
			 reset=>reset,
			 SRAM_1_in=>SRAM_1_in,
			 weight=>weight,
			 start=>start);
	
process
	begin
		case state is
			when IDLE=>
			reset<='0';
			start<='0';
			count<=(others=>'0');
			weight<=(others=>'0');
			SRAM_1_in<=(others=>'0');
			next_state<=start;
			 
			when start=>
			next_reset<='1';
			next_start<='1';
			next_state<=data_in;

			when data_in=>
			next_reset<='1';
			next_start<='1';
			next_weight<=weight+1;
			next_SRAM_1_in<=SRAM_1_in +1;
			next_count<=count+1;
			if(count=15) then
				next_SRAM_1_in<=(others=>'0');
				next_weight<=(others=>'0');
				next_count<=(others=>'0');
			end if;
		end case;
	end process;
			
			
simulation: process
	begin
		state<=IDLE;
		

		



	