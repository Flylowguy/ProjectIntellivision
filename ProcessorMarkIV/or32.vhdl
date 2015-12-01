LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY or32 IS
	PORT(
			A,B		:IN std_logic_vector(31 downto 0);
			output	:OUT std_logic_vector(31 downto 0)
	);
END or32;

ARCHITECTURE behavior OF or32 IS
BEGIN
	output <= A OR B;
END behavior;
