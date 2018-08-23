library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity strassen_level is
	port(A_1	: in m_file;
		 B_1	: in m_file;
		 C  	: out m_file;
		 clock	: in std_logic;
		 reset	: in std_logic);
end strassen_level;
	
architecture beh_SL of strassen_level is
	signal A_p : m_file;
	signal B_p : m_file;
	signal C_p : m_file;
	signal data_output: m_file;

component BE_strassen is
	port(A: in m_file;
		 B: in m_file;
		 C: out m_file;
		 clock: in std_logic;
		 reset: in std_logic);
	end component;
	
begin
	
strassen: BE_strassen port map(A=>A_p,
							   B=>B_p,
							   C=>C_p,
							   clock=>clock,
							   reset=>reset);
	
A_p <= A_1; 
B_p <= B_1;							   

process(clock,reset)
	begin
		if(reset='0') then
			data_output<=(others=>(others=>(others=>'0')));
		elsif(rising_edge(clock)) then
			data_output(0)(0)<= data_output(0)(0)+C_p(0)(0);
			data_output(0)(1)<= data_output(0)(1)+C_p(0)(1);
			data_output(1)(0)<= data_output(1)(0)+C_p(1)(0);
			data_output(1)(1)<= data_output(1)(1)+C_p(1)(1);
		end if;
			
end process;
		
		C<=data_output;
		
end beh_SL;
							   
							   
							   
							   