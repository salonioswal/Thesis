Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all;


entity shifter is
	port(input_data: in signed(data_width -1 downto 0);
		 output_data : out signed(data_width-1 downto 0);
		 wr_en: in std_logic;
		 rst_n: in std_logic;
		 clock: in std_logic;
		 wr_ptr: in unsigned (1 downto 0);
		 rd_ptr: in unsigned (1 downto 0));
end shifter;
	
architecture behavioral_shifter of shifter is
signal RF_data: reg_file(3 downto 0):= (others =>(others => '0'));
begin
--Read
output_data<= RF_data(to_integer(rd_ptr));

write_process:
	process(clock,rst_n)
	begin
	if rst_n= '0' then
	RF_data <= (others =>(others => '0'));  
	elsif rising_edge(clock) then 
			if(wr_en='1') then
				RF_Data(to_integer(wr_ptr))<= input_data; --write the input data 
			end if;
	end if;
end process;
		
end behavioral_shifter;