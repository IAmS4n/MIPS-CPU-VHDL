-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity sign_extend is
generic(delay : time := 1 ns); 
port(input:in std_logic_vector(15 downto 0);
output:out std_logic_vector(31 downto 0));
end sign_extend;
-------------------------------------------------
architecture sign_extend_arch of sign_extend is
begin
	output<=	"1111111111111111" & input after delay when	(input(15)='1')
	else		"0000000000000000" & input after delay;
end sign_extend_arch;