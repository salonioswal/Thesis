library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity RF_DP is
generic (in_ports: INTEGER:=1;
         out_ports: INTEGER:=1;
         slots: INTEGER:=8);
port(input_data: in signed(data_width-1 downto 0); --data width is the parameter which gives the input size, kept in myPackage
	 output_data: out signed(data_width-1 downto 0); 
	 wr_en: in std_logic;
	 rst_n: in std_logic;
	 clock: in std_logic;
	 wr_add: in unsigned(2 downto 0);
	 rd_add: in unsigned(2 downto 0));
end RF_DP;

architecture behaviour of RF_DP is

signal RF_data: RF(0 to slots-1);

begin

output_data <= RF_data(to_integer(rd_add));  --read the data at the rd_pointed location asynchronously

wr_Proc: process(rst_n, clock) --wrProcess for synchronous writing
begin
	if rst_n = '0' then
	RF_data <= (others =>(others => '0'));
	elsif clock'event and clock = '1' then
	if wr_en = '1' then
	RF_data(to_integer(wr_add))<= input_data; --write the input data at the wr_pointed location
	end if;
	end if;
end process;

--rd_Proc: process(rd_ptr)
--begin
	--output_data <= reg_file(to_integer(rd_ptr));  --read the data at the rd_pointed location
--end process; 
end behaviour;


