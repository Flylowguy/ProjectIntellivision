LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY controlUnit IS

  PORT(
    opCode :IN std_logic_vector(4 DOWNTO 0);
    cond :IN std_logic_vector(3 DOWNTO 0);
    opx :IN std_logic_vector(6 DOWNTO 0);
    S,N,C,V,Z,mfc,clock,reset :IN std_logic;
    alu_op, c_select, y_select, extend :OUT std_logic_vector(1 DOWNTO 0);
    rf_write, b_select, a_inv, b_inv, ir_enable, ma_select, mem_read, mem_write, pc_select, pc_enable, inc_select, dumbSel, ps_enable :OUT std_logic
  );

END controlUnit;

ARCHITECTURE behavior OF controlUnit IS
    signal wmfc, condBool: std_logic;
    shared variable stage: integer:= 0;
    BEGIN
    PROCESS(clock, reset)
    BEGIN
      IF(falling_edge(clock)) THEN
        --test conditionals
        condBool <= '0';
        IF(cond = "0000") THEN
          --AL - always
          condBool <= '0';
        ELSIF(cond = "0001") THEN
          --NV - never
          condBool <= '1';
        ELSIF(cond = "0010") THEN
          --EQ - equal
          IF(Z = '0') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "0011") THEN
          --NE - not equal
          IF(Z = '1') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "0100") THEN
          --VS - overflow
          IF(V /= '1') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "0101") THEN
          --VC - no overflow
          IF(V = '1') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "0110") THEN
          --MI - negative
          IF(N = '0') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "0111") THEN
          --PL - Positive or Zero
          IF(N = '1') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1000") THEN
          --CS - unsigned higher or same
          IF(C = '0') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1001") THEN
          --CC - unsigned lower
          IF(C = '1') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1010") THEN
          --HI - UNSIGNED higher
          IF(C = '0' and Z = '1') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1011") THEN
          --LS - unsigned lower or same
          IF(C = '1' OR Z = '0') THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1100") THEN
          --gt - greater than
          IF(Z = '1' AND ((N = '0' AND V = '0') OR (N = '1' AND V = '1'))) THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1101") THEN
          --lt - less than
          IF((N = '0' AND V = '1') OR (Z = '1' AND V = '0')) THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1110") THEN
          --ge - Greater than or equal
          IF((N = '0' AND V = '0') OR (N = '1' AND V = '1')) THEN
            condBool <= '1';
          END IF;
        ELSIF(cond = "1111") THEN
          --le - less than or equal
          IF(Z = '0' OR ((N = '0' AND V = '1') OR (Z = '1' AND V = '1'))) THEN
            condBool <= '1';
          END IF;
        END IF;
      END IF;
      IF(rising_edge(clock)) THEN
        IF(reset = '1') THEN
          stage := 0;
        END IF;
        IF((mfc = '1' or wmfc = '0')) THEN
          stage := (stage mod 5) + 1;
        END IF;
        IF(stage = 1) THEN
			 ma_select <= '1';
			 dumbSel <= '0';
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
          mem_read <= '1';
          mem_write <= '0';
          pc_select <= '1';
          pc_enable <= mfc;
          inc_select <= '0';
          ps_enable <= '0';
        ELSIF(stage = 2) THEN
          wmfc <= '0';
          ir_enable <= '0';
          mem_read <= '0';
          pc_enable <= '0';
        ELSIF(stage = 3 and condBool = '0') THEN
          IF(S = '1') THEN
            ps_enable <= '1';
          END IF;
          IF(opCode = "00000" or opCode = "00100" or opCode = "00101" or opCode = "00110") THEN
          --D-Type instructions:
            IF(opCode(2) = '1' and opCode(1) = '1' and opCode(0) = '0') THEN
              --jr
              pc_select <= '0';
              pc_enable <= '1';
            ELSIF(opcode(2) = '1' and opCode(1) = '0' and opCode(0) = '1') THEN
              --cmp
              b_inv <= '1';
              alu_op <= "00";
              ps_enable <= '1';
            ELSIF(opCode(2) = '1' and opCode(1) = '0' and opCode(0) = '0') THEN
              --sll
            ELSIF(OpCode(2) = '0' and opCode(1) = '0' and opCode(0) = '0') THEN
              --alu operations:
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
          ELSIF(opCode = "00111" or opCode = "01001" or opCode = "01000" or opCode = "01010") THEN
          --D-Type instructions:
            IF(opCode = "01000") THEN
            --addi
              alu_op <= "00";
              b_select <= '1';
              b_inv <= '0';
              extend <= "01";
            ELSIF(opCode = "00111" or opCode = "01001" or opCode = "01010") THEN
            --lw, sw, si
              alu_op <= "00";
              b_select <= '1';
              b_inv <= '0';
              extend <= "00";
              pc_enable <= '0';
            END IF;
          ELSIF(opCode = "01011" or opCode = "01100") THEN
          --B-Type instructions:
            inc_select <= '1';
            pc_enable <= '1';
            alu_op <= "00";
            b_select <= '1';
          ELSIF(opCode = "01101" or opCode = "01110" or opCode = "01111") THEN
          --J-Type instructions:

          END IF;
        ELSIF(stage = 4 and condBool = '0') THEN
          ps_enable <= '0';
          IF(opCode = "00111") THEN
          --lw
          y_select <= "01";
          ma_select <= '0';
          mem_read <= '1';
          ELSIF(opCode = "01001") THEN
          --sw
          mem_write <= '1';
          ma_select <= '0';
          pc_enable <= '0';
          ELSIF(opCode = "01011") THEN
          --b
          pc_enable <= '0';
          ELSIF(opCode = "01100") THEN
          --bal
          pc_enable <= '0';
          y_select <= "10";
          ELSIF(opCode = "00110") THEN
          --jr
          pc_enable <= '1';
          pc_select <= '0';
          END IF;
        ELSIF(stage = 5  and condBool = '0') THEN
				ma_select <= '1';
          IF(opCode = "00000") THEN
          --R-Type
          rf_write <= '1';
          ELSIF(opCode = "01000") THEN
          --Addi, lw
          rf_write <= '1';
          c_select <= "10";
          mem_read <= '0';
			 ELSIF(opCode = "00111") THEN
			 rf_write <= '1';
          c_select <= "10";
          mem_read <= '0';
			 dumbSel <= '1';
          ELSIF(opCode = "01001") THEN
          --sw
          rf_write <= '0';
          mem_write <= '0';
          c_select <= "10";

          ELSIF(opCode = "01100") THEN
          --bal
          rf_write <= '1';
          c_select <= "00";
          END IF;
        END IF;
      END IF;
    END PROCESS;
END behavior;
