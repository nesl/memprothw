library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

use WORK.AVRuCPackage.all;

entity programLoader is

  port (

    loadingData    : out std_logic_vector(15 downto 0);
    loadingAddress : out std_logic_vector(15 downto 0);
    procData       : out std_logic_vector(15 downto 0);
    procAddress    : out std_logic_vector(15 downto 0);
    loadingWrEn    : out std_logic;

    -- General Ports
    clock : in std_logic;
    reset : in std_logic;

    -- avr specific ports
    porta : inout std_logic_vector(7 downto 0);
    portb : inout std_logic_vector(7 downto 0);
    -- uart
    rxd   : in    std_logic;
    txd   : out   std_logic;
    -- External interrupt inputs
    nINT0 : in    std_logic;
    nINT1 : in    std_logic;
    nINT2 : in    std_logic;
    nINT3 : in    std_logic;
    INT4  : in    std_logic;
    INT5  : in    std_logic;
    INT6  : in    std_logic;
    INT7  : in    std_logic
    );

end programLoader;

architecture beh of programLoader is

  component top_avr_core_sim
    is port (

      -- Temp signals
      tempPromAddress : out   std_logic_vector(15 downto 0);
      tempPromData    : out   std_logic_vector(15 downto 0);
      -- avr_core
      cp2             : in    std_logic;
      ireset          : in    std_logic;
      porta           : inout std_logic_vector(7 downto 0);
      portb           : inout std_logic_vector(7 downto 0);
      -- UART 
      rxd             : in    std_logic;
      txd             : out   std_logic;
      -- External interrupt inputs
      nINT0           : in    std_logic;
      nINT1           : in    std_logic;
      nINT2           : in    std_logic;
      nINT3           : in    std_logic;
      INT4            : in    std_logic;
      INT5            : in    std_logic;
      INT6            : in    std_logic;
      INT7            : in    std_logic;
      -- Loader specific ports
      promAddressIn   : in    std_logic_vector( 15 downto 0);
      promDataIn      : in    std_logic_vector(15 downto 0);
      promWrEn        : in    std_logic
      );
  end component;

  component programToLoad
    is port (
      address_in : in  std_logic_vector (15 downto 0);
      data_out   : out std_logic_vector (15 downto 0)
      );
  end component;

  signal sgData     : std_logic_vector(15 downto 0);
  signal sgAddress  : std_logic_vector(15 downto 0);
  signal sgWrEn     : std_logic;
  signal sgAvrReset : std_logic;

begin  -- beh

  loadingAddress <= sgAddress;
  loadingData    <= sgData;
  loadingWrEn    <= sgWrEn;

  avr_core : component top_avr_core_sim port map (
    -- temp signals
    tempPromData    => procData,
    tempPromAddress => procAddress,
    -- avr_core
    cp2             => clock,
    ireset          => sgAvrReset,
    porta           => porta,
    portb           => portb,
    -- UART 
    rxd             => rxd,
    txd             => txd,
    -- External interrupt inputs
    nINT0           => nINT0,
    nINT1           => nINT1,
    nINT2           => nINT2,
    nINT3           => nINT3,
    INT4            => INT4,
    INT5            => INT5,
    INT6            => INT6,
    INT7            => INT7,
    -- Loader specific ports
    promAddressIn   => sgAddress,
    promDataIn      => sgData,
    promWrEn        => sgWrEn
    );

  loader : component programToLoad port map (
    address_in => sgAddress,
    data_out   => sgData
    );

  clockProcess : process (clock, reset)
  begin  -- process on clock or reset
    -- if initial reset, reset the entire system
    if (reset = '0') then
      sgAddress      <= "0000000000000000";
      sgWrEn         <= '1';
      sgAvrReset     <= '0';
      counter        <= '0';
    else
      if (clock = '1' and clock'event) then
        -- if we are done loading the PROM
        if (sgAddress = "1111111111111111") then
          -- Stop writing and reset the avr_core
          sgWrEn     <= '0';
          sgAvrReset <= '1';
        else
          -- Else keep writing and incrementing the PROM address
          sgWrEn     <= '1';
          sgAvrReset <= '0';
          sgAddress  <= sgAddress + 1;
        end if;
      end if;
    end if;
  end process clockProcess;

end beh;
