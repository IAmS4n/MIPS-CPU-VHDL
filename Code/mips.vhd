library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity mips is
	generic(gatedelay	:time	:=	10	 	ns;
			clockdelay	:time	:=	200	ns
	);
end mips;
-------------------------------------------------
architecture mips_arch of mips is
	component mux is
	generic(width:integer:= 32;
	delay:time:= gatedelay);
	port(inpu1:in std_logic_vector(width-1 downto 0);
	inpu2:in std_logic_vector(width-1 downto 0);
	s:in std_logic;
	output:out std_logic_vector(width-1 downto 0)
	);
	end component;
	-------------------------------------------------
	component data_memory is
	port(clock:in std_logic;	
	enable_write:in std_logic;
	enable_read:in std_logic;
	input_address:in std_logic_vector(31 downto 0);
	write_data:in std_logic_vector(31 downto 0);
	read_data:out std_logic_vector(31 downto 0)
	);
	end component;
	-------------------------------------------------
	component alu is
	generic(delay:time:= gatedelay);
	port(
	input1:in std_logic_vector(31 downto 0);
	input2:in std_logic_vector(31 downto 0);
	opcode:in std_logic_vector(3 downto 0);
	output:out std_logic_vector(31 downto 0);
	zero:out std_logic
	);
	end component;
	-------------------------------------------------
	component adder is
	generic(delay:time:= gatedelay);
	port(
	input1:in std_logic_vector(31 downto 0);
	input2:in std_logic_vector(31 downto 0);
	result:out std_logic_vector(31 downto 0)
	);
	end component;
	-------------------------------------------------
	component shift is
	generic(delay:time:= gatedelay);
	port(input:in std_logic_vector(31 downto 0);
	result:out std_logic_vector(31 downto 0));
	end component;
	-------------------------------------------------
	component alu_control is 
	generic(delay:time:=gatedelay);
	port(aluop: in std_logic_vector(1 downto 0);
	instruct: in std_logic_vector(5 downto 0);
	operation: out std_logic_vector(3 downto 0)
	);
	end component;
	-------------------------------------------------
	component sign_extend is
	generic(delay : time := gatedelay); 
	port(input:in std_logic_vector(15 downto 0);
	output:out std_logic_vector(31 downto 0));
	end component;
	-------------------------------------------------
	component controler is 
	generic(delay :time:=gatedelay);
	port(instruction:in std_logic_vector(5 downto 0);
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
	end component;
	-------------------------------------------------
	component register_bank is
	generic(delay : time := gatedelay);
	Port(read_address1:in std_logic_vector(4 downto 0);
	read_address2:in std_logic_vector(4 downto 0);
	write_address:in std_logic_vector(4 downto 0);
	write_data:in std_logic_vector(31 downto 0);
	read_data1:out std_logic_vector(31 downto 0);
	read_data2:out std_logic_vector(31 downto 0);
	clock:in std_logic;
	enable_write:in std_logic);
	end component;
	-------------------------------------------------
	component pc is
	generic(width:integer:=32);
	port(
	input:in std_logic_vector(width-1 downto 0);
	result:out std_logic_vector(width-1 downto 0);
	clock:in std_logic;
	reset:in std_logic
	);
	end component;
	-------------------------------------------------
	component clock is
	generic(delay : time := clockdelay);
	port(clk : out std_logic;
	reset : in std_logic);
	end component;
	-------------------------------------------------
	component instruction_memory is
	generic(delay : time := gatedelay);
	port(
	pc_counter:in std_logic_vector(31 downto 0);
	output:out std_logic_vector(31 downto 0)
	);
	end component;
	
	--================================================
	signal reset			:std_logic:='0';
	signal clk				:std_logic:='0';
	
	------------------------1-------------------------
	signal constFour		:std_logic_vector(31 downto 0):="00000000000000000000000000000100";
	signal PcAdderOut		:std_logic_vector(31 downto 0):=x"00000000";
	signal PcOut			:std_logic_vector(31 downto 0):=x"00000000";
	signal instructure1		:std_logic_vector(31 downto 0):=x"00000000";
	signal adder2adder1		:std_logic_vector(31 downto 0):=x"00000000";
	signal adderResult2		:std_logic_vector(31 downto 0):=x"00000000";
	signal andRes			:std_logic:='0';
	
	signal IFIDInput		:std_logic_vector(63 downto 0);
	signal IFIDRresult		:std_logic_vector(63 downto 0);
	
	------------------------2-------------------------
	signal regWrite4		:std_logic;
	signal instructure2		:std_logic_vector(31 downto 0):=x"00000000";
	signal adder2adder2		:std_logic_vector(31 downto 0):=x"00000000";
	signal signExtendOut1	:std_logic_vector(31 downto 0):=x"00000000";
	signal MuxMemout		:std_logic_vector(31 downto 0):=x"00000000";
	signal muxInsOut3		:std_logic_vector(4 downto 0):="00000";
	signal readData11		:std_logic_vector(31 downto 0):=x"00000000";
	signal readData21		:std_logic_vector(31 downto 0):=x"00000000";
	
	signal IDEXRresult		:std_logic_vector(147 downto 0);
	signal IDEXInput		:std_logic_vector(147 downto 0);
	----control-----
	signal regDst1			:std_logic:='0';
	signal branch1			:std_logic:='0';
	signal memRead1			:std_logic:='0';
	signal memtoReg1		:std_logic:='0';
	signal aluOp1			:std_logic_vector(1 downto 0):="00";
	signal memWrite1		:std_logic:='0';
	signal aluSrc1			:std_logic:='0';
	signal regWrite1		:std_logic:='0';
	signal branchne1		:std_logic:='0';
	---------------
	
	------------------------3-------------------------
	signal readData12		:std_logic_vector(31 downto 0):=x"00000000";
	signal readData22		:std_logic_vector(31 downto 0):=x"00000000";
	signal shiftResult		:std_logic_vector(31 downto 0):=x"00000000";
	signal signExtendOut2	:std_logic_vector(31 downto 0):=x"00000000";
	signal adder2adder3		:std_logic_vector(31 downto 0):=x"00000000";
	signal adderResult1		:std_logic_vector(31 downto 0):=x"00000000";
	signal partOfInstructor	:std_logic_vector(9 downto 0):="0000000000";
	signal muxInsOut1		:std_logic_vector(4 downto 0):="00000";
	signal MuxRegsout		:std_logic_vector(31 downto 0):=x"00000000";
	signal operation		:std_logic_vector(3 downto 0):="0000";
	signal ALUzero1			:std_logic:='0';
	signal ALUzerotmp		:std_logic:='0';
	signal ALUout1			:std_logic_vector(31 downto 0):=x"00000000";
	
	signal EXMEMInput		:std_logic_vector(106 downto 0);
	signal EXMEMRresult		:std_logic_vector(106 downto 0);
	----control-----
	signal regDst2			:std_logic:='0';
	signal branch2			:std_logic:='0';
	signal memRead2			:std_logic:='0';
	signal memtoReg2		:std_logic:='0';
	signal aluOp2			:std_logic_vector(1 downto 0):="00";
	signal memWrite2		:std_logic:='0';
	signal aluSrc2			:std_logic:='0';
	signal regWrite2		:std_logic:='0';
	signal branchne2		:std_logic:='0';
	---------------
	
	------------------------4-------------------------
	signal ALUzero2			:std_logic:='0';
	signal ALUout2			:std_logic_vector(31 downto 0):=x"00000000";
	signal readData23		:std_logic_vector(31 downto 0):=x"00000000";
	signal muxInsOut2		:std_logic_vector(4 downto 0):="00000";
	signal MemoryDataRead1	:std_logic_vector(31 downto 0):=x"00000000";
	
	signal MEMWBInput		:std_logic_vector(70 downto 0);
	signal MEMWBRresult		:std_logic_vector(70 downto 0);
	----control-----
	signal branch3			:std_logic:='0';
	signal memRead3			:std_logic:='0';
	signal memtoReg3		:std_logic:='0';
	signal memWrite3		:std_logic:='0';
	signal regWrite3		:std_logic:='0';
	---------------
	
	-----------------------5--------------------------	
	signal MemoryDataRead2	:std_logic_vector(31 downto 0):=x"00000000";
	signal ALUout3			:std_logic_vector(31 downto 0):=x"00000000";
	----control-----
	signal memtoReg4		:std_logic:='0';
	---------------
	
	--================================================
begin
	----------------------1---------------------------
	IFIDInput		<= adder2adder1 & instructure1;
	
	lblmux1			:	mux					port map(adder2adder1,adderResult2,andRes,PcAdderOut);
	lblpc			:	pc					port map(PcAdderOut,PcOut,clk,reset);
	lbladder1		:	adder				port map(constFour,PcOut,adder2adder1);
	lblinsmem		:	instruction_memory	port map(PcOut,instructure1);
	lblIFID			:	pc					generic map(width => 64) port map(IFIDInput,IFIDRresult,clk,reset);
	
	---------------------2----------------------------
	adder2adder2	<= IFIDRresult(63 downto 32);
	instructure2	<= IFIDRresult(31 downto 0);
	
	IDEXInput		<= branchne1 & regDst1 & branch1 & memRead1 & memtoReg1 & aluOp1 & memWrite1 & aluSrc1 & regWrite1 & adder2adder2 & readData11 & readData21 & signExtendOut1 & instructure2(20 downto 16) & instructure2(15 downto 11);
	
	lblsignextend		:	sign_extend		port map(instructure2(15 downto 0),signExtendOut1);
	lblregisterbank		:	register_bank	port map(instructure2(25 downto 21),instructure2(20 downto 16),muxInsOut3,MuxMemout,readData11,readData21,clk,regWrite4);
	lblcontroler		:	controler		port map(instructure2(31 downto 26),regDst1,branch1,memRead1,memtoReg1,aluOp1,memWrite1,aluSrc1,regWrite1,branchne1);
	lblIIDEX			:	pc				generic map(width => 148) port map(IDEXInput,IDEXRresult,clk,reset);
	
	--------------------3-----------------------------
	----control-----
	branchne2		<= IDEXRresult(147);
	regDst2			<= IDEXRresult(146);
	branch2			<= IDEXRresult(145);
	memRead2		<= IDEXRresult(144);
	memtoReg2		<= IDEXRresult(143);
	aluOp2			<= IDEXRresult(142 downto 141);
	memWrite2		<= IDEXRresult(140);
	aluSrc2			<= IDEXRresult(139);
	regWrite2		<= IDEXRresult(138);
	---------------
	
	adder2adder3	<= IDEXRresult(137 downto 106);
	readData12		<= IDEXRresult(105 downto 74);
	readData22		<= IDEXRresult(73 downto 42);
	signExtendOut2	<= IDEXRresult(41 downto 10);
	partOfInstructor<= IDEXRresult(9 downto 0);
	
	ALUzero1		<= ALUzerotmp xor branchne2 after gatedelay;
	EXMEMInput		<= branch2 & memRead2 & memtoReg2 & memWrite2 & regWrite2 & adderResult1 & ALUzero1 & ALUout1 & readData22 & muxInsOut1;
	
	lbladder2			:	adder			port map(shiftResult,adder2adder3,adderResult1);
	lblshift			:	shift			port map(signExtendOut2,shiftResult);
	lblALU				:	mux				port map(readData22,signExtendOut2,aluSrc2,MuxRegsout);
	lblmux2				:	alu				port map(readData12,MuxRegsout,operation,ALUout1,ALUzerotmp);
	lblALUControl		:	alu_control		port map(aluOp2,signExtendOut2(5 downto 0),operation);
	lblmux3				:	mux				generic map(width => 5) port map(partOfInstructor(9 downto 5),partOfInstructor(4 downto 0),regDst2,muxInsOut1);
	lblEXMEM			:	pc				generic map(width => 107) port map(EXMEMInput,EXMEMRresult,clk,reset);
	
	
	-------------------4------------------------------
	----control-----
	branch3			<= EXMEMRresult(106);
	memRead3		<= EXMEMRresult(105);
	memtoReg3		<= EXMEMRresult(104);
	memWrite3		<= EXMEMRresult(103);
	regWrite3		<= EXMEMRresult(102);
	---------------
	
	adderResult2	<= EXMEMRresult(101 downto 70);
	ALUzero2		<= EXMEMRresult(69);
	ALUout2			<= EXMEMRresult(68 downto 37);
	readData23		<= EXMEMRresult(36 downto 5);
	muxInsOut2		<= EXMEMRresult(4 downto 0);
	
	MEMWBInput		<= memtoReg3 & regWrite3 & MemoryDataRead1 & ALUout2 & muxInsOut2;
	
	andRes			<= branch3 and ALUzero2 after gatedelay;
	lblDataMemory		:	data_memory		port map(clk,memWrite3,memRead3,ALUout2,readData23,MemoryDataRead1);
	lblMEMWB			:	pc				generic map(width => 71) port map(MEMWBInput,MEMWBRresult,clk,reset);
	
	-------------------5------------------------------
	----control-----
	memtoReg4		<= MEMWBRresult(70);
	regWrite4		<= MEMWBRresult(69);
	---------------
	
	MemoryDataRead2	<= MEMWBRresult(68 downto 37);
	ALUout3			<= MEMWBRresult(36 downto 5);
	muxInsOut3		<= MEMWBRresult(4 downto 0);
	
	lblmux4				:	mux				port map(ALUout3,MemoryDataRead2,memtoReg4,MuxMemout);
	
	-------------------CLOCK--------------------------
	lblclock			:	clock			port map(clk,reset);
	
	--================================================
	process
	begin
		reset	<=	'1';
		--MemoryDataRead1	<=	x"00000000";
		--MEMWBInput		<=	"00000000000000000000000000000000000000000000000000000000000000000000000";
		--PcOut			<=	x"00000000";
		wait for 20 ns;
		reset	<=	'0';
		
		wait;
    end process;
	
end mips_arch;