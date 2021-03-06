library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity rotation is
	port(clock: in std_logic;
		 reset: in std_logic;
		 output_x: out signed(data_width-1 downto 0);
		 output_y: out signed(data_width-1 downto 0);
		 bin: in unsigned(5 downto 0);--36 bins(orientation of keypoint for rotation)
		 input_x: in signed(data_width-1 downto 0);
		 input_y: in signed(data_width-1 downto 0);
		 en: in std_logic
		 );
end rotation;
	
architecture arch_rot of rotation is 

component rotation_stage_1 is
	port(input_x: in signed(data_width-1 downto 0);
		 input_y: in signed(data_width-1 downto 0);
		 bin:in unsigned(5 downto 0);
		 A:out signed(2*data_width-1 downto 0);
		 B:out signed(2*data_width-1 downto 0);
		 C:out signed(2*data_width-1 downto 0);
		 D:out signed(2*data_width-1 downto 0));
end component;

component rotation_stage_2 is
	port(A:in signed(2*data_width-1 downto 0);
		 B:in signed(2*data_width-1 downto 0);
		 C:in signed(2*data_width-1 downto 0);
		 D:in signed(2*data_width-1 downto 0);
		 output_x: out signed(data_width-1 downto 0);
		 output_y: out signed(data_width-1 downto 0));
end component;

	
signal reg_A:signed(2*data_width-1 downto 0);
signal reg_B:signed(2*data_width-1 downto 0);
signal reg_C:signed(2*data_width-1 downto 0);
signal reg_D:signed(2*data_width-1 downto 0);
signal next_reg_A:signed(2*data_width-1 downto 0);
signal next_reg_B:signed(2*data_width-1 downto 0);
signal next_reg_C:signed(2*data_width-1 downto 0);
signal next_reg_D:signed(2*data_width-1 downto 0);

begin
	
stage_1_map: rotation_stage_1 port map(input_x=>input_x,
									   input_y=>input_y,
									   bin=>bin,
									   A=>reg_A,
									   B=>reg_B,
									   C=>reg_C,
									   D=>reg_D);
stage_2_map: rotation_stage_2  port map(A=>next_reg_A,
										B=>next_reg_B,
										C=>next_reg_C,
										D=>next_reg_D,
										output_x=>output_x,
										output_y=>output_y);
										
process(clock,reset)
begin	
if(reset='0') then

next_reg_A<=(others=>'0');
next_reg_B<=(others=>'0');
next_reg_C<=(others=>'0');
next_reg_D<=(others=>'0');
elsif(rising_edge(clock)) then
	if(en='1') then
	next_reg_A<=reg_A;
	next_reg_B<=reg_B;
	next_reg_C<=reg_C;
	next_reg_D<=reg_D;	
end if;
end if;
end process;
end arch_rot;

	
