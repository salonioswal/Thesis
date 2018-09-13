library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity address_calc is
	port(clock:in std_logic;
		 reset:in std_logic;
		 input_x:out signed(data_width-1 downto 0);
		 input_y:out signed(data_width-1 downto 0);
		 module_en:in std_logic
		 
		);
end address_calc;
	
architecture arch_addr of address_calc is
signal y: integer:=0;
signal x: integer:=0;
signal j: integer:=0;
signal k: integer:=0;
signal cnt_k:integer:=0;
signal cnt_x:integer:=0;
signal cnt_y:integer:=0;
signal val_x: signed(data_width-1 downto 0):=to_signed(-7,data_width);
signal val_y:signed(data_width-1 downto 0):=to_signed(8,data_width);
begin

process(clock,reset)

begin


if(reset='0') then
	input_x<=(others=>'0');
	input_y<=(others=>'0');
elsif(rising_edge(clock)) then
	if(module_en='1') then
		if(y<=3) then
			if(x<=3) then
				if(k<=3) then
					if(j<=3) then
						input_x<=val_x+to_signed(j,data_width);
						input_y<=val_y-to_signed(k,data_width);
						j<=j+1;
					end if;
					if(j=3) then
						k<=k+1;
						j<=0;
					end if;
					if(k=3) then
						
						cnt_k<=cnt_k+1;
						if(cnt_k=3) then
							k<=0;
							x<=x+1;
							val_x<=val_x+4;
							cnt_k<=0;
						end if;
					end if;
					if(x=3) then
						
						cnt_x<=cnt_x+1;
						 if(cnt_x=15) then
							 x<=0;
							y<=y+1;
							val_y<=val_y-4;
							cnt_x<=0;
						end if;
					end if;
					if(y=3) then
						cnt_y<=cnt_y+1;
						if(cnt_y=63) then
							cnt_y<=0;
							
						end if;
					end if;
				end if;
			
			end if;
		
				
		end if;
	end if;
end if;			
end process;
end arch_addr;
				
						