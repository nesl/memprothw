library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_timer is

end tb_timer;

architecture test_bench of tb_timer is

  -- Avr control
  signal tb_ireset   : std_logic;
  signal tb_cp2      : std_logic;
  signal tb_adr      : std_logic_vector(5 downto 0);
  signal tb_dbus_in  : std_logic_vector(7 downto 0);
  signal tb_dbus_out : std_logic_vector(7 downto 0);
  signal tb_iore     : std_logic;
  signal tb_iowe     : std_logic;
  signal tb_out_en   : std_logic;

  -- IRQ
  signal tb_TC0OvfIRQ     : std_logic;
  signal tb_TC0OvfIRQ_Ack : std_logic;
  signal tb_TC0CmpIRQ     : std_logic;
  signal tb_TC0CmpIRQ_Ack : std_logic;

  component timer
    port (
      -- AVR Control
      ireset   : in  std_logic;
      cp2      : in  std_logic;
      adr      : in  std_logic_vector(5 downto 0);
      dbus_in  : in  std_logic_vector(7 downto 0);
      dbus_out : out std_logic_vector(7 downto 0);
      iore     : in  std_logic;
      iowe     : in  std_logic;
      out_en   : out std_logic;

      --IRQ
      TC0OvfIRQ     : out std_logic;
      TC0OvfIRQ_Ack : in  std_logic;
      TC0CmpIRQ     : out std_logic;
      TC0CmpIRQ_Ack : in  std_logic

      );

  end component;

begin  -- test_bench

  timer1 : timer
    port map (
      -- Avr control
      ireset => tb_ireset,
      cp2 => tb_cp2,
      adr => tb_adr,
      dbus_in => tb_dbus_in,
      dbus_out => tb_dbus_out,
      iore => tb_iore,
      iowe => tb_iowe,
      out_en => tb_out_en,

      -- IRQ
      TC0OvfIRQ => tb_TC0OvfIRQ,
      TC0OvfIRQ_Ack => tb_TC0OvfIRQ_Ack,
      TC0CmpIRQ => tb_TC0CmpIRQ,
      TC0CmpIRQ_Ack => tb_TC0CmpIRQ_Ack
      );

  clock_process : process
  begin
    tb_cp2 <= '1', '0' after 50 ns;
    wait for 100 ns;
  end process clock_process;

  test_stimuli : process
  begin


    wait;

  end process test_stimuli;

end test_bench;

configuration cfg_tb_timer of tb_timer is

  for test_bench
    for timer1 : timer
      use entity work.timer(Behavioral);
    end for;
  end for;

end cfg_tb_timer;
