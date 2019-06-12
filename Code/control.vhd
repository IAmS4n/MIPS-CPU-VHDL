----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------
entity controler is 
generic(delay :time:=1 ns);
port(instruction:in std_logic_vector(5 downto 0);	--opcode part
regdst:out std_logic;
branch:out std_logic;
memread:out std_logic;
memtoreg:out std_logic;
aluop:out std_logic_vector(1 downto 0);
memwrite:out std_logic;
alusrc:out std_logic;
regwrite:out std_logic;
branchne:out std_logic
);
end controler;
----------------------------------------------------------------
architecture controler_arch of controler is
	signal tmp : std_logic_vector(9 downto 0);
begin
	
	--												TYPE	|	branchne	regdst	alusrc	memtoreg	regwrite	memread		memwrite	branch	aluop
	--											----------------------------------------------------------------------------------------------------------
	tmp<="0100100010" when (instruction="000000")--R format	|	X			1		0		0			1			0			0			0		10
	else "0011110000" when (instruction="100011")--	lw		|	X			0		1		1			1			1			0			0		00
	else "0010001000" when (instruction="101011")--	sw		|	X			X		1		X			0			0			1			0		00
	else "0000000101" when (instruction="000100")--	beq		|	0			X		0		X			0			0			0			1		01
	else "1000000101" when (instruction="000101")--	bne		|	1			X		0		X			0			0			0			1		01
	else "0010100000" when (instruction="001000");--addi	|	X			0		1		0			1			0			0			0		00
	
	branchne	<= tmp(9) after delay;
	regdst		<= tmp(8) after delay;
	alusrc		<= tmp(7) after delay;
	memtoreg	<= tmp(6) after delay;
	regwrite	<= tmp(5) after delay;
	memread		<= tmp(4) after delay;
	memwrite	<= tmp(3) after delay;
	branch		<= tmp(2) after delay;
	aluop		<= tmp(1 downto 0) after delay;
end controler_arch;