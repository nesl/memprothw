library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_programLoader is

end tb_programLoader;

architecture test_bench of tb_programLoader is

  signal tbAddressDO : std_logic_vector(15 downto 0);
  signal tbAddressDI : std_logic_vector(15 downto 0);
  signal tbClock   : std_logic;
  signal tbDataIn  : std_logic_vector(15 downto 0);
  signal tbDataOut : std_logic_vector(15 downto 0);
  signal tbWrEn    : std_logic;
  signal tbDataTest : std_logic_vector ( 15 downto 0);

  component programLoader
    port (
    addressDO : in  std_logic_vector (15 downto 0);  --address for data out
    addressDI : in  std_logic_vector (15 downto 0);  --address for data in
    clock     : in  std_logic;          --clock signal
    dataIn    : in  std_logic_vector (15 downto 0);  --port for data in
    wrEn      : in  std_logic;          --port for write enable
    dataOut   : out std_logic_vector (15 downto 0);  --port for data out
    dataTest : out std_logic_vector ( 15 downto 0)
    );

  end component;

begin  -- test_bench

  programLoader1: programLoader
    port map (
      addressDI => tbAddressDI,
      addressDO => tbAddressDO,
      clock => tbClock,
      dataIn => tbDataIn,
      dataOut => tbDataOut,
      wrEn => tbWrEn,
      dataTest => tbDataTest
      );

  clock_process : process
  begin
    tbClock <= '1', '0' after 50 ns;
    wait for 100 ns;
  end process clock_process;
  
  test_stimuli : process
  begin

    tbAddressDI <= "0000000000000000",
                   "0000000000000001" after 200 ns;
    tbAddressDO <= "0000000000000000";

    tbDataIn <= "0000000000000001";

    tbWrEn <= '0', '1' after 90 ns, '0' after 200 ns;

    wait;

  end process test_stimuli;
  
end test_bench;

configuration cfg_tb_programLoader of tb_programLoader is

  for test_bench
    for programLoader1:programLoader
      use entity work.PROM(Behavioral);
    end for;    
  end for;

end cfg_tb_programLoader;
