LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY and32 IS
	PORT(
			A,B		:IN std_logic_vector(31 downto 0);
			output	:OUT std_logic_vector(31 downto 0)
	);
END and32;

ARCHITECTURE behavior OF and32 IS
BEGIN
	output <= A AND B;
END behavior;
