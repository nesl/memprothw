library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_RAM is

end tb_RAM;

architecture test_bench of tb_RAM is

  signal tbAddress : std_logic_vector(15 downto 0);
  signal tbClock   : std_logic;
  signal tbDataIn  : std_logic_vector(7 downto 0);
  signal tbDataOut : std_logic_vector(7 downto 0);
  signal tbWrEn    : std_logic;

  component RAM
    port (
      address : in  std_logic_vector (15 downto 0);
      clock   : in  std_logic;
      dataIn  : in  std_logic_vector (7 downto 0);
      dataOut : out std_logic_vector (7 downto 0);
      wrEn    : in  std_logic);

  end component;

begin  -- test_bench

  RAM1: RAM
    port map (
      address => tbAddress,
      clock => tbClock,
      dataIn => tbDataIn,
      dataOut => tbDataOut,
      wrEn => tbWrEn);

  clock_process : process
  begin
    tbClock <= '1', '0' after 50 ns;
    wait for 100 ns;
  end process clock_process;
  
  test_stimuli : process
  begin

    tbAddress <= "0000000000000000", "0000000000000001" after 200 ns;

    tbDataIn <= "00000000", "00000001" after 100 ns, "00000000" after 200 ns;
    tbWrEn <= '0', '1' after 100 ns, '0' after 200 ns;

    wait;

  end process test_stimuli;
  
end test_bench;

configuration cfg_tb_RAM of tb_RAM is

  for test_bench
    for RAM1: RAM
      use entity work.RAM(Behavioral);
    end for;    
  end for;

end cfg_tb_RAM;
