library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity make_histogram_module is
	port(clock:in std_logic;
		 reset:in std_logic;
		 bin_cnt:in unsigned(2 downto 0);
		 bin_inc:out std_logic;
		 input_data:in signed(data_width-1 downto 0);
		 rd_addr_weights:out unsigned(3 downto 0);
		 rd_addr_SRAM_2:in unsigned(3 downto 0);
		 data_count: in unsigned(3 downto 0);
		 mac_en: out std_logic;
		 enable: in std_logic);
		 
end entity;

architecture arch_hist of make_histogram_module is

	
begin
	
clocked_process: process(clock,reset)
	begin
		if(reset='0') then
			rd_addr_weights<=(others=>'0');
			bin_inc<='0';
			mac_en<='0';
		elsif(rising_edge(clock)) then
			if(enable='1') then
				if(to_integer(input_data)=to_integer(bin_cnt))then 
				rd_addr_weights<=rd_addr_SRAM_2;
				mac_en<='1';
				end if;
		   		 if(data_count=15) then
					bin_inc<='1';
				else 
					bin_inc<='0';
				end if;
			end if;
		end if;
	end process;
			
end arch_hist;			




