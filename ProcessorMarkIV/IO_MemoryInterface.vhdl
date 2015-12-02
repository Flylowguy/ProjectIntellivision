--I/0 Memory Interface created from .bdf file
-- provided by TAs. It was modified to 32 bit
-- to fit into our system.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;

ENTITY IO_MemoryInterface IS
	PORT
	(
		clock :  IN  STD_LOGIC;
		mem_write :  IN  STD_LOGIC;
		KEY :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		mem_addr :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		mem_data :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		data_out :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		LEDG :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END IO_MemoryInterface;

ARCHITECTURE bdf_type OF IO_MemoryInterface IS

COMPONENT reg32_IO
	PORT(clock : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end COMPONENT;

COMPONENT mux2
	PORT(
		d0,d1	:IN std_logic_vector(31 downto 0);
		sel								:IN std_logic;
		f									:OUT std_logic_vector(31 downto 0)
	);
end COMPONENT;

SIGNAL	hex_data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	led_data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	push :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	switch :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;


BEGIN



b2v_HEX_DISPLAY : reg32_IO
PORT MAP(clock => SYNTHESIZED_WIRE_0,
		 data => mem_data,
		 q => hex_data);


b2v_inst : mux2
PORT MAP(sel => mem_addr(3),
		 d0 => SYNTHESIZED_WIRE_1,
		 d1 => SYNTHESIZED_WIRE_2,
		 f => data_out);


SYNTHESIZED_WIRE_8 <= NOT(clock);



SYNTHESIZED_WIRE_5 <= SYNTHESIZED_WIRE_8 AND mem_write AND mem_addr(0);


SYNTHESIZED_WIRE_0 <= SYNTHESIZED_WIRE_8 AND mem_write AND mem_addr(1);


b2v_LED : reg32_IO
PORT MAP(clock => SYNTHESIZED_WIRE_5,
		 data => mem_data,
		 q => led_data);


b2v_PUSH_BUTTON : reg32_IO
PORT MAP(clock => SYNTHESIZED_WIRE_8,
		 data => push,
		 q => SYNTHESIZED_WIRE_1);


b2v_SWITCHES : reg32_IO
PORT MAP(clock => SYNTHESIZED_WIRE_8,
		 data => switch,
		 q => SYNTHESIZED_WIRE_2);

HEX0(6 DOWNTO 0) <= hex_data(6 DOWNTO 0);
LEDG(7 DOWNTO 0) <= led_data(7 DOWNTO 0);

push(3 DOWNTO 0) <= KEY;
switch(9 DOWNTO 0) <= SW;
END bdf_type;
