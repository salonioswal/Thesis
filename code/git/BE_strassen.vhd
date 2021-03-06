library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity BE_strassen is
	port(A		: in m_file;
		 B		: in m_file;
		 C		: out m_file;
		 clock	: in std_logic;
		 reset	: in std_logic);
	end BE_strassen;
	
architecture BE_beh of BE_strassen is
	
	type S_M is array (6 downto 0) of signed (data_width-1 downto 0);
	signal S: S_M;

	begin
				S(0)<=resize(((A(0)(0)+A(1)(1))*(B(0)(0)+B(1)(1))),data_width);
				S(1)<=resize(((A(1)(0)+A(1)(1))*(B(0)(0))),data_width);
				S(2)<=resize(((A(0)(0))*(B(0)(1)-B(1)(1))),data_width);
				S(3)<=resize(((A(1)(1))*(B(1)(0)-B(0)(0))),data_width);
				S(4)<=resize(((A(0)(0)+A(0)(1))*(B(1)(1))),data_width);
				S(5)<=resize(((A(1)(0)-A(0)(0))*(B(0)(0)+B(0)(1))),data_width);
				S(6)<=resize(((A(0)(1)-A(1)(1))*(B(1)(0)+B(1)(1))),data_width);

process(clock,reset)
begin
	if(reset='0') then
		C<=(others=>(others=>(others=>'0')));
	elsif(rising_edge(clock)) then
				C(0)(0)<=S(0)+S(3)-S(4)+S(6);
				C(0)(1)<=S(2)+S(4);
				C(1)(0)<=S(1)+S(3);
				C(1)(1)<=S(0)-S(1)+S(2)+S(5);
	end if;
		
end process;		
		
		
end BE_beh;	
		
		
		