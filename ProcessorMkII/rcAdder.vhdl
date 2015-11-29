LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY rcAdder IS
  PORT(
    aIn :IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    bIn :IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    cIn :IN STD_LOGIC;
    f   :OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    c30, c31  :OUT STD_LOGIC
  );
END rcAdder;

ARCHITECTURE behaviour OF rcAdder IS
  COMPONENT fullAdder
  PORT(
    a,b,cIn :IN STD_LOGIC;
    s,cOut  :OUT STD_LOGIC
  );
  END COMPONENT;
  SIGNAL carry1, carry2, carry3, carry4, carry5, carry6 :STD_LOGIC;
  SIGNAL carry7, carry8, carry9, carry10, carry11, carry12 :STD_LOGIC;
  SIGNAL carry13, carry14, carry15, carry16, carry17, carry18 :STD_LOGIC;
  SIGNAL carry19, carry20, carry21, carry22, carry23, carry24 :STD_LOGIC;
  SIGNAL carry25, carry26, carry27, carry28, carry29, carry30 :STD_LOGIC;
  SIGNAL carry31, carry32 :STD_LOGIC;
BEGIN
  fa0: fullAdder PORT MAP(aIn(0), bIn(0), cIn, f(0), carry1);
  fa1: fullAdder PORT MAP(aIn(1), bIn(1), carry1, f(1), carry2);
  fa2: fullAdder PORT MAP(aIn(2), bIn(2), carry2, f(2), carry3);
  fa3: fullAdder PORT MAP(aIn(3), bIn(3), carry3, f(3), carry4);
  fa4: fullAdder PORT MAP(aIn(4), bIn(4), carry4, f(4), carry5);
  fa5: fullAdder PORT MAP(aIn(5), bIn(5), carry5, f(5), carry6);
  fa6: fullAdder PORT MAP(aIn(6), bIn(6), carry6, f(6), carry7);
  fa7: fullAdder PORT MAP(aIn(7), bIn(7), carry7, f(7), carry8);
  fa8: fullAdder PORT MAP(aIn(8), bIn(8), carry8, f(8), carry9);
  fa9: fullAdder PORT MAP(aIn(9), bIn(9), carry9, f(9), carry10);
  fa10: fullAdder PORT MAP(aIn(10), bIn(10), carry10, f(10), carry11);
  fa11: fullAdder PORT MAP(aIn(11), bIn(11), carry11, f(11), carry12);
  fa12: fullAdder PORT MAP(aIn(12), bIn(12), carry12, f(12), carry13);
  fa13: fullAdder PORT MAP(aIn(13), bIn(13), carry13, f(13), carry14);
  fa14: fullAdder PORT MAP(aIn(14), bIn(14), carry14, f(14), carry15);
  fa15: fullAdder PORT MAP(aIn(15), bIn(15), carry15, f(15), carry16);
  fa16: fullAdder PORT MAP(aIn(16), bIn(16), carry16, f(16), carry17);
  fa17: fullAdder PORT MAP(aIn(17), bIn(17), carry17, f(17), carry18);
  fa18: fullAdder PORT MAP(aIn(18), bIn(18), carry18, f(18), carry19);
  fa19: fullAdder PORT MAP(aIn(19), bIn(19), carry19, f(19), carry20);
  fa20: fullAdder PORT MAP(aIn(20), bIn(20), carry20, f(20), carry21);
  fa21: fullAdder PORT MAP(aIn(21), bIn(21), carry21, f(21), carry22);
  fa22: fullAdder PORT MAP(aIn(22), bIn(22), carry22, f(22), carry23);
  fa23: fullAdder PORT MAP(aIn(23), bIn(23), carry23, f(23), carry24);
  fa24: fullAdder PORT MAP(aIn(24), bIn(24), carry24, f(24), carry25);
  fa25: fullAdder PORT MAP(aIn(25), bIn(25), carry25, f(25), carry26);
  fa26: fullAdder PORT MAP(aIn(26), bIn(26), carry26, f(26), carry27);
  fa27: fullAdder PORT MAP(aIn(27), bIn(27), carry27, f(27), carry28);
  fa28: fullAdder PORT MAP(aIn(28), bIn(28), carry28, f(28), carry29);
  fa29: fullAdder PORT MAP(aIn(29), bIn(29), carry29, f(29), carry30);
  fa30: fullAdder PORT MAP(aIn(30), bIn(30), carry30, f(30), carry31);
  fa31: fullAdder PORT MAP(aIn(31), bIn(31), carry31, f(31), carry32);
  c30 <= carry31;
  c31 <= carry32;
END behaviour;
