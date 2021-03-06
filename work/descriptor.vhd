library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity datapath_descriptor is
	port(clock: in std_logic;
	 	 reset: in std_logic;
	  	 weight: in signed(data_width-1 downto 0);
	 	 SRAM_value: in signed(data_width-1 downto 0); --SRAM where D values are stored
	 	 SRAMREG_dataout: in signed(data_width-1 downto 0); --SRAM where mag and theta values are stored 
		 SRAM_reg_datain: out signed(data_width-1 downto 0);--SRAM DATA STORING MAG AND ORIENTTATION
		 en_mux_CD: in std_logic;--multiplexer for squaring
		 en_mux_2: in std_logic;--multiplexer for mag/ori
		 en_C: in std_logic;
		 en_D: in std_logic;
		 en_A: in std_logic;
		 en_B: in std_logic;
		 mac_en: in std_logic;
		 reset_mac: in std_logic;
		 make_histogram: in std_logic;
		 bin_cnt: in unsigned(2 downto 0);
		 wr_en_RF:in std_logic;
		 RF_out: out signed(data_width-1 downto 0)
	 	 );
end datapath_descriptor;
	
architecture arch of datapath_descriptor is
	
--COMPONENT-.
component RF is 
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
end component;
		
--mac module		
component mac is
port (Q0 : in signed (data_width-1 downto 0);
		  Q1 : in signed (data_width-1 downto 0);
		  clock: in std_logic;
		  reset: in std_logic;
		  acc: out signed(2*data_width-1 downto 0);
		  mac_en: in std_logic);
	end component;
		 
signal stage_1_A:signed(data_width-1 downto 0);
signal stage_1_B:signed(data_width-1 downto 0);
signal stage_2_C:signed(data_width-1 downto 0);
signal stage_2_D:signed(data_width-1 downto 0);
signal regmac: signed(2*data_width-1 downto 0);
signal muxCD: signed(data_width -1 downto 0);		
signal macA: signed(data_width -1 downto 0);
signal macB: signed(data_width -1 downto 0);
signal RF_input:signed(data_width-1 downto 0);		 
signal atan_value:signed(data_width-1 downto 0);	
signal sqrt_value:signed(data_width-1 downto 0);		 
begin

RF_map: RF port map(input_data=>RF_input,
					output_data=>RF_out,
					wr_en=>wr_en_RF,
					rst_n=>reset,
					clock=>clock,
					wr_add=>bin_cnt,
					rd_add=>bin_cnt);
mac_map: mac port map(Q0=>macA,
					  Q1=>macB,
					  clock=>clock,
					  reset=>reset_mac,
					  acc=>regmac,
					  mac_en=>mac_en);
		 
		 
macA<=muxCD when (make_histogram = '0') else SRAMREG_dataout;
macB<=muxCD when (make_histogram = '0') else weight;  	
muxCD<=stage_2_D when en_mux_CD='1' else stage_2_C;
RF_input<=resize(regmac,data_width);
		 
		 
--orientation and magnitude
TAN_SQRT: process(stage_2_C,stage_2_D,regmac)
variable atan_var, sqrt_var: real;
begin
atan_var:= arctan(real(to_integer(stage_2_C)),real(to_integer(stage_2_D)))*180.0/MATH_PI;
sqrt_var:= sqrt(real(to_integer(regmac)));
atan_value<=to_signed(integer(atan_var), data_width);
sqrt_value<=to_signed(integer(sqrt_var), data_width);
end process;

POUT: process(en_mux_2, atan_value, sqrt_value)
begin
if en_mux_2 = '0' then 
SRAM_reg_datain<= atan_value;
else
SRAM_reg_datain<=sqrt_value;
end if;
end process;

P1: process(clock,reset)
begin
if(reset='0') then
stage_1_A<=(others=>'0');
stage_1_B<=(others=>'0');
stage_2_C<=(others=>'0');
stage_2_D<=(others=>'0');
regmac<=(others=>'0');
elsif(rising_edge(clock)) then
	if en_A = '1' then
		stage_1_A<=SRAM_value;
	end if;
	if en_B = '1' then
		stage_1_B<=SRAM_value;
	end if;
	if en_C = '1' then 
		stage_2_C <= stage_1_A - stage_1_B;
	end if;
	if en_D = '1' then
		stage_2_D <= stage_1_A - stage_1_B;
	end if;	
end if;
end process;
end arch;
	
		 
		 
		 
		 