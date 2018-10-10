library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all; 
use work.all;

entity comb_cal is
	port(clock: in std_logic;
		reset: in std_logic;
		start: in std_logic;
		input_data:in signed(data_width-1 downto 0));
end comb_cal;
	
architecture arch_cc of comb_cal is
	
component calc_bound is
	port(coordinate_input:in signed(data_width-1 downto 0);
		 Homography_input_1:in signed(data_width-1 downto 0);
		 Homography_input_2:in signed(data_width-1 downto 0);
		 Homography_input_3:in signed(data_width-1 downto 0);
		 div_en	: in std_logic;
		 clock	: in std_logic;
		 reset	: in std_logic;
		 column	: in std_logic;
		 mac_en	: in std_logic;
		 mac_reset: in std_logic;
		 result_out: out signed(data_width-1 downto 0)
		 );
end component;
	
component RF_homo is
port(input_data: in signed(data_width-1 downto 0); 
	 output_data_1: out signed(data_width-1 downto 0); 
	 output_data_2: out signed(data_width-1 downto 0); 
	 output_data_3: out signed(data_width-1 downto 0); 
	 wr_en: in std_logic;
	 rst_n: in std_logic;
	 clock: in std_logic;
	 wr_add: in unsigned(2 downto 0);
	 rd_add: in unsigned(2 downto 0));
end component;
	
component FSM_CB is
	port(div_en		:out std_logic;
		 column		:out std_logic;
		 mac_en		:out std_logic;
		 mac_reset	:out std_logic;
		 wr_en		:out std_logic;
		 wr_add_h	:out unsigned(2 downto 0);
		 rd_add_h	:out unsigned(2 downto 0);
		 corner		:out unsigned(1 downto 0);
		 start		:in std_logic;
		 clock		:in std_logic;
		 reset		:in std_logic;
		 done_s		:out std_logic;
		 en_x		:out std_logic;
		 en_y		:out std_logic
	);
end component;

--signal x_min			: signed(data_width-1 downto 0);
--signal y_min			: signed(data_width-1 downto 0);
signal coordinate_input	: signed(data_width-1 downto 0);
signal result_out		: signed(data_width-1 downto 0);
signal x_min		: signed(data_width-1 downto 0);
signal y_min		: signed(data_width-1 downto 0);
signal x_max		: signed(data_width-1 downto 0);
signal y_max		: signed(data_width-1 downto 0);
signal corner			: unsigned(1 downto 0);
signal div_en			:std_logic;
signal column			:std_logic;
signal mac_en			:std_logic;
signal mac_reset		:std_logic;
signal wr_en			:std_logic;
signal wr_add_h			:unsigned(2 downto 0);
signal rd_add_h			:unsigned(2 downto 0);
signal done_s			: std_logic;
signal Homography_input_1: signed(data_width-1 downto 0);
signal Homography_input_2: signed(data_width-1 downto 0);
signal Homography_input_3: signed(data_width-1 downto 0);	
signal en_x				:std_logic;
signal en_y				:std_logic;

			 
begin
	
MAP_FSM: FSM_CB port map (div_en=>div_en,
		 column=>column,
		 mac_en=>mac_en,
		 mac_reset=>mac_reset,
		 wr_en=>wr_en,
		 wr_add_h=>wr_add_h,
		 rd_add_h=>rd_add_h,
		 corner=>corner,
		 start=>start,
		 clock=>clock,
		 reset=>reset,
		 done_s=>done_s,
		 en_x=>en_x,
		 en_y=>en_y);
	
MAP_RF_homo: RF_homo port map (input_data=>input_data,
	 output_data_1=>Homography_input_1,
	 output_data_2=>Homography_input_2,
	 output_data_3=>Homography_input_3,
	 wr_en=>wr_en,
	 rst_n=>reset,
	 clock=>clock,
	 wr_add=>wr_add_h,
	 rd_add=>rd_add_h);
	
MAP_calc_bound: calc_bound port map(coordinate_input=>coordinate_input,
		 Homography_input_1=>Homography_input_1,
		 Homography_input_2=>Homography_input_2,
		 Homography_input_3=>Homography_input_3,
		 div_en=>div_en,	
		 clock=>clock,
		 reset=>reset,
		 column=>column,	 
		 mac_en=>mac_en,	 
		 mac_reset=>mac_reset,
		 result_out=>result_out);
	
	
	
	
process(all)
	begin							
		if(to_integer(rd_add_h )= 0) then
			if(corner(0)='0') then
				coordinate_input<=to_signed(1,data_width);
			elsif(corner(0)='1') then
				coordinate_input<=to_signed(256,data_width);
			end if;
		elsif(to_integer(rd_add_h) = 1) then
			if(corner(1)='0') then
				coordinate_input<=to_signed(1,data_width);
			elsif(corner(1)='1') then
				coordinate_input<=to_signed(256,data_width);
			end if;
		elsif(to_integer(rd_add_h) = 2) then	  
			coordinate_input<=to_signed(1,data_width);
		end if;
end process;
			
process(reset,clock)
			begin
				if(reset='0') then
					x_min<=(others=>'0');
					y_min<=(others=>'0');
					x_max<=(others=>'0');
					y_max<=(others=>'0');
			elsif(rising_edge(clock)) then
			 if(en_x='1') then
				if(corner=0) then
					x_min<=result_out;
					x_max<=result_out;
				else
					if(x_min>result_out) then
						x_min<=result_out;
					elsif(x_max<result_out) then
						x_max<=result_out;
					end if;
			  end if;
		elsif(en_y='1') then
			if(corner=0) then
				y_min<=result_out;
				y_max<=result_out;
			else
				if(y_min>result_out) then
					y_min<=result_out;
				elsif(y_max<result_out) then
					y_max<=result_out;
				end if;
			end if;
		end if;
				
			end if;
end process;

end arch_cc;
		
		