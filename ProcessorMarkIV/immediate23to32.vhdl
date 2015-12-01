library ieee;
use ieee.std_logic_1164.all;

entity immediate23to32 is
	port(immed: in std_logic_vector(22 downto 0);
		 extend: in std_logic_vector(1 downto 0);
		 immedEx: out std_logic_vector(31 downto 0));
end immediate23to32;

architecture arch of immediate23to32 is

begin
	process(immed, extend)
	begin
		if(extend = "00") then
			immedEx <= "000000000" & immed;
		else
			if(immed(22) = '0') then
				immedEx <= "000000000" & immed;
			else
				immedEx <= "111111111" & immed;
			end if;
		end if;
	end process;
end arch;
