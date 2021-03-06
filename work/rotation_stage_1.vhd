library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity rotation_stage_1 is
	port(input_x: in signed(data_width-1 downto 0);
		 input_y: in signed(data_width-1 downto 0);
		 bin:in unsigned(5 downto 0);
		 A:out signed(2*data_width-1 downto 0);
		 B:out signed(2*data_width-1 downto 0);
		 C:out signed(2*data_width-1 downto 0);
		 D:out signed(2*data_width-1 downto 0));
end rotation_stage_1;
	
architecture rot_arch_1 of rotation_stage_1 is
signal cos: signed(data_width-1 downto 0);
signal sin: signed(data_width-1 downto 0);

begin
	
process(all)
begin
case bin is
	when("000000")=>
		cos<=(others=>'0');
		sin<=x"0001";
	when others=>
		cos<=(others=>'1');
		sin<=(others=>'0');
end case;
end process;	
	
			A<=cos*input_x;
			B<=sin*input_x;
			C<=sin*input_y;
			D<=cos*input_y;
end rot_arch_1;