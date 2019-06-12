----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------
entity alu is
generic(delay:time:= 1 ns);
port(
input1:in std_logic_vector(31 downto 0);
input2:in std_logic_vector(31 downto 0);
opcode:in std_logic_vector(3 downto 0);
output:out std_logic_vector(31 downto 0);
zero:out std_logic
);
end alu;
----------------------------------------------------------------
architecture alu_arch of alu is
	signal tmp : std_logic_vector(31 downto 0);
begin
	tmp<=	input1 and input2 	when (opcode="0000")		--jadvale safe 323
	else	input1 or input2	when (opcode="0001")
	else	input1 + input2		when (opcode="0010")
	else	input1 - input2		when (opcode="0110")
	else	input1 nor input2	when (opcode="1100")
	else	x"00000001"			when (opcode="0111" and input1<input2)
	else	x"00000000"			when (opcode="0111" and input1>=input2);
	
	output<=tmp after delay;
	
	zero<=	'1' after delay when (tmp=x"00000000")
	else	'0' after delay;
	
end alu_arch;