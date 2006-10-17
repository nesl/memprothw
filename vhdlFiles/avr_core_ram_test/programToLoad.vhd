-- Input HEX file name : testTimer.ihex
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
		x"0030" when address_in = 16#0001# else
		x"940C" when address_in = 16#0002# else
		x"0050" when address_in = 16#0003# else
		x"940C" when address_in = 16#0004# else
		x"0050" when address_in = 16#0005# else
		x"940C" when address_in = 16#0006# else
		x"0050" when address_in = 16#0007# else
		x"940C" when address_in = 16#0008# else
		x"0050" when address_in = 16#0009# else
		x"940C" when address_in = 16#000A# else
		x"0050" when address_in = 16#000B# else
		x"940C" when address_in = 16#000C# else
		x"0050" when address_in = 16#000D# else
		x"940C" when address_in = 16#000E# else
		x"0050" when address_in = 16#000F# else
		x"940C" when address_in = 16#0010# else
		x"0050" when address_in = 16#0011# else
		x"940C" when address_in = 16#0012# else
		x"0050" when address_in = 16#0013# else
		x"940C" when address_in = 16#0014# else
		x"0050" when address_in = 16#0015# else
		x"940C" when address_in = 16#0016# else
		x"0050" when address_in = 16#0017# else
		x"940C" when address_in = 16#0018# else
		x"0050" when address_in = 16#0019# else
		x"940C" when address_in = 16#001A# else
		x"0050" when address_in = 16#001B# else
		x"940C" when address_in = 16#001C# else
		x"0050" when address_in = 16#001D# else
		x"940C" when address_in = 16#001E# else
		x"0050" when address_in = 16#001F# else
		x"940C" when address_in = 16#0020# else
		x"0052" when address_in = 16#0021# else
		x"940C" when address_in = 16#0022# else
		x"0050" when address_in = 16#0023# else
		x"940C" when address_in = 16#0024# else
		x"0050" when address_in = 16#0025# else
		x"940C" when address_in = 16#0026# else
		x"0050" when address_in = 16#0027# else
		x"940C" when address_in = 16#0028# else
		x"0050" when address_in = 16#0029# else
		x"940C" when address_in = 16#002A# else
		x"0050" when address_in = 16#002B# else
		x"940C" when address_in = 16#002C# else
		x"0050" when address_in = 16#002D# else
		x"940C" when address_in = 16#002E# else
		x"0050" when address_in = 16#002F# else
		x"2411" when address_in = 16#0030# else
		x"BE1F" when address_in = 16#0031# else
		x"EFCF" when address_in = 16#0032# else
		x"E0DF" when address_in = 16#0033# else
		x"BFDE" when address_in = 16#0034# else
		x"BFCD" when address_in = 16#0035# else
		x"E010" when address_in = 16#0036# else
		x"E6A0" when address_in = 16#0037# else
		x"E0B0" when address_in = 16#0038# else
		x"E0E8" when address_in = 16#0039# else
		x"E0F1" when address_in = 16#003A# else
		x"EF0F" when address_in = 16#003B# else
		x"9503" when address_in = 16#003C# else
		x"BF0B" when address_in = 16#003D# else
		x"C004" when address_in = 16#003E# else
		x"95D8" when address_in = 16#003F# else
		x"920D" when address_in = 16#0040# else
		x"9631" when address_in = 16#0041# else
		x"F3C8" when address_in = 16#0042# else
		x"36A0" when address_in = 16#0043# else
		x"07B1" when address_in = 16#0044# else
		x"F7C9" when address_in = 16#0045# else
		x"E010" when address_in = 16#0046# else
		x"E6A0" when address_in = 16#0047# else
		x"E0B0" when address_in = 16#0048# else
		x"C001" when address_in = 16#0049# else
		x"921D" when address_in = 16#004A# else
		x"36A0" when address_in = 16#004B# else
		x"07B1" when address_in = 16#004C# else
		x"F7E1" when address_in = 16#004D# else
		x"940C" when address_in = 16#004E# else
		x"0076" when address_in = 16#004F# else
		x"940C" when address_in = 16#0050# else
		x"0000" when address_in = 16#0051# else
		x"921F" when address_in = 16#0052# else
		x"920F" when address_in = 16#0053# else
		x"B60F" when address_in = 16#0054# else
		x"920F" when address_in = 16#0055# else
		x"2411" when address_in = 16#0056# else
		x"938F" when address_in = 16#0057# else
		x"93CF" when address_in = 16#0058# else
		x"93DF" when address_in = 16#0059# else
		x"B7CD" when address_in = 16#005A# else
		x"B7DE" when address_in = 16#005B# else
		x"9180" when address_in = 16#005C# else
		x"003B" when address_in = 16#005D# else
		x"9580" when address_in = 16#005E# else
		x"9380" when address_in = 16#005F# else
		x"003B" when address_in = 16#0060# else
		x"91DF" when address_in = 16#0061# else
		x"91CF" when address_in = 16#0062# else
		x"918F" when address_in = 16#0063# else
		x"900F" when address_in = 16#0064# else
		x"BE0F" when address_in = 16#0065# else
		x"900F" when address_in = 16#0066# else
		x"901F" when address_in = 16#0067# else
		x"9518" when address_in = 16#0068# else
		x"93CF" when address_in = 16#0069# else
		x"93DF" when address_in = 16#006A# else
		x"B7CD" when address_in = 16#006B# else
		x"B7DE" when address_in = 16#006C# else
		x"E081" when address_in = 16#006D# else
		x"9380" when address_in = 16#006E# else
		x"0057" when address_in = 16#006F# else
		x"E081" when address_in = 16#0070# else
		x"9380" when address_in = 16#0071# else
		x"0053" when address_in = 16#0072# else
		x"91DF" when address_in = 16#0073# else
		x"91CF" when address_in = 16#0074# else
		x"9508" when address_in = 16#0075# else
		x"EFCF" when address_in = 16#0076# else
		x"E0DF" when address_in = 16#0077# else
		x"BFDE" when address_in = 16#0078# else
		x"BFCD" when address_in = 16#0079# else
		x"EF8F" when address_in = 16#007A# else
		x"9380" when address_in = 16#007B# else
		x"003A" when address_in = 16#007C# else
		x"EF8F" when address_in = 16#007D# else
		x"9380" when address_in = 16#007E# else
		x"003B" when address_in = 16#007F# else
		x"940E" when address_in = 16#0080# else
		x"0069" when address_in = 16#0081# else
		x"9478" when address_in = 16#0082# else
		x"CFFF" when address_in = 16#0083# else
		x"ffff";
end rtl;
