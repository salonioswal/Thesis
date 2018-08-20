Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all;

entity test_mac is
	end test_mac;
	
architecture tst_b of test_mac is
		  signal Q0 : signed (data_width-1 downto 0);
		  signal Q1 :  signed (data_width-1 downto 0);
		  signal clock: std_logic;
		  signal reset: std_logic;
		  signal acc:  signed(2*data_width-1 downto 0);
		  signal mac_en: std_logic;
constant time_delay : time := 10 ns;
begin
dut: entity work.mac 
	port map(Q0=>Q0,
		  Q1=>Q1, 
		  clock=>clock,
		  reset=>reset,
		  acc=>acc,
		  mac_en=>mac_en);
	
simulation: process
begin
	Q1<=x"0000";
	Q0<=x"0000";
	reset<='0';
	mac_en<='0';
	wait for time_delay;
	Q1<=x"0001";
	Q0<=x"0002";
	reset<='1';
	mac_en<='1';
	wait for time_delay;
	Q1<=x"0002";
	Q0<=x"0008";
	wait for 2*time_delay;
	

end process;	

clkgeneration_FC: process
	begin
		clock<= '1';
		wait for time_delay/2;
		clock<= '0';
	        wait for time_delay/2;
	end process clkgeneration_FC;
				
end tst_b;				
				