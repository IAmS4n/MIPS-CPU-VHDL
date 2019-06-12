library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
------------------------------------------------------
entity instruction_memory is
generic(delay : time := 1 ns);
port(
pc_counter:in std_logic_vector(31 downto 0);
output:out std_logic_vector(31 downto 0)
);
end instruction_memory;
-------------------------------------------------------
architecture instruction_memory_arch of instruction_memory is
	type ram_type is array (0 to 511) of std_logic_vector(31 downto 0);
	
	--	VALUES:
	--	-5	=	1111111111111011
	--	F8	=	11111000
	--	F0	=	11110000
	
	---------REGISTERS---------
	--|  name	|   code	|--
	---------------------------
	--|	zero	|	00000	|--
	--|	s0		|	10000	|--
	--|	s1		|	10001	|--
	--|	s2		|	10010	|--
	--|	s3		|	10011	|--
	--|	s4		|	10100	|--
	--|	s5		|	10101	|--
	--|	s6		|	10110	|--
	--|	s7		|	10111	|--
	---------------------------
	signal tmp_ram: ram_type :=(
										----------------------------------------------------------------------------------
										--				SIZE(bit):	  6		 5		5		5	 5		6
										--													\___________/
										--														 16
										----------------------------------------------------------------------------------
										--				I/J TYPE:	  OP	 RS		RT		Address or Const
										--				 R TYPE	:	  OP	 RS		RT		rd	shamt  funct		 TYPE
										----------------------------------------------------------------------------------
	 "00100000000100010000000011111000"	-- addi $s1,$zero,F8	|	001000	zero	s1		0000000011111000	|	I TYPE
	,"00100000000100100000000011110000"	-- addi $s2,$zero,F0	|	001000	zero	s2		0000000011110000	|	I TYPE
	,"10001100000101000000000000000000"	-- lw $s4,0($zero)		|	100011	zero	s4		0000000000000000	|	I TYPE
	,"10001100000101010000000000000001"	-- lw $s5,1($zero)		|	100011	zero	s5		0000000000000001	|	I TYPE
	,"00000010001100101001100000100010"	-- l1:sub $s3,$s1,$s2	|	000000	s1 		s2 		s3 	00000 100010	|	R TYPE
	,"00100000000100100000000000000001"	-- addi $s2,$zero,1		|	001000	zero	s2 		0000000000000001	|	I TYPE
	,"00100000000100110000000000000001"	-- addi $s3,$zero,1		|	001000	zero	s2 		0000000000000001	|	I TYPE
	,"00100000000101000000000000000001"	-- addi $s4,$zero,1		|	001000	zero	s4 		0000000000000001	|	I TYPE
	,"00010110001100101111111111111011"	-- bne $s2,$s1,l1		|	000101	s1		s2		-5(decimal)			|	J TYPE
	,others => x"00000000"
	);
	
	signal devres:integer;
	signal index:integer;
begin
	index<=conv_integer(pc_counter);
	devres<=index/4;
	
	output	<= tmp_ram(devres)	after delay when (devres<512 and devres>=0)
	else	x"00000000" 		after delay;
end instruction_memory_arch;
----------------------------------------------------------
