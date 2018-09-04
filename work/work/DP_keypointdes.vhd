Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
library work; 
use work.types_consts.all;
use work.misc.all;

entity DP_AssignOrientation is
port(clock: in std_logic;
	  rst_n: in std_logic;
	  weight: in signed(data_width-1 downto 0);
	  SRAM_value: in signed(data_width-1 downto 0); --SRAM where D values are stored
	  SRAMREG_dataout: in signed(data_width-1 downto 0); --SRAM where mag and theta values are stored 
	  make_hist_n: in std_logic; --if 1 the window the system is evaluating the window (reg_theta and mag) otherwise the 36 bin histogram is being computed
	  find_max: in std_logic; --if 0 the 36 bin is not completed and the system will wait before starting finding the maximum value
	  mag_theta_n: in std_logic; --'1' if the mag value has evaluated, '0' otherwise
	  enA: in std_logic;
	  enB: in std_logic;
	  enU: in std_logic;
	  enV: in std_logic;
	  multi: in std_logic;
	  mux_tan_mod: in std_logic; --choose tan module (if 8 bins or 36 bins) either orientation assigment or keypoint descriptor
	  en_regtheta: in std_logic;
	  rst_reg_n: in std_logic;
	  u_or_v_n: in std_logic;
	  bin_cnt: in unsigned(5 downto 0);
	  enRegMac: in std_logic;
	  wr_RF: in std_logic; --signal that, if '1' enables the writing into the register file, otherwise read
	  SRAM_reg_datain: out signed(data_width-1 downto 0);
	  reg_theta: out signed(data_width-1 downto 0);  
	  max_value: out signed(data_width-1 downto 0);
	  indxMAX: out unsigned(log2_ceil(36)-1 downto 0);
	  bin_tc: in std_logic;
	  --DEBUG SIGNALS---
	  D_U: out signed(data_width-1 downto 0);
	  D_V: out signed(data_width-1 downto 0);
	  D_A: out signed(data_width-1 downto 0);
	  D_B: out signed(data_width-1 downto 0);
          D_regmac: out signed(2*data_width-1 downto 0);
	  RF_out: out signed(data_width-1 downto 0)); --signal that contains the maximum orientation value
end DP_AssignOrientation;

architecture behaviour of DP_AssignOrientation is

--COMPONENT-.
component RF is 
generic (in_ports: INTEGER:=1;
         out_ports: INTEGER:=1;
         slots: INTEGER:=36);
port(input_data: in signed(data_width-1 downto 0); --data width is the parameter which gives the input size, kept in myPackage
	 output_data: out signed(data_width-1 downto 0); 
	 wr_en: in std_logic;
	 rst_n: in std_logic;
	 clock: in std_logic;
	 wr_add: in unsigned(log2_ceil(slots)-1 downto 0);
	 rd_add: in unsigned(log2_ceil(slots)-1 downto 0));
end component;


component DW02_prod_sum1 is
   generic( A_width: NATURAL;             -- multiplier wordlength
            B_width: NATURAL;             -- multiplicand wordlength
            SUM_width: NATURAL);          -- multiplicand wordlength  
   port(A : in std_logic_vector(A_width-1 downto 0);  
        B : in std_logic_vector(B_width-1 downto 0);
        C : in std_logic_vector(SUM_width-1 downto 0);
        TC : in std_logic;          
        SUM : out std_logic_vector(SUM_width-1 downto 0));
-- pragma dc_tcl_script_begin
-- set_attribute [current_design] "canonical_name" "DW02_prod_sum1" -type "string" -quiet
-- pragma dc_tcl_script_end
	
end component;

signal A, B, U,V, regtheta: signed(data_width-1 downto 0);  
signal atan_value, sqrt_value: signed(data_width-1 downto 0);
signal mag_value: signed(data_width-1 downto 0);
signal macA, macB: signed(data_width -1 downto 0);
signal macOut_slv: std_logic_vector(2*data_width-1 downto 0);
signal regmac, macOut: signed(2*data_width-1 downto 0);
signal muxUV: signed(data_width -1 downto 0);
signal RF_input: signed(data_width-1 downto 0);
signal indexMAX: unsigned(log2_ceil(36)-1 downto 0);
signal lastmax: std_logic;


begin

RF_out<=mag_value;
indxMAX<=indexMAX when lastmax = '0' else
	 bin_cnt;

lastmax<=rst_reg_n and enU and bin_tc;
  

D_A<=A;
D_B<=B;
D_U<=U;
D_V<=V;
D_regmac<=regmac;

reg_theta<=regtheta;

macOut<=signed(macOut_slv);

max_value<=U;

muxUV<=U when u_or_v_n='1' else 
       V;

TAN_SQRT: process(U,V,regmac)
variable atan_var, sqrt_var: real;
begin
	if(en_cal='1') then
atan_var:= arctan(real(to_integer(V)),real(to_integer(U)))*180.0/MATH_PI;
sqrt_var:= sqrt(real(to_integer(regmac)));
atan_value<=to_signed(integer(atan_var), data_width);
sqrt_value<=to_signed(integer(sqrt_var), data_width);
else
	atan_value<=(others=>'0');
	sqrt_value<=(others=>'0');
end if;
end process;



macA<=muxUV when (make_hist_n = '1') else SRAMreg_dataout;
macB<=muxUV when (make_hist_n = '1') else weight;  


U1 : DW02_prod_sum1
    generic map ( A_width => data_width,   
	          B_width => data_width,
                 SUM_width => 2*data_width )
    port map ( A => std_logic_vector(macA),   B => std_logic_vector(macB),   C => std_logic_vector(regmac), 
               TC => '1',   SUM => macOut_slv);


				
RF_input<= regmac(30 downto 15);
					
HIST: RF port map(input_data=>RF_input,
					   output_data=>mag_value,
						wr_en=>wr_RF,
						rst_n=>rst_n,
						clock=>clock,
						wr_add=>bin_cnt,
						rd_add=>bin_cnt);


POUT: process(mag_theta_n, atan_value, sqrt_value)
begin
if mag_theta_n = '0' then 
SRAM_reg_datain<= atan_value;
else
SRAM_reg_datain<=sqrt_value;
end if;
end process;


P1: process(clock, rst_n)
begin
if rst_n = '0' then 
A<=(others=>'0');
B<=(others=>'0');
U<=(others=>'0');
V<=(others=>'0');
regtheta<=(others=>'0');
regmac<=(others=>'0');
indexMax<=(others=>'0');
elsif clock'event and clock = '1' then
if rst_reg_n = '0' then 
A<=(others=>'0');
B<=(others=>'0');
U<=(others=>'0');
V<=(others=>'0');
regtheta<=(others=>'0');
regmac<=(others=>'0');
elsif find_max = '0' then
if enA = '1' then
A<=SRAM_value;
end if;
if enB = '1' then
B<=SRAM_value;
end if;
if enU = '1' then 
U <= A - B;
end if;
if enV = '1' then
V <= A - B;
end if;
if en_regtheta = '1' then
regtheta<=SRAMREG_dataout;
end if;
if enregmac = '1' then
if make_hist_n = '1' then --1 means that the magnitude and orientation is evaluated
regmac<=macOut;
else --the histogram is evaluated
regmac<=macOut;
end if;
end if; 
elsif enU = '1' then --find_max = '1' -> we are looking for the maximum
U<=mag_value;
indexMax<=bin_cnt;
end if;
end if;
end process; 
 
 
end behaviour;
