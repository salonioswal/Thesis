library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;


entity des_DP is
port(SRAM_1_in		:in signed(data_width-1 downto 0);
	 SRAM_2_in		:out signed(data_width-1 downto 0);
	 SRAM_2_out		:in signed(data_width-1 downto 0);
	 clock			:in std_logic;
	 reset			:in std_logic;
	 weight			:in signed(data_width-1 downto 0);
	 make_histogram	:in std_logic;
	 bin_cnt		:in unsigned(2 downto 0); --read pointer foor register file
	 en_A			:in std_logic;-- is register file ready?
	 en_B			:in std_logic;
	 en_C			:in std_logic;
	 en_D			:in std_logic;
	 mux_CD_sel		:in std_logic;
	 reset_mac		:in std_logic;
	 wr_en_RF		:in std_logic;
	 mac_en			:in std_logic;
	 mag_ori_mux	:in std_logic;
	 en_cal			:in std_logic);
end des_DP;
	
architecture arch_DP of des_DP is
	
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

	
--tan module	
component atan2_s is
  generic (
    g_size : integer := 16
    );
  port (
    x : in signed(g_size-1 downto 0);
    y : in signed(g_size-1 downto 0);
    output : out signed(g_size-1 downto 0)
    );
end component;
-----------------------------------
signal A: signed(data_width-1 downto 0);
signal B: signed(data_width-1 downto 0);
signal C: signed(data_width-1 downto 0);
signal D: signed(data_width-1 downto 0);
signal macA:signed(data_width-1 downto 0);-- mac inputs
signal macB: signed(data_width-1 downto 0);
signal mux_reg_mo: signed(data_width-1 downto 0);--mag and ori mux for sram 2 data input
signal regmac: signed(2*data_width-1 downto 0);
signal RF_input: signed(data_width-1 downto 0);
signal RF_out: signed(data_width-1 downto 0);
signal mux_CD: signed(data_width-1 downto 0);
signal atan_value: signed(data_width-1 downto 0);
signal sqrt_value:signed(data_width-1 downto 0);
signal atan_out:signed(data_width-1 downto 0);
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
	
atan_map: atan2_s port map(x=>C,
						   y=>D,
						   output=>atan_out);

macA<=mux_CD when make_histogram='0' else  SRAM_2_out;
macB<=mux_CD when make_histogram='0' else weight;
mux_CD<=C when mux_CD_sel='0' else D;

tan process(C,D,regmac,en_cal)
	begin
		if(en_cal='1') then
			atan_value<=atan_out;
			sqrt_value<=(others=>'0');
        else
			atan_value<=(others=>'0');
	        sqrt_value<=(others=>'0');
end if;
end process;

output_sram: process(mag_ori_mux, atan_value, sqrt_value)
begin
if  mag_ori_mux= '0' then 
SRAM_2_in<= atan_value;
else
SRAM_2_in<=sqrt_value;
end if;
end process;
	
clocked_process: process(clock,reset)
begin
if(reset='0') then
	atan_value<=(others=>'0');
	A<=(others=>'0');
	B<=(others=>'0');
	C<=(others=>'0');
	D<=(others=>'0');
	RF_input<=(others=>'0');
	regmac<=(others=>'0');
elsif(rising_edge(clock)) then
	if(make_histogram='0') then
		if(en_A='1') then
			A<=SRAM_1_in;
		end if;
		if(en_B='1') then
			B<=SRAM_1_in;
		end if;
		if en_c = '1' then 
			C <= A - B;
		end if;
		if en_D = '1' then
			D <= A - B;
		end if;	
	else
		RF_input<=resize(regmac,data_width);
	end if;
end if;
end process;

			
end arch_DP;		
			
			