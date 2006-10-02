-- Input HEX file name : portAisOne.ihex
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity programToLoad is port (
address_in : in  std_logic_vector (15 downto 0);
data_out   : out std_logic_vector (15 downto 0));
end programToLoad;

architecture rtl of programToLoad is
begin
data_out <=
		x"940C" when address_in = 16#0000# else
		x"0046" when address_in = 16#0001# else
		x"940C" when address_in = 16#0002# else
		x"0063" when address_in = 16#0003# else
		x"940C" when address_in = 16#0004# else
		x"0063" when address_in = 16#0005# else
		x"940C" when address_in = 16#0006# else
		x"0063" when address_in = 16#0007# else
		x"940C" when address_in = 16#0008# else
		x"0063" when address_in = 16#0009# else
		x"940C" when address_in = 16#000A# else
		x"0063" when address_in = 16#000B# else
		x"940C" when address_in = 16#000C# else
		x"0063" when address_in = 16#000D# else
		x"940C" when address_in = 16#000E# else
		x"0063" when address_in = 16#000F# else
		x"940C" when address_in = 16#0010# else
		x"0063" when address_in = 16#0011# else
		x"940C" when address_in = 16#0012# else
		x"0063" when address_in = 16#0013# else
		x"940C" when address_in = 16#0014# else
		x"0063" when address_in = 16#0015# else
		x"940C" when address_in = 16#0016# else
		x"0063" when address_in = 16#0017# else
		x"940C" when address_in = 16#0018# else
		x"0063" when address_in = 16#0019# else
		x"940C" when address_in = 16#001A# else
		x"0063" when address_in = 16#001B# else
		x"940C" when address_in = 16#001C# else
		x"0063" when address_in = 16#001D# else
		x"940C" when address_in = 16#001E# else
		x"0063" when address_in = 16#001F# else
		x"940C" when address_in = 16#0020# else
		x"0063" when address_in = 16#0021# else
		x"940C" when address_in = 16#0022# else
		x"0063" when address_in = 16#0023# else
		x"940C" when address_in = 16#0024# else
		x"0063" when address_in = 16#0025# else
		x"940C" when address_in = 16#0026# else
		x"0063" when address_in = 16#0027# else
		x"940C" when address_in = 16#0028# else
		x"0063" when address_in = 16#0029# else
		x"940C" when address_in = 16#002A# else
		x"0063" when address_in = 16#002B# else
		x"940C" when address_in = 16#002C# else
		x"0063" when address_in = 16#002D# else
		x"940C" when address_in = 16#002E# else
		x"0063" when address_in = 16#002F# else
		x"940C" when address_in = 16#0030# else
		x"0063" when address_in = 16#0031# else
		x"940C" when address_in = 16#0032# else
		x"0063" when address_in = 16#0033# else
		x"940C" when address_in = 16#0034# else
		x"0063" when address_in = 16#0035# else
		x"940C" when address_in = 16#0036# else
		x"0063" when address_in = 16#0037# else
		x"940C" when address_in = 16#0038# else
		x"0063" when address_in = 16#0039# else
		x"940C" when address_in = 16#003A# else
		x"0063" when address_in = 16#003B# else
		x"940C" when address_in = 16#003C# else
		x"0063" when address_in = 16#003D# else
		x"940C" when address_in = 16#003E# else
		x"0063" when address_in = 16#003F# else
		x"940C" when address_in = 16#0040# else
		x"0063" when address_in = 16#0041# else
		x"940C" when address_in = 16#0042# else
		x"0063" when address_in = 16#0043# else
		x"940C" when address_in = 16#0044# else
		x"0063" when address_in = 16#0045# else
		x"2411" when address_in = 16#0046# else
		x"BE1F" when address_in = 16#0047# else
		x"EFCF" when address_in = 16#0048# else
		x"E1D0" when address_in = 16#0049# else
		x"BFDE" when address_in = 16#004A# else
		x"BFCD" when address_in = 16#004B# else
		x"E011" when address_in = 16#004C# else
		x"E0A0" when address_in = 16#004D# else
		x"E0B1" when address_in = 16#004E# else
		x"EDE8" when address_in = 16#004F# else
		x"E0F0" when address_in = 16#0050# else
		x"E000" when address_in = 16#0051# else
		x"BF0B" when address_in = 16#0052# else
		x"C002" when address_in = 16#0053# else
		x"9007" when address_in = 16#0054# else
		x"920D" when address_in = 16#0055# else
		x"30A0" when address_in = 16#0056# else
		x"07B1" when address_in = 16#0057# else
		x"F7D9" when address_in = 16#0058# else
		x"E011" when address_in = 16#0059# else
		x"E0A0" when address_in = 16#005A# else
		x"E0B1" when address_in = 16#005B# else
		x"C001" when address_in = 16#005C# else
		x"921D" when address_in = 16#005D# else
		x"30A0" when address_in = 16#005E# else
		x"07B1" when address_in = 16#005F# else
		x"F7E1" when address_in = 16#0060# else
		x"940C" when address_in = 16#0061# else
		x"0065" when address_in = 16#0062# else
		x"940C" when address_in = 16#0063# else
		x"0000" when address_in = 16#0064# else
		x"EFCF" when address_in = 16#0065# else
		x"E1D0" when address_in = 16#0066# else
		x"BFDE" when address_in = 16#0067# else
		x"BFCD" when address_in = 16#0068# else
		x"E081" when address_in = 16#0069# else
		x"BB8B" when address_in = 16#006A# else
		x"CFFE" when address_in = 16#006B# else
		x"ffff";
end rtl;