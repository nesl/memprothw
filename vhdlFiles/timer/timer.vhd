--**********************************************************************************************
-- Timers/Counters Block Peripheral for the AVR Core
-- Version 0.5 
-- Modified 02.01.2003
-- Synchronizer for EXT1/EXT2/Tosc1 inputs was added
-- Designed by Ruslan Lepetenok
--**********************************************************************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use WORK.AVRuCPackage.all;

entity timer is port(
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

end timer;

architecture rtl of timer is

-- Copies of the external signals

-- Registers
  signal TCCR0  : std_logic_vector(7 downto 0) := (others => '0');
  signal ASSR   : std_logic_vector(7 downto 0) := (others => '0');  -- Asynchronous status register (for TCNT0)
  signal TIMSK  : std_logic_vector(7 downto 0) := (others => '0');
  signal TIFR   : std_logic_vector(7 downto 0) := (others => '0');
  signal TCNT0  : std_logic_vector(7 downto 0) := (others => '0');
  signal OCR0   : std_logic_vector(7 downto 0) := (others => '0');

  signal TCCR0_Sel  : std_logic := '0';
  signal ASSR_Sel   : std_logic := '0';
  signal TIMSK_Sel  : std_logic := '0';
  signal TIFR_Sel   : std_logic := '0';
  signal TCNT0_Sel  : std_logic := '0';
  signal OCR0_Sel   : std_logic := '0';

  -- TCCR0 Bits
  alias CS00  : std_logic is TCCR0(0);
  alias CS01  : std_logic is TCCR0(1);
  alias CS02  : std_logic is TCCR0(2);
  alias CTC0  : std_logic is TCCR0(3);
  alias COM00 : std_logic is TCCR0(4);
  alias COM01 : std_logic is TCCR0(5);
  alias PWM0  : std_logic is TCCR0(6);

-- ASSR bits
  alias TCR0UB : std_logic is ASSR(0);
  alias OCR0UB : std_logic is ASSR(1);
  alias TCN0UB : std_logic is ASSR(2);
  alias AS0    : std_logic is ASSR(3);

-- TIMSK bits
  alias TOIE0  : std_logic is TIMSK(0);
  alias OCIE0  : std_logic is TIMSK(1);
  alias TOIE1  : std_logic is TIMSK(2);
  alias OCIE1B : std_logic is TIMSK(3);
  alias OCIE1A : std_logic is TIMSK(4);
  alias TICIE1 : std_logic is TIMSK(5);
  alias TOIE2  : std_logic is TIMSK(6);
  alias OCIE2  : std_logic is TIMSK(7);

-- TIFR bits
  alias TOV0  : std_logic is TIFR(0);
  alias OCF0  : std_logic is TIFR(1);
  alias TOV1  : std_logic is TIFR(2);
  alias OCF1B : std_logic is TIFR(3);
  alias OCF1A : std_logic is TIFR(4);
  alias ICF1  : std_logic is TIFR(5);
  alias TOV2  : std_logic is TIFR(6);
  alias OCF2  : std_logic is TIFR(7);

-- Risign/falling edge detectors
  signal EXT1Latched : std_logic := '0';
  signal EXT2Latched : std_logic := '0';

-- Prescalers outputs
  signal TCNT0_En : std_logic := '0';   -- Output of the prescaler 0

-- Prescaler0 signals
  signal PCK0     : std_logic := '0';
  signal PCK08    : std_logic := '0';
  signal PCK032   : std_logic := '0';
  signal PCK064   : std_logic := '0';
  signal PCK0128  : std_logic := '0';
  signal PCK0256  : std_logic := '0';
  signal PCK01024 : std_logic := '0';

  signal Tosc1RE      : std_logic                    := '0';  -- Rising edge detector for TOSC1 input
  signal Tosc1Latched : std_logic                    := '0';
  signal Pre0Cnt      : std_logic_vector(9 downto 0) := (others => '0');  -- Prescaler 0 counter (10-bit)

  signal PCK0_Del : std_logic := '0';

-- Timer/counter 0 signals
  signal TCNT0_Tmp     : std_logic_vector(7 downto 0) := (others => '0');
  signal TCNT0_In      : std_logic_vector(7 downto 0) := (others => '0');
  signal TCNT0_Imm_In  : std_logic_vector(7 downto 0) := (others => '0');  -- Immediate data input 
  signal TCCR0_Tmp     : std_logic_vector(7 downto 0) := (others => '0');
  signal TCCR0_In      : std_logic_vector(7 downto 0) := (others => '0');
  signal OCR0_Tmp      : std_logic_vector(7 downto 0) := (others => '0');
  signal OCR0_In       : std_logic_vector(7 downto 0) := (others => '0');
  signal TCNT0_Cnt_Dir : std_logic                    := '0';  -- Count up(0) down (1)
  signal TCNT0_Clr     : std_logic                    := '0';  -- Clear (syncronously) TCNT0
  signal TCNT0_Ld_Imm  : std_logic                    := '0';  -- Load immediate value (syncronously) TCNT0
  signal TCNT0_Cmp_Out : std_logic                    := '0';  -- Output of the comparator
  signal TCNT0_Inc     : std_logic                    := '0';  -- Increment (not load) took place

-- For asynchronous mode only
  signal TCR0UB_Tmp : std_logic := '0';
  signal OCR0UB_Tmp : std_logic := '0';
  signal TCN0UB_Tmp : std_logic := '0';

  -- Synchronizer signals
  signal EXT1SA  : std_logic := '0';
  signal EXT1SB  : std_logic := '0';    -- Output of the synchronizer for EXT1
  signal EXT2SA  : std_logic := '0';
  signal EXT2SB  : std_logic := '0';    -- Output of the synchronizer for EXT1
  signal Tosc1SA : std_logic := '0';
  signal Tosc1SB : std_logic := '0';    -- Output of the synchronizer for Tosc1

begin

-- Prescaler 0 for TCNT0
  Tosc1_Rising_Edge_Detector : process(cp2, ireset)
  begin
    if ireset = '0' then                --Reset
      Tosc1RE      <= '0';
      Tosc1Latched <= '0';
    elsif cp2 = '1' and cp2'event then  -- Clock
      Tosc1RE      <= not Tosc1RE and (not Tosc1Latched and Tosc1SB);
      Tosc1Latched <= Tosc1SB;
    end if;
  end process;

  PCK0 <= Tosc1RE when AS0 = '1' else '1';

  Prescaler_0_Cnt : process(cp2, ireset)
  begin
    if ireset = '0' then                -- Reset
      Pre0Cnt   <= (others => '0');
    elsif cp2 = '1' and cp2'event then  -- Clock
      if PCK0 = '1' then                -- Clock enable
        Pre0Cnt <= Pre0Cnt+1;
      end if;
    end if;
  end process;

  Prescaler_0 : process(cp2, ireset)
  begin
    if ireset = '0' then                -- Reset
      PCK08    <= '0';
      PCK032   <= '0';
      PCK064   <= '0';
      PCK0128  <= '0';
      PCK0256  <= '0';
      PCK01024 <= '0';
      PCK0_Del <= '0';
    elsif cp2 = '1' and cp2'event then  -- Clock
      PCK08    <= (not PCK08 and(Pre0Cnt(0) and Pre0Cnt(1)and Pre0Cnt(2)) and PCK0_Del);
      PCK032   <= (not PCK032 and(Pre0Cnt(0) and Pre0Cnt(1) and Pre0Cnt(2) and Pre0Cnt(3) and Pre0Cnt(4)) and PCK0_Del);
      PCK064   <= (not PCK064 and(Pre0Cnt(0) and Pre0Cnt(1) and Pre0Cnt(2) and Pre0Cnt(3) and Pre0Cnt(4) and Pre0Cnt(5)) and PCK0_Del);
      PCK0128  <= (not PCK0128 and(Pre0Cnt(0) and Pre0Cnt(1) and Pre0Cnt(2) and Pre0Cnt(3) and Pre0Cnt(4) and Pre0Cnt(5) and Pre0Cnt(6) and PCK0_Del));
      PCK0256  <= (not PCK0256 and(Pre0Cnt(0) and Pre0Cnt(1) and Pre0Cnt(2) and Pre0Cnt(3) and Pre0Cnt(4) and Pre0Cnt(5) and Pre0Cnt(6) and Pre0Cnt(7)) and PCK0_Del);
      PCK01024 <= (not PCK01024 and(Pre0Cnt(0) and Pre0Cnt(1) and Pre0Cnt(2) and Pre0Cnt(3) and Pre0Cnt(4) and Pre0Cnt(5) and Pre0Cnt(6) and Pre0Cnt(7) and Pre0Cnt(8) and Pre0Cnt(9)) and PCK0_Del);
      PCK0_Del <= PCK0;
    end if;
  end process;


  TCNT0_En <= (PCK0 and not CS02 and not CS01 and CS00) or  -- PCK            "001" !!??
              (PCK08 and not CS02 and CS01 and not CS00) or  -- PCK/8            "010"
              (PCK032 and not CS02 and CS01 and CS00)or  -- PCK/32             "011"
              (PCK064 and CS02 and not CS01 and not CS00)or  -- PCK/64                   "100"
              (PCK0128 and CS02 and not CS01 and CS00)or  -- PCK/64                   "101"
              (PCK0256 and CS02 and CS01 and not CS00)or  -- PCK/256                  "110"
              (PCK01024 and CS02 and CS01 and CS00);  -- PCK/1024         "111"

--  -------------------------------------------------------------------------------------------
-- End of prescalers
-- -------------------------------------------------------------------------------------------

-- I/O address decoder
  TCCR0_Sel  <= '1' when adr = TCCR0_Address  else '0';
  ASSR_Sel   <= '1' when adr = ASSR_Address   else '0';
  TIMSK_Sel  <= '1' when adr = TIMSK_Address  else '0';
  TIFR_Sel   <= '1' when adr = TIFR_Address   else '0';
  TCNT0_Sel  <= '1' when adr = TCNT0_Address  else '0';
  OCR0_Sel   <= '1' when adr = OCR0_Address   else '0';

--  -------------------------------------------------------------------------------------------
-- Timer/Counter0
-- -------------------------------------------------------------------------------------------

-- Attention !!! This model only emulates the asynchronous mode of TCNT0.
-- Real TCNT0 of ATmega103/603 operates with two separate clock sources.

  Counter_0 : process(cp2, ireset)
  begin
    if ireset = '0' then                                     -- Reset
      TCNT0   <= (others => '0');
    elsif cp2 = '1' and cp2'event then                       -- Clock
      if (TCNT0_En or TCNT0_Clr or TCNT0_Ld_Imm) = '1' then  -- Clock enable
        TCNT0 <= TCNT0_In;
      end if;
    end if;
  end process;

  Counter_0_Inc : process(cp2, ireset)
  begin
    if ireset = '0' then                -- Reset
      TCNT0_Inc <= '0';
    elsif cp2 = '1' and cp2'event then  -- Clock
      TCNT0_Inc <= (not TCNT0_Inc and(TCNT0_En and not TCNT0_Ld_Imm))or(TCNT0_Inc and not(TCNT0_Ld_Imm));
    end if;
  end process;


  TCNT0_In <= TCNT0_Imm_In    when TCNT0_Ld_Imm = '1'  else  -- Immediate value (from dbus_in or TCNT0_Tmp)
              (others => '0') when TCNT0_Clr = '1'     else  -- Synchronous clear (for OCR)
              TCNT0-1         when TCNT0_Cnt_Dir = '1' else  -- Decrement (for PWM)
              TCNT0+1;                  -- Icrement (for counter and PWM)


  TCNT0_Imm_In  <= TCNT0_Tmp when (TCN0UB and not TCN0UB_Tmp and PCK0 and AS0) = '1' else dbus_in;
  TCNT0_Clr     <= TCNT0_Cmp_Out and CTC0 and not PWM0;
  TCNT0_Cmp_Out <= '1'       when (TCNT0 = OCR0 and OCR0/=x"00" and TCNT0_Inc = '1') else '0';
  TCNT0_Ld_Imm  <= (TCNT0_Sel and iowe and not AS0) or (TCN0UB and not TCN0UB_Tmp and PCK0 and AS0);


  TCCR0_Control : process(cp2, ireset)
  begin
    if ireset = '0' then                -- Reset
      TCNT0_Cnt_Dir <= '0';

      TCR0UB_Tmp <= '0';
      OCR0UB_Tmp <= '0';
      TCN0UB_Tmp <= '0';

      ASSR <= (others => '0');

    elsif cp2 = '1' and cp2'event then  -- Clock
      TCNT0_Cnt_Dir <= (not TCNT0_Cnt_Dir and(TCNT0(7) and TCNT0(6) and TCNT0(5) and TCNT0(4) and TCNT0(3) and TCNT0(2) and TCNT0(1) and not TCNT0(0) and TCNT0_En and PWM0)) or  -- 0xFE
                       (TCNT0_Cnt_Dir and not ((not TCNT0(7) and not TCNT0(6) and not TCNT0(5) and not TCNT0(4) and not TCNT0(3) and not TCNT0(2) and not TCNT0(1) and TCNT0(0)and TCNT0_En) or not PWM0));  -- 0x01

      TCR0UB_Tmp <= (not TCR0UB_Tmp and (TCCR0_Sel and iowe and AS0))or
                    (TCR0UB_Tmp and not PCK0);
      OCR0UB_Tmp <= (not OCR0UB_Tmp and (OCR0_Sel and iowe and AS0))or
                    (OCR0UB_Tmp and not PCK0);
      TCN0UB_Tmp <= (not TCN0UB_Tmp and (TCNT0_Sel and iowe and AS0))or
                    (TCN0UB_Tmp and not PCK0);

      TCR0UB <= (not TCR0UB and (TCCR0_Sel and iowe and AS0))or
                (TCR0UB and not (not TCR0UB_Tmp and PCK0));
      OCR0UB <= (not OCR0UB and (OCR0_Sel and iowe and AS0))or
                (OCR0UB and not (not OCR0UB_Tmp and PCK0));
      TCN0UB <= (not TCN0UB and (TCNT0_Sel and iowe and AS0))or
                (TCN0UB and not (not TCN0UB_Tmp and PCK0));

      AS0 <= (not AS0 and(ASSR_Sel and iowe and dbus_in(3)))or
             (AS0 and not(ASSR_Sel and iowe and not dbus_in(3)));

    end if;
  end process;


-- Temp registers of TCNT0

-- This register is used only when TCNT0 operates in the asynchronous mode
  TCNT0_Temp_Control : process(cp2, ireset)
  begin
    if ireset = '0' then                          -- Reset
      TCCR0_Tmp   <= (others => '0');
    elsif cp2 = '1' and cp2'event then            -- Clock
      if (TCCR0_Sel and iowe and AS0) = '1' then  -- Clock enable
        TCCR0_Tmp <= dbus_in;
      end if;
    end if;
  end process;

-- This register is used only when TCNT0 operates in the asynchronous mode
  TCNT0_Temp_CNT : process(cp2, ireset)
  begin
    if ireset = '0' then                          -- Reset
      TCNT0_Tmp   <= (others => '0');
    elsif cp2 = '1' and cp2'event then            -- Clock
      if (TCNT0_Sel and iowe and AS0) = '1' then  -- Clock enable
        TCNT0_Tmp <= dbus_in;
      end if;
    end if;
  end process;

  TCNT0_Temp_Compare : process(cp2, ireset)
  begin
    if ireset = '0' then                -- Reset
      OCR0_Tmp   <= (others => '0');
    elsif cp2 = '1' and cp2'event then  -- Clock
      if (OCR0_Sel and iowe ) = '1' then  -- Clock enable ??!! was "and (AS0 or PWM0)"
        OCR0_Tmp <= dbus_in;
      end if;
    end if;
  end process;

-- Main registers of TCNT0
  TCNT0_Control : process(cp2, ireset)
  begin
    if ireset = '0' then                -- Reset
      TCCR0               <= (others => '0');
    elsif cp2 = '1' and cp2'event then  -- Clock
      if ((TCCR0_Sel and iowe and not AS0)or
          (TCR0UB and not TCR0UB_Tmp and PCK0 and AS0)) = '1' then  -- Clock enable
        TCCR0(6 downto 0) <= TCCR0_In(6 downto 0);
      end if;
    end if;
  end process;

  TCCR0_In <= TCCR0_Tmp when (TCR0UB and not TCR0UB_Tmp and PCK0 and AS0) = '1' else dbus_in;

  TCNT0_Compare : process(cp2, ireset)
  begin
    if ireset = '0' then                -- Reset
      OCR0   <= (others => '0');
    elsif cp2 = '1' and cp2'event then  -- Clock
      if ((((OCR0_Sel and iowe and not AS0)or  -- Synchronous non PWM mode 
            (OCR0UB and not OCR0UB_Tmp and PCK0 and AS0))and not PWM0)or  -- Asynchronous non PWM mode
          (TCNT0(7) and TCNT0(6) and TCNT0(5) and TCNT0(4) and TCNT0(3) and TCNT0(2) and TCNT0(1) and TCNT0(0) and PWM0 and TCNT0_En))  -- Reload OCR0 with new value when TCNT0=0xFF (for PWM)
         = '1' then                     -- Clock enable ??!!
        OCR0 <= OCR0_In;
      end if;
    end if;
  end process;

-- OCR0 can be loaded from OCR0_Tmp (asynchronous non PWM mode, synchronous PWM mode ) or from dbus_in (synchronous non PWM mode only)
  OCR0_In <= OCR0_Tmp when ((TCR0UB and not TCR0UB_Tmp and PCK0 and AS0 and not PWM0)or
                            (TCNT0(7) and TCNT0(6) and TCNT0(5) and TCNT0(4) and TCNT0(3) and TCNT0(2) and TCNT0(1) and TCNT0(0) and PWM0 and TCNT0_En)) = '1' else dbus_in;

--  -------------------------------------------------------------------------------------------
-- Timer/Counter0
-- -------------------------------------------------------------------------------------------

--  -------------------------------------------------------------------------------------------
-- Common (Control/Interrupt) bits
-- ------------------------------------------------------------------------------------------- 

  TIFR_Bits : process(cp2, ireset)
  begin
    if ireset = '0' then
      TIFR <= (others => '0');
    elsif cp2 = '1' and cp2'event then
-- Timer/Counter0
      TOV0 <= (not TOV0 and (TCNT0_En and(
        (not PWM0 and TCNT0(7) and TCNT0(6) and TCNT0(5) and TCNT0(4) and TCNT0(3) and TCNT0(2) and TCNT0(1) and TCNT0(0))or
        (PWM0 and not(TCNT0(7) or TCNT0(6) or TCNT0(5) or TCNT0(4) or TCNT0(3) or TCNT0(2) or TCNT0(1)) and TCNT0(0) and TCNT0_Cnt_Dir ))))or
              (TOV0 and not(TC0OvfIRQ_Ack or(TIFR_Sel and iowe and dbus_in(0))));
      OCF0 <= (not OCF0 and(not PWM0 and COM00 and TCNT0_Cmp_Out))or(OCF0 and not(TC0CmpIRQ_Ack or(TIFR_Sel and iowe and dbus_in(1))));

    end if;
  end process;

  TIMSK_Bits : process(cp2, ireset)
  begin
    if ireset = '0' then
      TIMSK   <= (others => '0');
    elsif cp2 = '1' and cp2'event then
      if (TIMSK_Sel and iowe) = '1' then
        TIMSK <= dbus_in;
      end if;
    end if;
  end process;

-- Interrupt flags of Timer/Counter0
  TC0OvfIRQ <= TOV0 and TOIE0;          -- Interrupt on overflow of TCNT0
  TC0CmpIRQ <= OCF0 and OCIE0;          -- Interrupt on compare match of TCNT0

--  -------------------------------------------------------------------------------------------
-- End of common (Control/Interrupt) bits
-- -------------------------------------------------------------------------------------------

--  -------------------------------------------------------------------------------------------
-- Bus interface
-- -------------------------------------------------------------------------------------------
  out_en <= (TCCR0_Sel or ASSR_Sel or TIMSK_Sel or
             TIFR_Sel or TCNT0_Sel or OCR0_Sel) and iore;

  Common_Out_Mux : for i in dbus_out'range generate
    dbus_out(i) <= (TCCR0(i) and (TCCR0_Sel and not AS0))or  -- TCCR0 (Synchronous mode of TCNT0)
                   (TCCR0_Tmp(i) and (TCCR0_Sel and AS0))or  -- TCCR0 (Asynchronous mode of TCNT0)
                   (OCR0(i) and (OCR0_Sel and not AS0))or  -- OCR0  (Synchronous mode of TCNT0)
                   (OCR0_Tmp(i) and (OCR0_Sel and AS0)) or  -- OCR0  (Asynchronous mode of TCNT0)
                   (TCNT0(i) and TCNT0_Sel) or  -- TCNT0 (Both modes of TCNT0)

                   (TIFR(i) and TIFR_Sel) or  -- TIFR
                   (TIMSK(i) and TIMSK_Sel);  -- TIMSK
  end generate;
--  -------------------------------------------------------------------------------------------
-- End of bus interface
-- -------------------------------------------------------------------------------------------

end rtl;
