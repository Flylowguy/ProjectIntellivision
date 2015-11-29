LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY processor IS
  PORT(
  instructionIn :IN std_logic_vector(31 DOWNTO 0);
  clock       :IN std_logic;
  reset       :IN std_logic;
  ryOut          :OUT std_logic_vector(31 DOWNTO 0);
  raOut    :OUT std_logic_vector(31 DOWNTO 0);
  rbOut    :OUT std_logic_vector(31 DOWNTO 0);
  rzOut    :OUT std_logic_vector(31 DOWNTO 0);
  bInvOut, rfWriteOut   :OUT std_logic

);
END processor;

ARCHITECTURE behaviour OF processor IS
COMPONENT ALU
  PORT(
		a_inv   :IN  STD_LOGIC;
		b_inv   :IN  STD_LOGIC;
		A       :IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		alu_op  :IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		B       :IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		ZEROIN  :IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		C       :OUT  STD_LOGIC;
		N       :OUT  STD_LOGIC;
		V       :OUT  STD_LOGIC;
		Z       :OUT  STD_LOGIC;
		fOut    :OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;
COMPONENT regFile
  PORT(
    reset, enable, clock  :IN std_logic;
    regD, regT, regS      :IN std_logic_vector (4 DOWNTO 0);
    dataD                 :IN std_logic_vector(31 DOWNTO 0);
    dataS, dataT          :OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT BuffReg32
  PORT(
    data					:IN std_logic_vector(31 DOWNTO 0);
    reset, Clock  :IN std_logic;
    output				:OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT IR32
  PORT(
    data									:IN std_logic_vector(31 DOWNTO 0);
    enable, reset, Clock	:IN std_logic;
    output								:OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT immediate
  PORT(
    immed     :IN std_logic_vector(6 DOWNTO 0);
    extend    :IN std_logic_vector(1 DOWNTO 0);
    immedEx   :OUT std_logic_vector(15 DOWNTO 0)
  );
END COMPONENT;
COMPONENT controlUnit
  PORT(
    opCode                              :IN std_logic_vector(4 DOWNTO 0);
    cond                                :IN std_logic_vector(3 DOWNTO 0);
    opx                                 :IN std_logic_vector(6 DOWNTO 0);
    S, N, C, V, Z, mfc, clock, reset    :IN std_logic;
    alu_op, c_select, y_select, extend  :OUT std_logic_vector(1 DOWNTO 0);
    rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select :OUT std_logic
  );
END COMPONENT;
COMPONENT mux3
  PORT(
    d0,d1,d2	:IN std_logic_vector(31 DOWNTO 0);
    sel				:IN std_logic_vector(1 DOWNTO 0);
    f					:OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT mux2
  PORT(
    d0,d1	:IN std_logic_vector(31 DOWNTO 0);
    sel		:IN std_logic;
    f			:OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT;
SIGNAL rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select, c, n, v, z :std_logic;
SIGNAL aluOP, c_select, y_select, extend :std_logic_vector(1 downto 0);
SIGNAL RZOutput, RAOutput, RBOutput, MuxBOutput, dataS, dataT, ZEROS, aluOut, MuxYOutput, RYOutput, instruction :std_logic_vector(31 downto 0);
BEGIN

  ZEROS <= (OTHERS =>'0');

  ir: IR32 PORT MAP(instructionIn, ir_enable, reset, clock, instruction);

  control: controlUnit PORT MAP(instruction(4 DOWNTO 0), "0000", instruction(16 DOWNTO 10), instruction(9), '0', '0', '0', '0', '1', clock, reset, aluOP, c_select, y_select, extend, rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select);

  rf: regFile PORT MAP(reset, rf_write, clock, instruction(21 DOWNTO 17), instruction(26 DOWNTO 22), instruction(31 DOWNTO 27), RYOutput, dataS, dataT);

  RA: BuffReg32 PORT MAP(dataS, reset, clock, RAOutput);
  RB: BuffReg32 PORT MAP(dataT, reset, clock, RBOutput);

--second input should be all zeroes as there is no immediate value in r type
  MuxB: mux2 PORT MAP(RBOutput, ZEROS , b_select, MuxBOutput);

  aluInstance: ALU PORT MAP(a_inv, b_inv, RAOutput, aluOp, MuxBOutput, ZEROS, c, n, v, z, aluOut);

  RZ: BuffReg32 PORT MAP(aluOut, reset, clock, RZOutput);

  MuxY: mux3 PORT MAP(RZOutput, ZEROS, ZEROS, y_select, MuxYOutput);

  RY: BuffReg32 PORT MAP(MuxYOutput, reset, clock, RYOutput);

  ryOut <= RYOutput;
  raOut <= RAOutput;
  rbOut <= RBOutput;
  rzOut <= RZOutput;
  bInvOut <= b_inv;
  rfWriteOut <= rf_write;



END behaviour;
