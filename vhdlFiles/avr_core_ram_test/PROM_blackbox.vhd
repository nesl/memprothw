library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity prom is port (
address_in : in  std_logic_vector (15 downto 0);
data_out   : out std_logic_vector (15 downto 0));
end prom;

architecture rtl of prom is
begin
-- nothing
end rtl;
