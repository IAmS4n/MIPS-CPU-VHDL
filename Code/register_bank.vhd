-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity register_bank is
generic(delay : time := 1 ns);
Port(read_address1:in std_logic_vector(4 downto 0);
read_address2:in std_logic_vector(4 downto 0);
write_address:in std_logic_vector(4 downto 0);
write_data:in std_logic_vector(31 downto 0);
read_data1:out std_logic_vector(31 downto 0);
read_data2:out std_logic_vector(31 downto 0);
clock:in std_logic;
enable_write:in std_logic);
end register_bank;
-------------------------------------------------
architecture register_bank_arch of register_bank is
	type Matrix is array (0 to 31) of std_logic_vector(31 downto 0);
	signal mem : Matrix:= (x"00000000",	--Zero register
	others => x"00000000");
	signal index1,index2,index3	: integer;
begin
	index1 <= conv_integer(read_address1);
	index2 <= conv_integer(read_address2);
	index3 <= conv_integer(write_address);
	process(clock)--,enable_write)
	begin
		if (clock'event and clock='0') then
			if(enable_write='1') then
				mem(index3) <= write_data;
			end if;
			
			if(enable_write='1' and index3=index1) then
				read_data1 <= write_data;
			else
				read_data1 <= mem(index1);
			end if;
			
			if(enable_write='1' and index3=index2) then
				read_data2 <= write_data;
			else
				read_data2 <= mem(index2);
			end if;
			
		end if;
		
	end process;
	
	--read_data1<=write_data when (enable_write='0' and index1=index3)
	--else mem(index1) when (enable_write='0');
	
	--read_data2<=write_data when (enable_write='0' and index2=index3)
	--else mem(index2) when (enable_write='0');
	
end register_bank_arch;           
