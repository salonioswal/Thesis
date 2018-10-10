library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.my_package.all;
use work.all;

entity FSM_inv is
  port(clock          : in  std_logic;
       reset          : in  std_logic;
       start          : in  std_logic;
       row_counter    : out unsigned(ptr_width_inv-1 downto 0);
       column_counter : out unsigned(ptr_width_inv-1 downto 0);
       mac_en         : out std_logic;
       mac_reset      : out std_logic;
       wr_ptr_reg     : out unsigned(ptr_width_inv-1 downto 0);
       rd_ptr         : out unsigned(ptr_width_inv-1 downto 0);
       reset_reg      : out std_logic;
       store_ptr      : out unsigned(ptr_width_inv-1 downto 0);
       wr_en          : out std_logic;
       addr           : out unsigned(ptr_width_inv-1 downto 0);
       be_reset       : out std_logic;
       subtract_en    : out std_logic;
       divide_en      : out std_logic;
       store_en       : out std_logic;
       store_result   : out std_logic);
end FSM_inv;

architecture beh_FSM of FSM_inv is
  type FSM_state is (idle, reg_fill, basic_element, store, done);
  signal state               : FSM_state;
  signal next_state          : FSM_state;
  signal next_row_counter    : unsigned(ptr_width_inv-1 downto 0);
  signal next_column_counter : unsigned(ptr_width_inv-1 downto 0);
  signal next_mac_en         : std_logic;
  signal next_mac_reset      : std_logic;
  signal next_wr_ptr_reg     : unsigned(ptr_width_inv-1 downto 0);
  signal next_rd_ptr         : unsigned(ptr_width_inv-1 downto 0);
  signal next_reset_reg      : std_logic;
  signal next_wr_en          : std_logic;
  signal next_addr           : unsigned(ptr_width_inv-1 downto 0);
  signal next_be_reset       : std_logic;
  signal next_subtract_en    : std_logic;
  signal next_divide_en      : std_logic;
  signal next_store_en       : std_logic;
  signal count               : unsigned(2 downto 0);
  signal next_count          : unsigned(2 downto 0);
  signal next_store_result   : std_logic;
  --signal rf_counter             :unsigned(ptr_width_inv-1 downto 0);
  --signal next_rf_counter        :unsigned(ptr_width_inv-1 downto 0);
  signal next_store_ptr      : unsigned(ptr_width_inv-1 downto 0);
begin
  clocked_process : process(clock, reset)
  begin
    if(reset = '0') then
      row_counter    <= (others => '0');
      column_counter <= (others => '0');
      mac_en         <= '0';
      mac_reset      <= '0';
      wr_ptr_reg     <= (others => '0');
      rd_ptr         <= (others => '0');
      reset_reg      <= '0';
      state          <= idle;
      wr_en          <= '0';
      addr           <= (others => '0');
      be_reset       <= '0';
      store_result   <= '0';
      --rf_counter<=(others=>'0');
      store_ptr      <= (others => '0');
      divide_en      <= '0';
      subtract_en    <= '0';
      store_en       <= '0';
      count          <= (others => '0');


    elsif(rising_edge(clock)) then
      state          <= next_state;
      row_counter    <= next_row_counter;
      column_counter <= next_column_counter;
      mac_en         <= next_mac_en;
      mac_reset      <= next_mac_reset;
      wr_ptr_reg     <= next_wr_ptr_reg;
      rd_ptr         <= next_rd_ptr;
      reset_reg      <= next_reset_reg;
      wr_en          <= next_wr_en;
      addr           <= next_addr;
      be_reset       <= next_be_reset;
      store_result   <= next_store_result;
      --rf_counter<=next_rf_counter;            
      store_ptr      <= next_store_ptr;
      divide_en      <= next_divide_en;
      subtract_en    <= next_subtract_en;
      store_en       <= next_store_en;
      count          <= next_count;
    end if;
  end process;

  FSM_process : process(all)
  begin
    --default values
    --next_rf_counter<=rf_counter;
    next_store_result   <= store_result;
    next_state          <= state;
    next_row_counter    <= row_counter;
    next_column_counter <= column_counter;
    next_mac_en         <= mac_en;
    next_mac_reset      <= mac_reset;
    next_wr_ptr_reg     <= wr_ptr_reg;
    next_rd_ptr         <= rd_ptr;
    next_reset_reg      <= reset_reg;
    next_wr_en          <= wr_en;
    next_store_ptr      <= store_ptr;
    next_addr           <= addr;
    next_be_reset       <= be_reset;
    next_divide_en      <= divide_en;
    next_subtract_en    <= subtract_en;
    next_store_en       <= store_en;
    next_count          <= count;
    case state is
      when idle =>
        --next_rf_counter<=(others=>'0');
        if(start = '1') then
          next_state     <= reg_fill;
          next_reset_reg <= '1';
          next_wr_en     <= '1';

        end if;

      when reg_fill =>

        next_count      <= (others => '0');
        next_store_en   <= '0';
        next_wr_en      <= '1';
        next_be_reset   <= '1';
        next_mac_reset  <= '0';
        next_reset_reg  <= '1';
        next_wr_ptr_reg <= wr_ptr_reg+1;
        --next_rf_counter<=rf_counter+1;
        if(to_integer(wr_ptr_reg) = to_integer(row_counter)) then
          next_wr_en <= '0';
        end if;

        if(wr_en = '0') then
          next_wr_en      <= '0';
          next_state      <= basic_element;
          next_wr_ptr_reg <= (others => '0');
          next_mac_reset  <= '1';
          next_mac_en     <= '1';
          next_addr       <= (others => '0');
        end if;

      when basic_element =>
        next_divide_en <= '0';
        next_be_reset  <= '1';
        next_mac_reset <= '1';
        next_wr_en     <= '0';
        --rf_counter<=(others=>'0');
        next_reset_reg <= '1';
        next_rd_ptr    <= rd_ptr+1;
        next_addr      <= addr+1;

        if(to_integer(rd_ptr) = (rows-1)) then
          next_rd_ptr      <= (others => '0');
          next_addr        <= (others => '0');
          next_subtract_en <= '1';
          next_mac_en      <= '0';
        end if;
        if(subtract_en = '1') then
          next_divide_en   <= '1';
          next_subtract_en <= '0';
          next_mac_en      <= '0';
        end if;
        if(divide_en = '1') then
          next_count <= count+1;
          if(count = 2) then
            next_store_en  <= '1';
            next_divide_en <= '0';
            next_count     <= count+1;
            next_mac_en    <= '0';
          end if;
        end if;
        if(count = 3) then
          next_store_en <= '0';

          if(to_integer(row_counter) = rows-1) then
            next_count        <= (others => '0');
            next_state        <= store;
            next_store_ptr    <= (others => '0');
            next_store_result <= '1';
            next_mac_reset    <= '1';
            next_be_reset     <= '1';
            next_mac_en       <= '0';
            next_reset_reg    <= '0';
            next_row_counter  <= (others => '0');
            next_rd_ptr       <= (others => '0');
          else
            next_count       <= (others => '0');
            next_row_counter <= row_counter+1;
            next_state       <= reg_fill;
            next_wr_ptr_reg  <= (others => '0');
            next_mac_en      <= '0';
            next_reset_reg   <= '1';
            next_mac_reset   <= '1';
            next_be_reset    <= '1';
            next_wr_en       <= '1';
            next_rd_ptr      <= (others => '0');
          end if;
        end if;



      when store =>
        next_divide_en    <= '0';
        next_store_result <= '1';
        next_store_ptr    <= store_ptr+1;
        next_mac_en       <= '0';
        next_be_reset     <= '1';
        next_mac_reset    <= '0';
        next_wr_ptr_reg   <= (others => '0');
        if(to_integer(store_ptr) = rows-1) then
          next_store_ptr      <= (others => '0');
          next_state          <= reg_fill;
          next_wr_en          <= '1';
          next_reset_reg      <= '1';
          next_be_reset       <= '0';
          next_store_result   <= '0';
          next_column_counter <= column_counter+1;
          if(to_integer(column_counter) = rows-1) then
            next_state          <= done;
            next_store_result   <= '0';
            next_mac_en         <= '0';
            next_column_counter <= (others => '0');
            next_count          <= (others => '0');
            next_rd_ptr         <= (others => '0');
          end if;
        end if;


      when done =>
        next_state    <= idle;
        next_store_en <= '0';

    end case;
  end process;

end beh_FSM;











