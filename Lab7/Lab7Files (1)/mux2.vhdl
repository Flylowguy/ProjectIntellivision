LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2 IS
	PORT(
		d0,d1		:IN std_logic_vector(31 downto 0);
		sel		:IN std_logic;
		f			:OUT std_logic_vector(31 downto 0)
	);
END mux2;

ARCHITECTURE behavior OF mux2 IS
BEGIN
	WITH sel SELECT
		f <= d0 WHEN '0',
			  d1 WHEN '1';
END behavior;
