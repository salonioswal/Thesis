library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity RF_homo is

port(input_data: in signed(data_width-1 downto 0); --data width is the parameter which gives the input size, kept in myPackage
	 output_data_1: out signed(data_width-1 downto 0); 
	 output_data_2: out signed(data_width-1 downto 0);
	 output_data_3: out signed(data_width-1 downto 0);
	 wr_en: in std_logic;
	 rst_n: in std_logic;
	 clock: in std_logic;
	 wr_add: in unsigned(2 downto 0);
	 rd_add: in unsigned(2 downto 0));
end RF_homo;

architecture behaviour of RF_homo is

signal RF_data: RF(7 downto 0);

begin

output_data_1 <= RF_data(to_integer(rd_add));  --read the data at the rd_pointed location asynchronously
output_data_2 <= RF_data(to_integer(rd_add+3));

process(all)
	begin
if((rd_add=2)) then
output_data_3<=to_signed(1,data_width);
else
output_data_3 <= RF_data(to_integer(rd_add+6));
end if;
	end process;
	
wr_Proc: process(rst_n, clock) --wrProcess for synchronous writing
begin

	if rst_n = '0' then
	RF_data <= (others =>(others => '0'));
	elsif rising_edge(clock) then
		if wr_en = '1' then
			RF_data(to_integer(wr_add))<= input_data; --write the input data at the wr_pointed location
	end if;
	end if;
end process;

end behaviour;



