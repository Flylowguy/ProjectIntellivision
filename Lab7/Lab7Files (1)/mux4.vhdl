LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux4 IS
	PORT(
		d0,d1,d2,d3		:IN std_logic_vector(31 downto 0);
		sel				:IN std_logic_vector(1 downto 0);
		f					:OUT std_logic_vector(31 downto 0)
	);
END mux4;

ARCHITECTURE behavior OF mux4 IS
BEGIN
	WITH sel SELECT
		f <= d0 WHEN "00",
			  d1 WHEN "01",
			  d2 WHEN "10",
			  d3 WHEN "11";
END behavior;
