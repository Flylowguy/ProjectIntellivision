LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Reg32 IS
	PORT(
		data									:IN std_logic_vector(31 downto 0);
		enable, reset, Clock				:IN std_logic;
		output								:OUT std_logic_vector(31 downto 0)
	);
END Reg32;

ARCHITECTURE behavior OF Reg32 IS
BEGIN
	PROCESS(Clock, reset)
	BEGIN
		IF(reset = '1') THEN
			output <= (OTHERS =>'0');
		ELSIF(rising_edge(Clock)) THEN
			IF(enable = '1') THEN
				output <= data;
			END IF;
		END IF;
	END PROCESS;
END behavior;
