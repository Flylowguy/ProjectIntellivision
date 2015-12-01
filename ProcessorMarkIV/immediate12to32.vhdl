library ieee;
use ieee.std_logic_1164.all;

entity immediate12to32 is
	port(immed: in std_logic_vector(11 downto 0);
		 extend: in std_logic_vector(1 downto 0);
		 immedEx: out std_logic_vector(31 downto 0));
end immediate12to32;

architecture arch of immediate12to32 is

begin
	process(immed, extend)
	begin
		if(extend = "00") then
			immedEx <= "00000000000000000000" & immed;
		else
			if(immed(11) = '0') then
				immedEx <= "00000000000000000000" & immed;
			else
				immedEx <= "11111111111111111111" & immed;
			end if;
		end if;
	end process;
end arch;
