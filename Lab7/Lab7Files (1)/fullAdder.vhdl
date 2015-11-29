LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fullAdder IS
  PORT(
    a,b,cIn :IN STD_LOGIC;
    s,cOut  :OUT STD_LOGIC
  );
END fullAdder;

ARCHITECTURE behaviour OF fullAdder IS
BEGIN
  s <= a xor b xor cIn;
  cOut <= (a and b) or (b and cIn) or (a and cIn);
END behaviour;
