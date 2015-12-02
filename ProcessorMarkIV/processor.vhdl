LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY processor IS
  PORT(
  clock       :IN std_logic;
  reset       :IN std_logic;
  ryOut          :OUT std_logic_vector(31 DOWNTO 0);
  raOut    :OUT std_logic_vector(31 DOWNTO 0);
  rbOut    :OUT std_logic_vector(31 DOWNTO 0);
  rzOut,muxbout,pcoutput,instructionout,muxMaSelectOutput,rmOutput   :OUT std_logic_vector(31 DOWNTO 0);
  mem_writeOut,ma_selectOut,muxBSelectOutput,rfWriteOutput    :OUT std_logic;
  psOutput :OUT std_logic_vector(3 downto 0)

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
COMPONENT BuffReg4
	PORT(
		data									:IN std_logic_vector(3 downto 0);
		reset, Clock						:IN std_logic;
		output								:OUT std_logic_vector(3 downto 0)
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
COMPONENT rcAdder
  PORT(
    aIn :IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    bIn :IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    cIn :IN STD_LOGIC;
    f   :OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    c30, c31  :OUT STD_LOGIC
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
COMPONENT immediate12to32
	port(immed: in std_logic_vector(11 downto 0);
		 extend: in std_logic_vector(1 downto 0);
		 immedEx: out std_logic_vector(31 downto 0)
     );
end COMPONENT;
COMPONENT controlUnit
  PORT(
    opCode                              :IN std_logic_vector(4 DOWNTO 0);
    cond                                :IN std_logic_vector(3 DOWNTO 0);
    opx                                 :IN std_logic_vector(6 DOWNTO 0);
    S, N, C, V, Z, mfc, clock, reset    :IN std_logic;
    alu_op, c_select, y_select, extend  :OUT std_logic_vector(1 DOWNTO 0);
    rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select,dumbSel,ps_enable :OUT std_logic
  );
END COMPONENT;
COMPONENT mux3
  PORT(
    d0,d1,d2	:IN std_logic_vector(31 DOWNTO 0);
    sel				:IN std_logic_vector(1 DOWNTO 0);
    f					:OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT mux3by5
  PORT(
    d0,d1,d2	:IN std_logic_vector(4 DOWNTO 0);
    sel				:IN std_logic_vector(1 DOWNTO 0);
    f					:OUT std_logic_vector(4 DOWNTO 0)
  );
END COMPONENT;
COMPONENT mux2
  PORT(
    d0,d1	:IN std_logic_vector(31 DOWNTO 0);
    sel		:IN std_logic;
    f			:OUT std_logic_vector(31 DOWNTO 0)
  );
END COMPONENT;
COMPONENT immediate23to32
	port(immed: in std_logic_vector(22 downto 0);
		 extend: in std_logic_vector(1 downto 0);
		 immedEx: out std_logic_vector(31 downto 0));
end COMPONENT;
COMPONENT memory
PORT
(
  address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
  clock		: IN STD_LOGIC  := '1';
  data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
  wren		: IN STD_LOGIC ;
  q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);
END COMPONENT;
COMPONENT reg32
	PORT(
		data									:IN std_logic_vector(31 downto 0);
		enable, reset, Clock				:IN std_logic;
		output								:OUT std_logic_vector(31 downto 0)
	);
END COMPONENT;

SIGNAL rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select, c, n, v, z, c30, c31 :std_logic;
SIGNAL aluOP, c_select, y_select, extend :std_logic_vector(1 downto 0);
SIGNAL MuxCOutput :std_logic_vector(4 DOWNTO 0);
SIGNAL RZOutput, RAOutput, RBOutput, MuxBOutput, dataS, dataT, ZEROS, aluOut, MuxYOutput, RYOutput, instruction, immediate1s, immediate2s, muxIncOut, pcAdderOut, pcOut, pcIn, muxMaSelectOut, rmOut, memoryOut,pcTempOut :std_logic_vector(31 downto 0);
SIGNAL psOut :std_logic_vector(3 downto 0);
SIGNAL regDataIN : STD_LOGIC_VECTOR(31 downto 0);
SIGNAL dumbSelect,ps_enable : STD_LOGIC;
BEGIN

  ZEROS <= (OTHERS =>'0');

  ir: IR32 PORT MAP(memoryOut, ir_enable, reset, (clock), instruction);

  control: controlUnit PORT MAP(instruction(4 DOWNTO 0), "0000", instruction(16 DOWNTO 10), instruction(9), psOut(2), psOut(3), psOut(1), psOut(0), '1', clock, reset, aluOP, c_select, y_select, extend, rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select, dumbSelect,ps_enable);

  dumbMux: mux2 PORT MAP(RYOutput, memoryOut, dumbSelect, regDataIn);

  rf: regFile PORT MAP(reset, rf_write, clock, MuxCOutput, instruction(26 DOWNTO 22), instruction(31 DOWNTO 27), regDataIn, dataS, dataT);

  MuxC: mux3by5 PORT MAP("11110", instruction(21 DOWNTO 17), instruction(26 DOWNTO 22), c_select, MuxCOutput);

  RA: BuffReg32 PORT MAP(dataS, reset, clock, RAOutput);
  RB: BuffReg32 PORT MAP(dataT, reset, clock, RBOutput);

  immediate1: immediate12to32 PORT MAP(instruction(21 downto 10), extend, immediate1s);

--second input should be all zeroes as there is no immediate value in r type
  MuxB: mux2 PORT MAP(RBOutput, immediate1s, b_select, MuxBOutput);

  aluInstance: ALU PORT MAP(a_inv, b_inv, RAOutput, aluOp, MuxBOutput, ZEROS, c, n, v, z, aluOut);

  RZ: BuffReg32 PORT MAP(aluOut, reset, clock, RZOutput);

  MuxY: mux3 PORT MAP(RZOutput, memoryOut, pcTempOut, y_select, MuxYOutput);

  RY: BuffReg32 PORT MAP(MuxYOutput, reset, clock, RYOutput);

  immediate2: immediate23to32 PORT MAP(instruction(31 downto 9), extend, immediate2s);

  muxInc: mux2 PORT MAP("00000000000000000000000000000001", immediate2s, inc_select, muxIncOut);

  pcAdder: rcAdder PORT MAP(pcOut, muxIncOut, '0', pcAdderOut, c30, c31);

  muxPC: mux2 PORT MAP(RAOutput, pcAdderOut, pc_select, pcIn);

  pc: reg32 PORT MAP(pcIn, pc_enable, reset, clock, pcOut);

  muxMaSelect: mux2 PORT MAP(RZOutput, pcOut, ma_select, muxMaSelectOut);

  ps: BuffReg4 PORT MAP(c & n & v & z, ps_enable, clock, psOut);

  RM: BuffReg32 PORT MAP(RBOutput, reset, clock, rmOut);

  mainMemory: memory PORT MAP(muxMaSelectOut(9 downto 0), NOT clock, rmOut, mem_write, memoryOut);

  pcTemp: BuffReg32 PORT MAP(pcOut, reset, clock, pcTempOut);


  ryOut <= ryOutput;
  raOut <= RAOutput;
  rbOut <= RBOutput;
  rzOut <= RZOutput;
  muxBOut <= MuxBOutput;
  pcOutput <= pcOut;
  instructionOut <= instruction;
  mem_writeOut <= mem_write;
  ma_selectOut <= ma_select;
  muxMaSelectOutput <= muxMaSelectOut;
  rmOutput <= rmOut;
  psOutput <= psOut;
  rfwriteOutput <= rf_write;


END behaviour;
