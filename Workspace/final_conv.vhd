library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mypackage2.all; 

entity final_conv is
	
	port( data_input: in signed(data_width-1 downto 0);
		  data_output: out signed(2*data_width-1 downto 0);
		  clock: in std_logic;
		  sys_reset: in std_logic;
		  reset_shifter: in std_logic;
		  reset_mac: in std_logic;
		  wr_ptr: in unsigned (1 downto 0);
		  wr_en: in std_logic;
		  rd_ptr: in unsigned (1 downto 0);
                  mac_en: in std_logic;
		 reset_kernel:in  std_logic
		  );
    end final_conv;

architecture behavioral of final_conv is
	



signal Q0 : signed (15 downto 0);
signal Q1 : signed (15 downto 0);
signal acc: signed (31 downto 0);
signal count: signed (1 downto 0):="00";
signal count_en: std_logic;





component mac is
port (	  Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
	end component;
	
component shifter is
	port(input_data: in signed(data_width -1 downto 0);
		 output_data : out signed(data_width-1 downto 0);
		 wr_en: in std_logic;
		 rst_n: in std_logic;
		 clock: in std_logic;
		 wr_ptr: in unsigned (1 downto 0);
		 rd_ptr: in unsigned (1 downto 0));
end component;
							   
	
component kernel is
	
	port(
		 output_data : out signed(data_width-1 downto 0);
		 rst_n: in std_logic;
		 rd_ptr: in unsigned (1 downto 0);
		 clock: in std_logic);
end component;

begin
KERNEL_b: kernel port map(output_data=> Q0,
		 				 rst_n=>reset_kernel,
						 clock=>clock,
						 rd_ptr=>rd_ptr);
		 						   
shifter_stuff: shifter port map(input_data=>data_input,
								output_data=>Q1,
								wr_en=>wr_en,
								rst_n=>reset_shifter,
								clock=>clock,
								wr_ptr=>wr_ptr,
								rd_ptr=>rd_ptr);

M_A_C: mac port map(Q0 => Q0,
		  			Q1 =>Q1,
		  			clock=>clock,
		 			reset=>reset_mac,
		 			acc=>acc,
					mac_en=>mac_en);

								


process(rd_ptr)
begin
if(to_integer(rd_ptr)=0) then
count_en <='0';
else
count_en<='1';
end if;
end process;

process(clock,count_en,count)
begin
if(rising_edge(clock)) then
if(count_en='1') then
count<=count+1;
else 
count<="00";
end if;
end if;
end process;

process(clock,sys_reset)
begin
if sys_reset = '0' then
	data_output<=(OTHERS => '0');
elsif(rising_edge(clock)) then
	if(count="11") then
		data_output<=acc;
	else
		data_output<=(OTHERS => '0');
	end if;
end if;


end process;
end behavioral;
					
							 
								
								
								
								
								
								
		 
							   