Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all;
use work.my_functions.all;


entity mac is
	
	port (Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
	end mac;
	
architecture behavioral_mac of mac is
	signal reg: signed(2*data_width-1 downto 0):=(OTHERS => '0');
	signal prod: signed(2*data_width-1 downto 0);
	
begin	

process(clock,reset)
VARIABLE sum: SIGNED(2*data_width-1 DOWNTO 0);
begin

if(reset='0') then
	reg<=(OTHERS => '0');
	prod<=(others=>'0');
elsif(rising_edge(clock) and mac_en='1') then
	prod<=Q0*Q1;
	sum := add_truncate (prod, reg, 32);--check overflow and saturation
	reg<=sum;
end if;
end process;
	
--check for overflow
acc<= reg;

end behavioral_mac;
