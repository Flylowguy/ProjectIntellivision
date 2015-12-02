LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY or1_4 IS
	PORT(
			A,B,C,D		:IN std_logic;
			output	:OUT std_logic
	);
END or1_4;

ARCHITECTURE behavior OF or1_4 IS
BEGIN
	output <= A OR B OR C OR D;
END behavior;
