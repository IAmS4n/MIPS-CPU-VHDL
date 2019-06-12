-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity mux is
generic(width:integer:= 32;
delay:time:= 1 ns);
port(inpu1:in std_logic_vector(width-1 downto 0);
inpu2:in std_logic_vector(width-1 downto 0);
s:in std_logic;
output:out std_logic_vector(width-1 downto 0)
);
end mux;  
-------------------------------------------------
architecture mux_arch of mux is
begin
	output	<=inpu1 after delay when (s='0')
	else 	inpu2 after delay;
end mux_arch;
--------------------------------------------------
