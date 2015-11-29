LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY xor32 IS
	PORT(
			A,B		:IN std_logic_vector(31 downto 0);
			output	:OUT std_logic_vector(31 downto 0)
	);
END xor32;

ARCHITECTURE behavior OF xor32 IS
BEGIN
	output <= A XOR B;
END behavior;
