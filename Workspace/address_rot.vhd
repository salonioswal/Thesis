library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity address_rot is
	port(clock: in std_logic;
		reset: in std_logic;
		enable: in std_logic;
		output_x:out signed(data_width-1 downto 0);
		output_y:out signed(data_width-1 downto 0);
		bin: in unsigned(5 downto 0)
		);
end address_rot;
	
architecture add_arch of address_rot is

component rotation is
	port(clock: in std_logic;
		 reset: in std_logic;
		 output_x: out signed(data_width-1 downto 0);
		 output_y: out signed(data_width-1 downto 0);
		 bin: in unsigned(5 downto 0);--36 bins(orientation of keypoint for rotation)
		 input_x: in signed(data_width-1 downto 0);
		 input_y: in signed(data_width-1 downto 0);
		 en: in std_logic
		 );
end component;
	
component address_calc is
	port(clock:in std_logic;
		 reset:in std_logic;
		 input_x:out signed(data_width-1 downto 0);
		 input_y:out signed(data_width-1 downto 0);
		 module_en:in std_logic 
		);
end component;

signal input_x: signed(data_width-1 downto 0);
signal input_y: signed(data_width-1 downto 0);

begin
	
rotation_map: rotation port map(clock=>clock,
								reset=>reset,
								output_x=>output_x,
								output_y=>output_y,
								bin=>bin,
								input_x=>input_x,
								input_y=>input_y,
								en=>enable);
address_calc_map: address_calc port map(clock=>clock,
										reset=>reset,
										input_x=>input_x,
										input_y=>input_y,
										module_en=>enable);
end add_arch;										
										
										
										
								
								
								
								
								
	
	
	
	
	