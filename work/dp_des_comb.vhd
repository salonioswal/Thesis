library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity dp_des_comb is
	port(clock: in std_logic;
		reset: in std_logic;
		data_input: in signed(data_width-1 downto 0);
		sram_2_in: in signed(data_width-1 downto 0);
		sram_2_out: out signed(data_width-1 downto 0);
		SRAM_1_in: out signed(data_width-1 downto 0);
		weights: out signed(data_width-1 downto 0);
		rd_addr_d: in unsiged(9 downto 0);
		rd_addr_mo: in unsigned(8 downto 0);
		rd_addr_w: in unsigned( 7 downto 0);
		wr_en_d:in std_logic;
		wr_en_mo:in std_logic;
		wr_addr_d:in unsigned(9 downto 0);
		wr_addr_mo:in unsigned(8 downto 0);
		bin_cnt: in unsigned(2 downto 0);
		make_histogram: in std_logic;
		mac_en: out std_logic;
		);
end dp_des_comb;
	
architecture arch_dc of dp_des_comb is
	

component SRAM_d is
	
PORT ( 	rd_addr	 	: in unsigned (9 downto 0);
       	data_out 	: out signed (data_width-1 downto 0);
		data_in 	: in signed (data_width-1 downto 0);
		clock		: in std_logic;
		wr_addr		: in unsigned (9 downto 0);
		wr_en_sram	: in std_logic;
		reset		: in std_logic);
END component;
	
component SRAM_mo is	
PORT ( 	rd_addr	 	: in unsigned (8 downto 0);
       	data_out 	: out signed (data_width-1 downto 0);
		data_in 	:in signed (data_width-1 downto 0);
		clock		: in std_logic;
		wr_addr		: in unsigned (8 downto 0);
		wr_en_sram	: in std_logic;
		reset		: in std_logic);
END component;

component ROM_weights is 
PORT ( rd_addr : in unsigned (7 downto 0);
       data_out: out signed (data_width-1 downto 0));
END component;	

signal SRAM_2_out_x: signed(data_width-1 downto 0); 
signal weights_x: signed(data_width-1 downto 0);

begin
	
sram_d_map: sram_d port map (rd_addr=>rd_addr_d,	
    					   	data_out=>SRAM_1_in, 	
							data_in=>data_input,	
							clock=>clock,	
							wr_addr=>wr_addr_d,		
							wr_en_sram=>wr_en_d,	
							reset=>reset);
sram_mo_map: sram_mo port map(rd_addr=>rd_addr_mo,	 	
      					 	data_out=>SRAM_2_out_x,	 	
							data_in=>SRAM_2_in, 	
							clock=>clock,		
							wr_addr=>wr_addr,		
							wr_en_sram=>wr_en_mo,	
							reset=>reset);
rom_weight_map: ROM_weights port map(rd_addr=>rd_addr_w,
									 data_out=>weights_x);
	
process(clock)
	begin
		if(rising_edge(clock)) then
			if(make_histogram ='1') then
				if(SRAM_2_out_x = bin_cnt) then
					SRAM_2_out<=SRAM_2_out_x;
					weights<=weights_x;
					mac_en<='1';
				else
					mac_en<='0';
					SRAM_2_out<=(others=>'0');
					weights<=(others=>'0');
				end if;
			else
				else
					mac_en<='0';
					SRAM_2_out<=(others=>'0');
					weights<=(others=>'0');
			end if;
				
		end if;
	end process;
end arch_des;
		
		
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
