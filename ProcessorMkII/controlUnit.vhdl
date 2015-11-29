LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY controlUnit IS

  PORT(
    opCode :IN std_logic_vector(4 DOWNTO 0);
    cond :IN std_logic_vector(3 DOWNTO 0);
    opx :IN std_logic_vector(6 DOWNTO 0);
    S,N,C,V,Z,mfc,clock,reset :IN std_logic;
    alu_op, c_select, y_select, extend :OUT std_logic_vector(1 DOWNTO 0);
    rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select :OUT std_logic
  );

END controlUnit;

ARCHITECTURE behavior OF controlUnit IS
    signal wmfc: std_logic;
    shared variable stage: integer:= 0;
    BEGIN
    PROCESS(clock, reset)
    BEGIN
      IF(rising_edge(clock)) THEN
        IF(reset = '1') THEN
          stage := 0;
        END IF;
        IF((mfc = '1' or wmfc = '0')) THEN
          stage := (stage mod 5) + 1;
        END IF;
        IF(stage = 1) THEN
          wmfc <= '1';
          alu_op <= "00";
          c_select <= "01";
          y_select <= "00";
          rf_write <= '0';
          b_select <= '0';
          a_inv <= '0';
          b_inv <= '0';
          extend <= "00";
          ir_enable <= '1';
          ma_select <= '1';
          mem_read <= '1';
          mem_write <= '0';
          pc_select <= '1';
          pc_enable <= mfc;
          inc_select <= '0';
        ELSIF(stage = 2) THEN
          wmfc <= '0';
          ir_enable <= '0';
          mem_read <= '0';
          pc_enable <= '0';
        ELSIF(stage = 3) THEN
          IF(opCode(4) = '0' and opCode(3) = '0') THEN
            IF(opCode(2) = '1' and opCode(1) = '1' and opCode(0) = '0') THEN
              --this is the jr operation
            ELSIF(opcode(2) = '1' and opCode(1) = '0' and opCode(0) = '1') THEN
              --this is the cmp operation
            ELSIF(opCode(2) = '1' and opCode(1) = '0' and opCode(0) = '0') THEN
              --this is the sll operation
            ELSIF(OpCode(2) = '0' and opCode(1) = '0' and opCode(0) = '0') THEN
              --this is the alu operations
              IF(opx = "0000000") THEN
                --add
                alu_op <= "00";
              ELSIF(opx = "0000001") THEN
                --sub
                b_inv <= '1';
                alu_op <= "00";

              ELSIF(opx = "0000011") THEN
                --and
                alu_op <= "11";
              ELSIF(opx="0000010") THEN
                --or
                alu_op <= "10";
              ELSIF(opx = "0000100") THEN
                --xor
                alu_op <= "01";
              END IF;
            END IF;
          END IF;
        ELSIF(stage = 4) THEN
          IF(opCode(4) = '0' and opCode(3) = '0') THEN
            IF(opCode(2) = '1' and opCode(1) = '1' and opCode(0) = '0') THEN
              --some stuff for jr
            END IF;
          END IF;

        ELSIF(stage = 5) THEN
          IF(opCode(4) = '0' and opCode(3) = '0') THEN
            IF(opCode(2) = '1' and opCode(1) = '1' and opCode(0) = '0') THEN
              --some stuff for jr
            ELSIF(opCode(2) = '0' and opCode(1) = '0' and opCode(0) = '0') THEN
              rf_write <= '1';
            END IF;
          END IF;
        END IF;
      END IF;
    END PROCESS;
END behavior;
