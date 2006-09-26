----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:59 09/15/2006 
-- Design Name: 
-- Module Name:    PROM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity PROM is
  port (
    address : in  std_logic_vector (15 downto 0);
    clock   : in  std_logic;
    dataIn  : in  std_logic_vector (15 downto 0);
    wrEn    : in  std_logic;
    dataOut : out std_logic_vector (15 downto 0)
    );
end PROM;

architecture Beh of PROM is

  signal sgDataOut : std_logic_vector(255 downto 0);
  signal sgWrEn    : std_logic_vector(15 downto 0);
  signal ssr       : std_logic;

begin  -- Beh

  sgWrEn(0) <= not address(15) and not address(14) and not address(13) and not address(12) and wrEn;
  sgWrEn(1) <= not address(15) and not address(14) and not address(13) and address(12) and wrEn;
  sgWrEn(2) <= not address(15) and not address(14) and address(13) and not address(12) and wrEn;
  sgWrEn(3) <= not address(15) and not address(14) and address(13) and address(12) and wrEn;
  sgWrEn(4) <= not address(15) and address(14) and not address(13) and not address(12) and wrEn;
  sgWrEn(5) <= not address(15) and address(14) and not address(13) and address(12) and wrEn;
  sgWrEn(6) <= not address(15) and address(14) and address(13) and not address(12) and wrEn;
  sgWrEn(7) <= not address(15) and address(14) and address(13) and address(12) and wrEn;
  sgWrEn(8) <= address(15) and not address(14) and not address(13) and not address(12) and wrEn;
  sgWrEn(9) <= address(15) and not address(14) and not address(13) and address(12) and wrEn;
  sgWrEn(10) <= address(15) and not address(14) and address(13) and not address(12) and wrEn;
  sgWrEn(11) <= address(15) and not address(14) and address(13) and address(12) and wrEn;
  sgWrEn(12) <= address(15) and address(14) and not address(13) and not address(12) and wrEn;
  sgWrEn(13) <= address(15) and address(14) and not address(13) and address(12) and wrEn;
  sgWrEn(14) <= address(15) and address(14) and address(13) and not address(12) and wrEn;
  sgWrEn(15) <= address(15) and address(14) and address(13) and address(12) and wrEn;
  
  process (clock)
  begin  -- process
    if (clock = '1' and clock'event) then
      
      if (address(15 downto 12) = "0000") then
        dataOut    <= sgDataOut(15 downto 0);
      elsif (address(15 downto 12) = "0001") then
        dataOut    <= sgDataOut(31 downto 16);
      elsif (address(15 downto 12) = "0010") then
        dataOut    <= sgDataOut(47 downto 32);
      elsif (address(15 downto 12) = "0011") then
        dataOut    <= sgDataOut(63 downto 48);
      elsif (address(15 downto 12) = "0100") then
        dataOut    <= sgDataOut(79 downto 64);
      elsif (address(15 downto 12) = "0101") then
        dataOut    <= sgDataOut(95 downto 80);
      elsif (address(15 downto 12) = "0110") then
        dataOut    <= sgDataOut(111 downto 96);
      elsif (address(15 downto 12) = "0111") then
        dataOut    <= sgDataOut(127 downto 112);
      elsif (address(15 downto 12) = "1000") then
        dataOut    <= sgDataOut(143 downto 128);
      elsif (address(15 downto 12) = "1001") then
        dataOut    <= sgDataOut(159 downto 144);
      elsif (address(15 downto 12) = "1010") then
        dataOut    <= sgDataOut(175 downto 160);
      elsif (address(15 downto 12) = "1011") then
        dataOut    <= sgDataOut(191 downto 176);
      elsif (address(15 downto 12) = "1100") then
        dataOut    <= sgDataOut(207 downto 192);
      elsif (address(15 downto 12) = "1101") then
        dataOut    <= sgDataOut(223 downto 208);
      elsif (address(15 downto 12) = "1110") then
        dataOut    <= sgDataOut(239 downto 224);
      elsif (address(15 downto 12) = "1111") then
        dataOut    <= sgDataOut(255 downto 240);
      end if;
    end if;
  end process;

      generateMemory : for index in 0 to 63 generate
      begin
        RAM_Blocks : RAMB16_S4
          generic map (
            INIT       => X"0",         --  Value of output RAM registers at startup
            SRVAL      => X"0",         --  Ouput value upon SSR assertion
            write_mode => "WRITE_FIRST",  --  WRITE_FIRST, READ_FIRST or NO_CHANGE
            -- The following INIT_xx declarations specify the initial contents of the RAM
            -- Address 0 to 1023
            INIT_00    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_01    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_02    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_03    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_04    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_05    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_06    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_07    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_08    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_09    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0A    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0B    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0C    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0D    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0E    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0F    => X"0000000000000000000000000000000000000000000000000000000000000000",
            -- Address 1024 to 2047
            INIT_10    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_11    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_12    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_13    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_14    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_15    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_16    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_17    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_18    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_19    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1A    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1B    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1C    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1D    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1E    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1F    => X"0000000000000000000000000000000000000000000000000000000000000000",
            -- Address 2048 to 3071
            INIT_20    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_21    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_22    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_23    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_24    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_25    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_26    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_27    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_28    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_29    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2A    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2B    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2C    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2D    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2E    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2F    => X"0000000000000000000000000000000000000000000000000000000000000000",
            -- Address 3072 to 4095
            INIT_30    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_31    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_32    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_33    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_34    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_35    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_36    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_37    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_38    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_39    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3A    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3B    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3C    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3D    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3E    => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3F    => X"0000000000000000000000000000000000000000000000000000000000000000")

          port map (
            DO   => sgDataOut((index * 4 + 3) downto (index * 4)),  -- 4-bit Data Output
            ADDR => address(11 downto 0),  -- 12-bit Address Input
            CLK  => clock,              -- Clock
            DI   => dataIn( (((index mod 4) * 4) + 3) downto ((index mod 4) * 4) ),  -- 4-bit Data Input
            EN   => '1',                    -- RAM Enable Input
            SSR  => SSR,                    -- Synchronous Set/Reset Input
            WE   => sgWrEn(index / 4)                    -- Write Enable Input
            );

      end generate generateMemory;

end Beh;
