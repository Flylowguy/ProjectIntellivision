--Levi Amen
--2015/12/1
--And gate with two 1 bit inputs.
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY and1_2 IS
	PORT(
			A,B		:IN std_logic;
			output	:OUT std_logic
	);
END and1_2;

ARCHITECTURE behavior OF and1_2 IS
BEGIN
	output <= A AND B;
END behavior;
