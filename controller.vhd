LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY controller IS
	GENERIC (
		DATA_WIDTH : INTEGER := 16;
		ADDR_WIDTH : INTEGER := 4
	);

	PORT (
		reset : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ALUz, ALUeq, ALUgt : IN STD_LOGIC;
		Instr_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		RFwa : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
		RFwe : OUT STD_LOGIC;
		OPr1a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
		OPr1e : OUT STD_LOGIC;
		OPr2a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
		OPr2e : OUT STD_LOGIC;
		ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		IRld : OUT STD_LOGIC;
		PCinc : OUT STD_LOGIC;
		PCclr : OUT STD_LOGIC;
		PCld : OUT STD_LOGIC;
		addr_Ms : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		Mre : OUT STD_LOGIC;
		Mwe : OUT STD_LOGIC

	);
END controller;

ARCHITECTURE controller OF controller IS
	TYPE state_type IS (RESET_S, FETCH, Load_IR, Increase_PC, DECODE, MOV1, MOV1a, MOV2, MOV2a,
		MOV3, MOV3a, MOV4, MOV4a, ADD, ADDa, SUB, SUBa,
		OR_S, OR_Sa, AND_S, AND_Sa, JPZ, JPZa, JMP, JMPa, JMPb, NOPE);
	SIGNAL state : state_type;
	SIGNAL rn, rm, OPCODE : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	rn <= Instr_in(11 DOWNTO 8);
	rm <= Instr_in(7 DOWNTO 4);
	OPCODE <= INSTR_in(15 DOWNTO 12);

	NSL : PROCESS (clk, reset, OPCODE) --chuyen cac trang thai
	BEGIN
		IF reset = '1' THEN
			state <= RESET_S;
			ELSIF clk'event AND clk = '1' THEN
			CASE state IS
				WHEN RESET_S =>
					state <= FETCH;
				WHEN FETCH =>
					state <= Load_IR;
				WHEN Load_IR =>
					state <= Increase_PC;
				WHEN Increase_PC =>
					state <= DECODE;
				WHEN DECODE =>
					CASE OPCODE IS
						WHEN "0000" =>
							state <= MOV1;
						WHEN "0001" =>
							state <= MOV2;
						WHEN "0010" =>
							state <= MOV3;
						WHEN "0011" =>
							state <= MOV4;
						WHEN "0100" =>
							state <= ADD;
						WHEN "0101" =>
							state <= SUB;
						WHEN "0110" =>
							state <= JPZ;
						WHEN "0111" =>
							state <= OR_S;
						WHEN "1000" =>
							state <= AND_S;
						WHEN "1001" => state <= JMP;
							--when "1001"=>
							--     state <= JMP;
						WHEN OTHERS => state <= NOPE;
					END CASE;
				WHEN MOV1 =>

					state <= MOV1a;
				WHEN MOV1a =>

					state <= FETCH;
				WHEN MOV2 =>

					state <= MOV2a;
				WHEN MOV2a =>

					state <= FETCH;
				WHEN MOV3 =>
					state <= MOV3a;
				WHEN MOV3a =>
					state <= FETCH;
				WHEN MOV4 =>

					state <= FETCH;
				WHEN ADD =>

					state <= ADDa;
				WHEN ADDa =>

					state <= FETCH;
				WHEN SUB =>

					state <= SUBa;
				WHEN SUBa =>
					state <= FETCH;

				WHEN JPZ =>
					state <= JPZa;
				WHEN JPZa =>
					state <= FETCH;
				WHEN OR_S =>

					state <= OR_Sa;

				WHEN OR_Sa =>
					state <= FETCH;

				WHEN AND_S =>

					state <= AND_Sa;
				WHEN AND_Sa =>
					state <= FETCH;
                                when JMP =>
                                        state <= FETCH;


				WHEN OTHERS => State <= FETCH;
			END CASE;
		END IF;
	END PROCESS;
	-- -- lenh cho PC
	PCClr <= '1' WHEN (State = RESET_S) ELSE '0';
	PCinc <= '1' WHEN (State = Increase_PC) ELSE '0';
	--PCLd <= ALUz WHEN (State = JPZa) ELSE '0';
        WITH State Select 
        PCLd <= ALUz WHEN JPZa,
               '1' WHEN JMP,
                '0' WHEN others ;
	-- lenh cho IR
	IRld <= '1' WHEN (state = Load_IR) ELSE '0';
	-- Address slect
	WITH State SELECT
	addr_Ms <= "10" WHEN Fetch,
	"01" WHEN MOV1 | MOV2a,
	"00" WHEN MOV3a,
	"11" WHEN OTHERS;
	WITH State SELECT
	Mre <= '1' WHEN Fetch | MOV1,
	'0' WHEN OTHERS;
	WITH State SELECT
	Mwe <= '1' WHEN MOV2a | MOV3a,
	'0' WHEN OTHERS;
	-- Write RF
	WITH State SELECT
	RFs <= "10" WHEN MOV1a,
	"01" WHEN MOv4,
	"00" WHEN ADDa | SUBa | OR_S,
	"11" WHEN OTHERS;
	WITH State SELECT
	RFwe <= '1' WHEN MOV1a | MOv4 | ADDa | SUBa | OR_Sa | AND_Sa,
	'0' WHEN OTHERS;
	WITH State SELECT
	RFwa <= rn WHEN MOV1a | MOv4 | ADDa | SUBa | OR_Sa | AND_Sa,
	"0000" WHEN OTHERS;
	WITH State SELECT
	OPr1e <= '1' WHEN MOV2 | MOV3 | ADD | SUB | JPZ | OR_S | AND_S,
	'0' WHEN OTHERS;
	WITH State SELECT
	OPr1a <= rn WHEN MOV2 | MOV3 | ADD | SUB | JPZ | OR_S | AND_S,
	"0000" WHEN OTHERS;
	WITH State SELECT
	OPr2e <= '1' WHEN MOV3 | ADD | SUB | OR_S | AND_S,
	'0'WHEN OTHERS;
	WITH State SELECT
	OPr2a <= rm WHEN MOV3 | ADD | SUB | OR_S | AND_S,
	"0000" WHEN OTHERS;
	WITH State SELECT
	ALUs <= "00" WHEN ADD | ADDa,
	"01" WHEN SUB | SUBa,
	"10" WHEN OR_S,
	"11" WHEN OTHERS;
END controller;
