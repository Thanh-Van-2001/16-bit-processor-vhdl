LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--vopt +acc cpu_tb -o cpu_tb_opt
ENTITY register_file IS
	GENERIC (
		DATA_WIDTH : INTEGER := 16;
		ADDR_WIDTH : INTEGER := 4
	);
	PORT (
		reset : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		RFin : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
		RFwa : IN STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
		RFwe : IN STD_LOGIC;
		OPr1a : IN STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
		OPr1e : IN STD_LOGIC;
		OPr2a : IN STD_LOGIC_VECTOR (ADDR_WIDTH - 1 DOWNTO 0);
		OPr2e : IN STD_LOGIC;
		OPr1 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
		OPr2 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
	);
END register_file;
ARCHITECTURE register_file OF register_file IS
	TYPE DATA_ARRAY IS ARRAY (INTEGER RANGE <>) OF STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
	SIGNAL RF : DATA_ARRAY(0 TO 15) := (OTHERS => (OTHERS => '0'));
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			-- 
			OPr1 <= (OTHERS => '0');
			OPr2 <= (OTHERS => '0');
			RF <= (OTHERS => (OTHERS => '0'));
			-- 
			ELSIF clk'event AND clk = '1' THEN
			IF RFwe = '1' THEN
				RF(conv_integer(RFwa)) <= RFin;
			END IF;
			--
			IF OPr1e = '1' THEN
				OPr1 <= RF(conv_integer(OPr1a));
			END IF;
			--
			IF OPr2e = '1' THEN
				OPr2 <= RF(conv_integer(OPr2a));
			END IF;
		END IF;
	END PROCESS;
END register_file;
