LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY zeroFlag IS
	PORT(
			A		:IN std_logic_vector(31 downto 0);
			output	:OUT std_logic
	);
END zeroFlag;

ARCHITECTURE behavior OF zeroFlag IS
BEGIN
	output <= (not A(0)) and (not A(1)) and (not A(2)) and (not A(3)) and (not A(4)) and (not A(5)) and (not A(6)) and (not A(7)) and (not A(8)) and (not A(9)) and (not A(10)) and (not A(11)) and (not A(12)) and (not A(13)) and (not A(14)) and (not A(15)) and (not A(16)) and (not A(17)) and (not A(18)) and (not A(19)) and (not A(20)) and (not A(21)) and (not A(22)) and (not A(23)) and (not A(24)) and (not A(25)) and (not A(26)) and (not A(27)) and (not A(28)) and (not A(29)) and (not A(30)) and (not A(31));
END behavior;
