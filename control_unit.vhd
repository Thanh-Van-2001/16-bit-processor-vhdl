LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY control_unit IS
	GENERIC (
		ADDR_WIDTH : INTEGER := 4;
		DATA_WIDTH : INTEGER := 16);
	PORT (
		reset : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		ALUz : IN STD_LOGIC;
		ALUeq : IN STD_LOGIC;
		ALUgt : IN STD_LOGIC;

		addr_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		ir_data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

		RFs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		RFwa : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
		RFwe : OUT STD_LOGIC;
		OPr1a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
		OPr1e : OUT STD_LOGIC;
		OPr2a : OUT STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
		OPr2e : OUT STD_LOGIC;
		ALUs : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

		ADDR : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		Mre : OUT STD_LOGIC;
		Mwe : OUT STD_LOGIC;
		imm : OUT STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
		op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)

	);
END control_unit;

ARCHITECTURE behav OF control_unit IS

	COMPONENT controller
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
	END COMPONENT;

	COMPONENT instruction_register
		PORT (
			clk : IN STD_LOGIC;
			IRld : IN STD_LOGIC;
			IRin : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			IRout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT program_counter
		PORT (

			clk : IN STD_LOGIC;
			PCclr : IN STD_LOGIC;
			PCinc : IN STD_LOGIC;
			PCld : IN STD_LOGIC;
			PCd_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			PCd_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	COMPONENT mux4to1
		GENERIC (DATA_WIDTH : INTEGER := 16);

		PORT (
			data_in_mux0, data_in_mux1, data_in_mux2, data_in_mux3 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
			SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			Z : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
		);
	END COMPONENT;

	--signal  Instr_in : std_logic_vector(15 downto 0);
	SIGNAL IRout : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IRout_7_to_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IRout_mux : STD_LOGIC_VECTOR(15 DOWNTO 0);
	-- tin hieu cho pc va ir
	SIGNAL PCout : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IRld : STD_LOGIC;
	SIGNAL PCinc : STD_LOGIC;
	SIGNAL PCclr : STD_LOGIC;
	SIGNAL PCld : STD_LOGIC;
	SIGNAL addr_Ms : STD_LOGIC_VECTOR(1 DOWNTO 0);

	SIGNAL data_in_mux3_map : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0) := x"0000";

BEGIN
	ctrl : controller
	PORT MAP(
		reset, clk, ALUz, ALUeq, ALUgt, IRout, RFs,
		RFwa, RFwe, OPr1a, OPr1e, OPr2a, OPr2e, ALUs, IRld,
		PCinc, PCclr, PCld, addr_Ms, Mre, Mwe);

	pc : program_counter
	PORT MAP(clk, PCclr, PCinc, PCld, IRout_7_to_0, PCout);

	ir : instruction_register
	PORT MAP(clk, IRld, ir_data_in, IRout);

	mux : mux4to1
	PORT MAP(addr_in, IRout_mux, PCout, data_in_mux3_map, addr_Ms, ADDR);

	IRout_7_to_0 <= IRout(7 DOWNTO 0);
	IRout_mux <= x"00" & IRout_7_to_0;
	imm <= IRout_7_to_0;
	op <= IRout(15 DOWNTO 12);
END behav;
