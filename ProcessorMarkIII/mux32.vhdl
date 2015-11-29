LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux32 IS
	PORT(
		d0,d1,d2,d3,d4,d5,d6,d7		:IN std_logic_vector(31 downto 0);
		d8,d9,dA,dB,dC,dD,dE,dF		:IN std_logic_vector(31 downto 0);
		d10,d11,d12,d13,d14,d15,d16,d17		:IN std_logic_vector(31 downto 0);
		d18,d19,d1A,d1B,d1C,d1D,d1E,d1F		:IN std_logic_vector(31 downto 0);
		sel								:IN std_logic_vector(4 downto 0);
		f									:OUT std_logic_vector(31 downto 0)
	);
END mux32;

ARCHITECTURE behavior OF mux32 IS
BEGIN
	WITH sel SELECT
		f <= d0 WHEN "00000",
			  d1 WHEN "00001",
			  d2 WHEN "00010",
			  d3 WHEN "00011",
			  d4 WHEN "00100",
			  d5 WHEN "00101",
			  d6 WHEN "00110",
			  d7 WHEN "00111",
			  d8 WHEN "01000",
			  d9 WHEN "01001",
			  dA WHEN "01010",
			  dB WHEN "01011",
			  dC WHEN "01100",
			  dD WHEN "01101",
			  dE WHEN "01110",
			  dF WHEN "01111",
				d10 WHEN "10000",
				d11 WHEN "10001",
				d12 WHEN "10010",
				d13 WHEN "10011",
				d14 WHEN "10100",
				d15 WHEN "10101",
				d16 WHEN "10110",
				d17 WHEN "10111",
				d18 WHEN "11000",
				d19 WHEN "11001",
				d1A WHEN "11010",
				d1B WHEN "11011",
				d1C WHEN "11100",
				d1D WHEN "11101",
				d1E WHEN "11110",
				d1F WHEN "11111";



END behavior;
