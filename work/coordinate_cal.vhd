library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity calc_coordinate is
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
end calc_coordinate;
	
architecture calc_bound_arch of calc_coordinate is
	
component mac is
	port (Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
end component;
	
begin
map_mac_1: mac port map(Q0=>coordinate_input,
		 		Q1=>Homography_input_1,
		  		clock=>clock,
		  		reset=>mac_reset,
		  		acc=>acc_x,
		  		mac_en=>mac_en);
map_mac_2: mac port map(Q0=>coordinate_input,
		 		Q1=>Homography_input_2,
		  		clock=>clock,
		  		reset=>mac_reset,
		  		acc=>acc_y,
		  		mac_en=>mac_en);
map_mac_3: mac port map(Q0=>coordinate_input,
		 		Q1=>Homography_input_3,
		  		clock=>clock,
		  		reset=>mac_reset,
		  		acc=>acc_z,
		  		mac_en=>mac_en);
	

end calc_bound_arch;




