-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity shift is
generic(delay:time:= 1 ns);
port(input:in std_logic_vector(31 downto 0);
result:out std_logic_vector(31 downto 0));
end shift;
-------------------------------------------------
architecture shift_arch of shift is
	signal tmp:std_logic_vector(31 downto 0);
begin
	tmp(0)<='0';
	tmp(1)<='0';
	lbl1:for i in 0 to 29 generate
		tmp(i+2)<=input(i);
	end generate lbl1;
	result<=tmp after delay;
end shift_arch;