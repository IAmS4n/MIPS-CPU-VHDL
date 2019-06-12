----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------------------
entity clock is
generic(delay : time := 200 ns);
port(clk : out std_logic;
reset : in std_logic);
end clock;
----------------------------------------------------------------
architecture clock_arch of clock is
begin 
	process
	begin
		--while (2>1) loop
		
		clk <= '0';
		wait for delay;
		
		if (reset='0') then
			clk <= '1';
			wait for delay;
		end if;
		--clk	<= '1';
		--wait for delay;
		--end loop;
	end process;
end clock_arch;
