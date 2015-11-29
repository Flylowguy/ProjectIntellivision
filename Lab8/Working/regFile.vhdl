LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regFile IS
	PORT(
		reset, enable, clock :IN std_logic;
    regD, regT, regS :IN std_logic_vector (4 downto 0);
    dataD :IN std_logic_vector(31 downto 0);
    dataS, dataT :OUT std_logic_vector(31 downto 0)
	);
END regFile;

ARCHITECTURE behavior OF regFile IS
  COMPONENT decoder32
    PORT(
    Sel		:IN std_logic_vector(4 downto 0);
    Output :OUT std_logic_vector(31 downto 0)
    );
  END component;
COMPONENT mux32
  PORT(
    d0,d1,d2,d3,d4,d5,d6,d7		:IN std_logic_vector(31 downto 0);
    d8,d9,dA,dB,dC,dD,dE,dF		:IN std_logic_vector(31 downto 0);
    d10,d11,d12,d13,d14,d15,d16,d17		:IN std_logic_vector(31 downto 0);
    d18,d19,d1A,d1B,d1C,d1D,d1E,d1F		:IN std_logic_vector(31 downto 0);
    sel								:IN std_logic_vector(4 downto 0);
    f									:OUT std_logic_vector(31 downto 0)
    );
END component;
COMPONENT reg32
  PORT(
    data									:IN std_logic_vector(31 downto 0);
    enable, reset, Clock				:IN std_logic;
    output								:OUT std_logic_vector(31 downto 0)
    );
END component;
SIGNAL decodeOut : std_logic_vector(31 downto 0);
SIGNAL r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31 : std_logic_vector(31 downto 0);
BEGIN
  decoder: decoder32 PORT MAP(regD, decodeOut);
	r0 <= (OTHERS => '0');
  reg1: reg32 PORT MAP(dataD, enable AND decodeOut(1), reset, Clock, r1);
  reg2: reg32 PORT MAP(dataD, enable AND decodeOut(2), reset, Clock, r2);
  reg3: reg32 PORT MAP(dataD, enable AND decodeOut(3), reset, Clock, r3);
  reg4: reg32 PORT MAP(dataD, enable AND decodeOut(4), reset, Clock, r4);
  reg5: reg32 PORT MAP(dataD, enable AND decodeOut(5), reset, Clock, r5);
  reg6: reg32 PORT MAP(dataD, enable AND decodeOut(6), reset, Clock, r6);
  reg7: reg32 PORT MAP(dataD, enable AND decodeOut(7), reset, Clock, r7);
  reg8: reg32 PORT MAP(dataD, enable AND decodeOut(8), reset, Clock, r8);
  reg9: reg32 PORT MAP(dataD, enable AND decodeOut(9), reset, Clock, r9);
  reg10: reg32 PORT MAP(dataD, enable AND decodeOut(10), reset, Clock, r10);
  reg11: reg32 PORT MAP(dataD, enable AND decodeOut(11), reset, Clock, r11);
  reg12: reg32 PORT MAP(dataD, enable AND decodeOut(12), reset, Clock, r12);
  reg13: reg32 PORT MAP(dataD, enable AND decodeOut(13), reset, Clock, r13);
  reg14: reg32 PORT MAP(dataD, enable AND decodeOut(14), reset, Clock, r14);
  reg15: reg32 PORT MAP(dataD, enable AND decodeOut(15), reset, Clock, r15);
  reg16: reg32 PORT MAP(dataD, enable AND decodeOut(16), reset, Clock, r16);
  reg17: reg32 PORT MAP(dataD, enable AND decodeOut(17), reset, Clock, r17);
  reg18: reg32 PORT MAP(dataD, enable AND decodeOut(18), reset, Clock, r18);
  reg19: reg32 PORT MAP(dataD, enable AND decodeOut(19), reset, Clock, r19);
	reg20: reg32 PORT MAP(dataD, enable AND decodeOut(20), reset, Clock, r20);
	reg21: reg32 PORT MAP(dataD, enable AND decodeOut(21), reset, Clock, r21);
	reg22: reg32 PORT MAP(dataD, enable AND decodeOut(22), reset, Clock, r22);
	reg23: reg32 PORT MAP(dataD, enable AND decodeOut(23), reset, Clock, r23);
	reg24: reg32 PORT MAP(dataD, enable AND decodeOut(24), reset, Clock, r24);
	reg25: reg32 PORT MAP(dataD, enable AND decodeOut(25), reset, Clock, r25);
	reg26: reg32 PORT MAP(dataD, enable AND decodeOut(26), reset, Clock, r26);
	reg27: reg32 PORT MAP(dataD, enable AND decodeOut(27), reset, Clock, r27);
	reg28: reg32 PORT MAP(dataD, enable AND decodeOut(28), reset, Clock, r28);
	reg29: reg32 PORT MAP(dataD, enable AND decodeOut(29), reset, Clock, r29);
	reg30: reg32 PORT MAP(dataD, enable AND decodeOut(30), reset, Clock, r30);
	reg31: reg32 PORT MAP(dataD, enable AND decodeOut(31), reset, Clock, r31);
	mux0:  mux32 PORT MAP(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31, regS, dataS);
	mux1:  mux32 PORT MAP(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, r30, r31, regT, dataT);
END behavior;
