library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
------------------------------------------------------
entity data_memory is
port(clock:in std_logic;	
enable_write:in std_logic;
enable_read:in std_logic;
input_address:in std_logic_vector(31 downto 0);
write_data:in std_logic_vector(31 downto 0);
read_data:out std_logic_vector(31 downto 0)
);
end data_memory;
-------------------------------------------------------
architecture data_memory_arch of data_memory is
type ram_type is array (0 to 511) of std_logic_vector(31 downto 0);
	signal tmp_ram: ram_type :=(x"00000003",x"05000000",others => x"00000000");
	--signal devres:integer;
	--signal remres:integer;
	--signal index:integer;
	signal tmp:std_logic_vector(63 downto 0);
	signal Otmp:std_logic_vector(63 downto 0);
begin
	process(clock)--,enable_write,enable_read)
		variable remres:integer;
		variable index:integer;
		variable devres:integer;
	begin
		
		if (clock'event and clock='1') then
			index:=conv_integer(input_address);
			devres:=index/4;
			remres:=((index rem 4)*8);
			tmp<=tmp_ram(devres) & tmp_ram(devres+1);
			if (enable_write='1') then
				if (remres=0) then
					tmp_ram(devres)<=write_data;
				else
					Otmp<= tmp(63 downto 64-remres) & write_data & tmp(31-remres downto 0);
					tmp_ram(devres)<=Otmp(63 downto 32);
					tmp_ram(devres+1)<=Otmp(31 downto 0);
				end if;
			end if;
			
			if (enable_read='1') then
				if (index>511*4) then
					read_data<= "00000000000000000000000000000000";
				else
					read_data <= tmp(63-remres downto 32-remres);
				end if;
			end if;
			
		end if;
	end process;
end data_memory_arch;
----------------------------------------------------------
