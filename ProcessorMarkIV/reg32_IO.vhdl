--Modification off of the Reg_16.vhdl given to us
-- by TAs. Transformed into 32 bit register for
-- us in our system.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY lpm;
USE lpm.all;

ENTITY reg32_IO IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END reg32_IO;


ARCHITECTURE SYN OF reg32_IO IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (31 DOWNTO 0);



	COMPONENT lpm_ff
	GENERIC (
		lpm_fftype		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL
	);
	PORT (
			clock	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			data	: IN STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	q    <= sub_wire0(31 DOWNTO 0);

	lpm_ff_component : lpm_ff
	GENERIC MAP (
		lpm_fftype => "DFF",
		lpm_type => "LPM_FF",
		lpm_width => 31
	)
	PORT MAP (
		clock => clock,
		data => data,
		q => sub_wire0
	);



END SYN;
