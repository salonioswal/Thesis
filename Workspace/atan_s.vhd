library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity atan2_s is
  generic (
    g_size : integer := 16
    );
  port (
    x : in signed(g_size-1 downto 0);
    y : in signed(g_size-1 downto 0);
    output : out signed(g_size-1 downto 0)
    );
end atan2_s;

architecture arch of atan2_s is
  
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
      out_comp : in std_logic_vector(1 downto 0);
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
  
  signal out_comp0 : std_logic;
  signal out_comp1 : std_logic;

  signal out_comp : std_logic_vector(1 downto 0);

  signal coeff45 : unsigned(g_size-1 downto 0);
  signal coeff90 : unsigned(g_size-1 downto 0);


  signal y_val45 : unsigned(2*g_size-1 downto 0);
  signal y_val90 : unsigned(2*g_size-1 downto 0);


  signal abs_x : unsigned(g_size-1 downto 0);
  signal abs_y : unsigned(g_size-1 downto 0);   
  
begin
  
  abs_modx : abs_mod
    generic map (g_size => g_size)
    port map (input => x, output => abs_x);

  abs_mody : abs_mod
    generic map (g_size => g_size)
    port map (input => y, output => abs_y);

  coeff45 <=  to_unsigned(2,g_size);
  coeff90 <= to_unsigned(3,g_size);

  
  sign_x <= x(g_size-1);
  sign_y <= y(g_size-1);

  
  multi45: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff45, output => y_val45);
  multi90: multiplier generic map (g_size => g_size) port map (in1 => abs_x, in2 => coeff90, output => y_val90);



  comp45: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val45, output => out_comp0);
  comp90: comparator generic map (g_size => g_size) port map (in1 => abs_y, in2 => y_val90, output => out_comp1);

  out_comp <= out_comp1&out_comp0;

  dec_module : decoder
    generic map (g_size => g_size)
    port map (sign_x => sign_x, sign_y => sign_y, out_comp => out_comp, output => output);
    
end arch;

