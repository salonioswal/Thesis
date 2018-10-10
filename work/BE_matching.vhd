library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity matching_be is
	port(input_des_1:in signed(data_width-1 downto 0);--vector of descriptor from image 1
		 input_des_2:in signed(data_width-1 downto 0);
		 clock: in std_logic;
		 reset:in std_logic;
		 mac_en:in std_logic;
		 mac_reset:in std_logic;
		 module_enable:in std_logic;
		 output_distance: out signed(2*data_width-1 downto 0)
		 );
end matching_be;
	
architecture arch_match of matching_be is
	
signal distance: signed(data_width-1 downto 0);

component mac is	
	port (Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
end component;
	
begin

map_mac: mac port map (Q0=>distance,
					   Q1=>distance,
					   clock=>clock,
					   reset=>mac_reset,
					   acc=>output_distance,
					   mac_en=>mac_en);
	
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			distance<=(others=>'0');
		elsif(rising_edge(clock)) then
			  if(module_enable='1') then
				distance<=(input_des_1-input_des_2);
			  end if;
		end if;
	end process;
			  
end arch_match;
	
					   
					   
					   
					   
					   
					   
	
	