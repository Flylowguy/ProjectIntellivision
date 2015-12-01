LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY not32 IS
	PORT(
			A			:IN std_logic_vector(31 downto 0);
			output	:OUT std_logic_vector(31 downto 0)
	);
END not32;

ARCHITECTURE behavior OF not32 IS
BEGIN
	output <= NOT A;
END behavior;
