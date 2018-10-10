Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all;


entity kernel is
	port(
		 output_data : out signed(data_width-1 downto 0);
		 rst_n: in std_logic;
		 rd_ptr: in unsigned (1 downto 0);
		 clock: in std_logic);
end kernel;
	
architecture behavioral_kernel of kernel is
signal kernel_coeff: reg_file(3 downto 0):= (x"0001",x"ffff", x"0001", x"ffff");
begin
--Read
process(rst_n,rd_ptr)
begin
if rst_n= '0' then
	output_data <= (others => '0');
else
	output_data<= kernel_coeff(to_integer(rd_ptr));
end if;
end process;
		
end behavioral_kernel;