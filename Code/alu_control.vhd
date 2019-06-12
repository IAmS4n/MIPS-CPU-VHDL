----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------
entity alu_control is 
generic(delay:time:=1 ns);
port(aluop: in std_logic_vector(1 downto 0);
instruct: in std_logic_vector(5 downto 0);--funct of instruct
operation: out std_logic_vector(3 downto 0)
);
end alu_control;
----------------------------------------------------------------
architecture alu_control_arch of alu_control IS
	signal affinstruct:std_logic_vector(3 downto 0);
begin
	affinstruct<=instruct(3 downto 0);
	--safe 325 ketab
	--									ALUop				FUNCT				
	operation<=	"0010" after delay when	(aluop="00")
	else		"0110" after delay when	(aluop="01")
	else		"0010" after delay when	(aluop="10"		and affinstruct="0000")
	else		"0110" after delay when	(aluop(1)='1'	and affinstruct="0010")
	else		"0000" after delay when	(aluop="10" 	and affinstruct="0100")
	else		"0001" after delay when	(aluop="10" 	and affinstruct="0101")
	else		"0111" after delay when	(aluop(1)='1' 	and affinstruct="1010");
end alu_control_arch;
