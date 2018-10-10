library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity atan2 is
  generic (
    g_size : integer := 16
    );
  port (
    x : in signed(g_size-1 downto 0);
    y : in signed(g_size-1 downto 0);
    output : out signed(g_size-1 downto 0)
    );
end atan2;

architecture arch of atan2 is
  
  component abs_mod
    generic (
      g_size : integer := 16
      );
    port (
      input  : in  signed(g_size-1 downto 0);
      output : out unsigned(g_size-1 downto 0)
      );
  end component;

  component decoder
    generic (
      g_size : integer := 16
      );
    port (
      sign_x   : in std_logic;
      sign_y   : in std_logic;
      out_comp : in std_logic_vector(7 downto 0);
      output : out signed(g_size-1 downto 0)
      );        
  end component;  

  component comparator
    generic (
      g_size : integer := 16
      );
    port (
      in1   : in unsigned(g_size-1 downto 0);
      in2   : in unsigned(2*g_size-1 downto 0); 
      output : out std_logic
      );        
  end component;

  component multiplier
    generic (
      g_size : integer := 16
      );
    port (
      in1   : in unsigned(g_size-1 downto 0);
      in2   : in unsigned(g_size-1 downto 0);
      output : out unsigned(2*g_size-1 downto 0)
      );        
  end component;  


  signal sign_x : std_logic;
  signal sign_y : std_logic;
  
  signal out_comp1 : std_logic;
  signal out_comp2 : std_logic;
  signal out_comp3 : std_logic;
  signal out_comp4 : std_logic;
  signal out_comp5 : std_logic;
  signal out_comp6 : std_logic;
  signal out_comp7 : std_logic;
  signal out_comp0 : std_logic;
  
  signal out_comp : std_logic_vector(7 downto 0);

  signal coeff10 : unsigned(g_size-1 downto 0);
  signal coeff20 : unsigned(g_size-1 downto 0);
  signal coeff30 : unsigned(g_size-1 downto 0);
  signal coeff40 : unsigned(g_size-1 downto 0);
  signal coeff50 : unsigned(g_size-1 downto 0);
  signal coeff60 : unsigned(g_size-1 downto 0);
  signal coeff70 : unsigned(g_size-1 downto 0);
  signal coeff80 : unsigned(g_size-1 downto 0);

  signal y_val10 : unsigned(2*g_size-1 downto 0);
  signal y_val20 : unsigned(2*g_size-1 downto 0);
  signal y_val30 : unsigned(2*g_size-1 downto 0);
  signal y_val40 : unsigned(2*g_size-1 downto 0);
  signal y_val50 : unsigned(2*g_size-1 downto 0);
  signal y_val60 : unsigned(2*g_size-1 downto 0);
  signal y_val70 : unsigned(2*g_size-1 downto 0);
  signal y_val80 : unsigned(2*g_size-1 downto 0);

  signal abs_x : unsigned(g_size-1 downto 0);
  signal abs_y : unsigned(g_size-1 downto 0);   
  
begin
  
  abs_modx : abs_mod
    generic map (g_size => g_size)
    port map (input => x, output => abs_x);

  abs_mody : abs_mod
    generic map (g_size => g_size)
    port map (input => y, output => abs_y);

  coeff10 <=   to_unsigned(722,g_size);
  coeff20 <=  to_unsigned(1490,g_size);
  coeff30 <=  to_unsigned(2364,g_size);
  coeff40 <=  to_unsigned(3436,g_size);
  coeff50 <=  to_unsigned(4881,g_size);
  coeff60 <=  to_unsigned(7094,g_size);
  coeff70 <= to_unsigned(11253,g_size);
  coeff80 <= to_unsigned(23229,g_size);

  
  sign_x <= x(g_size-1);
  sign_y <= y(g_size-1);

  
  multi10: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff10, output => y_val10);
  multi20: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff20, output => y_val20);
  multi30: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff30, output => y_val30);
  multi40: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff40, output => y_val40);
  multi50: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff50, output => y_val50);
  multi60: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff60, output => y_val60);
  multi70: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff70, output => y_val70);
  multi80: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff80, output => y_val80);


  comp10: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val10, output => out_comp0);
  comp20: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val20, output => out_comp1);
  comp30: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val30, output => out_comp2);
  comp40: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val40, output => out_comp3);
  comp50: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val50, output => out_comp4);
  comp60: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val60, output => out_comp5);
  comp70: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val70, output => out_comp6);
  comp80: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val80, output => out_comp7);

  out_comp <= out_comp7&out_comp6&out_comp5&out_comp4&out_comp3&out_comp2&out_comp1&out_comp0;

  dec_module : decoder
    generic map (g_size => g_size)
    port map (sign_x => sign_x, sign_y => sign_y, out_comp => out_comp, output => output);
    
end arch;
