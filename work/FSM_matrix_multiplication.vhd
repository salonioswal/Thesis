library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all;
use work.all;

entity FSM_MM is
  port(start      : in  std_logic;
       clock      : in  std_logic;
       reset      : in  std_logic;
       mac_en     : out std_logic;
       mac_reset  : out std_logic;
       rd_addr_RF : out unsigned(ptr_width_inv-1 downto 0);
       wr_addr_RF : out unsigned(ptr_width_inv-1 downto 0);
       wr_en_A    : out std_logic;
       wr_en_B_1  : out std_logic;
       wr_en_B_2  : out std_logic;
       mux_B_cal  : out std_logic;
       store_r    : out std_logic

       );
end FSM_MM;

architecture arch_FSM_MM of FSM_MM is
  type FSM_state is (idle, reg_fill, cal_and_fill, store, done);
  signal state               : FSM_state;
  signal next_state          : FSM_state;
  signal count_op            : unsigned(ptr_width_inv-1 downto 0);
  signal column_counter      : unsigned(ptr_width_inv-1 downto 0);
  signal row_counter         : unsigned(ptr_width_inv-1 downto 0);
  signal next_count_op       : unsigned(ptr_width_inv-1 downto 0);
  signal next_column_counter : unsigned(ptr_width_inv-1 downto 0);
  signal next_row_counter    : unsigned(ptr_width_inv-1 downto 0);
  signal next_mac_en         : std_logic;
  signal next_mac_reset      : std_logic;
  signal next_rd_addr_RF     : unsigned(ptr_width_inv-1 downto 0);
  signal next_wr_addr_RF     : unsigned(ptr_width_inv-1 downto 0);
  signal next_wr_en_A        : std_logic;
  signal next_wr_en_B_1      : std_logic;
  signal next_wr_en_B_2      : std_logic;
  signal next_mux_B_cal      : std_logic;
  signal next_store_r        : std_logic;

begin
  clocked_process : process(clock, reset)
  begin
    if(reset = '0') then
      count_op       <= (others => '0');
      column_counter <= (others => '0');
      row_counter    <= (others => '0');
      mac_en         <= '0';
      mac_reset      <= '0';
      rd_addr_RF     <= (others => '0');
      wr_addr_RF     <= (others => '0');
      wr_en_A        <= '0';
      wr_en_B_1      <= '0';
      wr_en_B_2      <= '0';
      mux_B_cal      <= '0';
      store_r        <= '0';
    elsif(rising_edge(clock)) then
      state          <= IDLE;
      count_op       <= next_count_op;
      column_counter <= next_column_counter;
      row_counter    <= next_row_counter;
      mac_en         <= next_mac_en;
      mac_reset      <= next_mac_reset;
      rd_addr_RF     <= next_rd_addr_RF;
      wr_addr_RF     <= next_wr_addr_RF;
      wr_en_A        <= next_wr_en_A;
      wr_en_B_1      <= next_wr_en_B_1;
      wr_en_B_2      <= next_wr_en_B_2;
      mux_B_cal      <= next_mux_B_cal;
      store_r        <= next_store_r;
    end if;
  end process;


  FSM_process : process(all)
  begin
    --default values
    next_count_op       <= count_op;
    next_column_counter <= column_counter;
    next_row_counter    <= row_counter;
    next_mac_en         <= mac_en;
    next_mac_reset      <= mac_reset;
    next_rd_addr_RF     <= rd_addr_RF;
    next_wr_addr_RF     <= wr_addr_RF;
    next_wr_en_A        <= wr_en_A;
    next_wr_en_B_1      <= wr_en_B_1;
    next_wr_en_B_2      <= wr_en_B_2;
    next_mux_B_cal      <= mux_B_cal;
    next_store_r        <= store_r;
    case state is
      when IDLE =>
        if(start = '1') then
          next_state     <= reg_fill;
          next_wr_en_A   <= '1';
          next_wr_en_B_1 <= '1';
        end if;

      when reg_fill =>
        next_wr_addr_RF <= wr_addr_RF+1;
        next_count_op   <= count_op+1;
        next_wr_en_A    <= '1';
        next_wr_en_B_1  <= '1';
        if(count_op = rows-1) then
          next_state     <= cal_and_fill;
          next_wr_en_B_2 <= '1';
          next_wr_en_B_1 <= '0';
          next_wr_en_A   <= '0';
          next_mac_en    <= '1';
          next_mac_reset <= '1';
          next_mux_B_cal <= '1';
          next_count_op   <= (others => '0');
        end if;

      when cal_and_fill =>
        next_rd_addr_RF <= rd_addr_RF+1;
        next_wr_addr_RF <= wr_addr_RF+1;
        next_count_op   <= count_op+1;
        if(count_op = rows-1) then
          next_state      <= store;
          next_rd_addr_RF <= (others => '0');
          next_wr_addr_RF <= (others => '0');
          next_count_op   <= (others => '0');
          next_mac_en     <= '0';
          next_store_r    <= '1';
          if(column_counter(0) = '0') then
            next_wr_en_B_2 <= '0';
          else
            next_wr_en_B_1 <= '0';
          end if;
        end if;

      when store =>
        next_column_counter <= column_counter+1;
        next_store_r        <= '0';
        next_count_op       <= count_op+1;
        next_mac_reset      <= '0';
        if(count_op = 1) then
			next_count_op <= (others => '0');
          if(column_counter = rows-1) then
            next_column_counter <= (others => '0');
            next_row_counter    <= row_counter+2;
            next_state          <= reg_fill;
          else
            next_state     <= cal_and_fill;
            next_mac_reset <= '1';
            next_mac_en    <= '1';
          end if;

          if(column_counter(0) = '0') then
            next_wr_en_B_1 <= '1';
            next_mux_B_cal <= '0';
          else
            next_wr_en_B_2 <= '1';
            next_mux_B_cal <= '1';
          end if;
          
          if(row_counter = rows-1) then
            next_state <= done;
          end if;
        end if;

      when done =>
        next_state <= IDLE;

end case;
    end process;
  end arch_FSM_MM;


