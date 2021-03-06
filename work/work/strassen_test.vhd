library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity strassen is
	port(clock		: in std_logic;
		 reset		: in std_logic;
		 data_output: out matrix);
end strassen;

architecture strassen_behv of strassen is
	
signal A: matrix:=(others=>(others=>(others=>'0')));
signal B: matrix:=(others=>(others=>(others=>'0')));
signal C: matrix:=(others=>(others=>(others=>'0')));
signal A_p: m_file:=(others=>(others=>(others=>'0')));
signal B_p: m_file:=(others=>(others=>(others=>'0')));
signal C_p: m_file:=(others=>(others=>(others=>'0')));
type S_M is array (6 downto 0) of signed (data_width-1 downto 0);
signal S: S_M;




begin
process(reset)
begin
for i in 0 to m-1 loop
	A(i)(i)<= to_signed(1,data_width);
	B(i)(i)<= to_signed(1,data_width);
	end loop;
end process;

process(C_p,C,A_p,B_p)
begin
for i in 0 to 1 loop --multiplexer
	for j in 0 to 1 loop --2x2 matrix
		for k in 0 to 1 loop
	
---------------SUBMATRIX-------------------------------------
		for p in 2*i to 2*i+1 loop
				for q in k to k+1 loop
					A_p(p-i)(q-j)<= A(p)(q);
			end loop;
		end loop;
				
			for p in 2*k to 2*k+1 loop
				for q in j to j+1 loop
					B_p(p-i)(q-j)<= A(p)(q);
			end loop;
		end loop;
-------------------------------------------------------------				
				
				
				S(0)<=resize(((A_p(0)(0)+A_p(1)(1))*(B_p(0)(0)+B_p(1)(1))),data_width);
				S(1)<=resize(((A_p(1)(0)+A_p(1)(1))*(B_p(0)(0))),data_width);
				S(2)<=resize(((A_p(0)(0))*(B_p(0)(1)-B_p(1)(1))),data_width);
				S(3)<=resize(((A_p(1)(1))*(B_p(1)(0)-B_p(0)(0))),data_width);
				S(4)<=resize(((A_p(0)(0)+A_p(0)(1))*(B_p(1)(1))),data_width);
				S(5)<=resize(((A_p(1)(0)-A_p(0)(0))*(B_p(0)(0)+B_p(1)(1))),data_width);
				S(6)<=resize(((A_p(0)(1)-A_p(1)(1))*(B_p(1)(0)+B_p(1)(1))),data_width);
		
				C_p(0)(0)<=S(0)+S(3)-S(4)+S(6);
				C_p(0)(1)<=S(2)+S(4);
				C_p(1)(0)<=S(1)+S(3);
				C_p(1)(1)<=S(0)-S(1)+S(2)+S(5);
		end loop;


	end loop;
end loop;
end process;

process(clock, reset)
begin	
if (reset='0') then
	data_output<=(others=>(others=>(others=>'0')));
elsif(rising_edge(clock)) then
	data_output<= C;
end if;
	
end process;
end strassen_behv;