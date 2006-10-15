library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_PROM is

end tb_PROM;

architecture test_bench of tb_PROM is

  signal tbAddressDO : std_logic_vector(15 downto 0);
  signal tbAddressDI : std_logic_vector(15 downto 0);
  signal tbClock   : std_logic;
  signal tbDataIn  : std_logic_vector(15 downto 0);
  signal tbDataOut : std_logic_vector(15 downto 0);
  signal tbWrEn    : std_logic;

  component PROM
    port (
    addressDO : in  std_logic_vector (15 downto 0);  --address for data out
    addressDI : in  std_logic_vector (15 downto 0);  --address for data in
    clock     : in  std_logic;          --clock signal
    dataIn    : in  std_logic_vector (15 downto 0);  --port for data in
    wrEn      : in  std_logic;          --port for write enable
    dataOut   : out std_logic_vector (15 downto 0)  --port for data out
    );

  end component;

begin  -- test_bench

  PROM1: PROM
    port map (
      addressDI => tbAddressDI,
      addressDO => tbAddressDO,
      clock => tbClock,
      dataIn => tbDataIn,
      dataOut => tbDataOut,
      wrEn => tbWrEn
      );

  clock_process : process
  begin
    tbClock <= '1', '0' after 50 ns;
    wait for 100 ns;
  end process clock_process;
  
  test_stimuli : process
  begin

    tbAddressDI <= "0000000000000000",
                   "0000000000000001" after 200 ns,
                   "0000000000000010" after 300 ns,
                   "0000000000000011" after 400 ns,
                   "0000000000000100" after 500 ns,
                   "0000000000000101" after 600 ns;
    tbAddressDO <= "0000000000000000",
                   "0000000000000001" after 1200 ns,
                   "0000000000000010" after 1300 ns,
                   "0000000000000011" after 1400 ns,
                   "0000000000000100" after 1500 ns,
                   "0000000000000101" after 1600 ns;



    tbDataIn <= "0000000000000001",
                   "0000000000000010" after 200 ns,
                   "0000000000000011" after 300 ns,
                   "0000000000000100" after 400 ns,
                   "0000000000000101" after 500 ns,
                   "0000000000000110" after 600 ns;

    tbWrEn <= '1', '0' after 700 ns;

    wait;

  end process test_stimuli;
  
end test_bench;

configuration cfg_tb_PROM of tb_PROM is

  for test_bench
    for PROM1:PROM
      use entity work.PROM(Behavioral);
    end for;    
  end for;

end cfg_tb_PROM;
