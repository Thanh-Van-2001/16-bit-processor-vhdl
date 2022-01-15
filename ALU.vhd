LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALU IS
	GENERIC (DATA_WIDTH : INTEGER := 16);
	PORT (
		OPr1 : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		OPr2 : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		ALUs : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		ALUr : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		ALUz : OUT STD_LOGIC;
		ALUeq : OUT STD_LOGIC;
		ALUgt : OUT STD_LOGIC
	);
END
ALU;
ARCHITECTURE ALU OF ALU IS
	SIGNAL result : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
	PROCESS (ALUs, Opr1, Opr2)
	BEGIN
		CASE(ALUs) IS
			WHEN "00" => -- Add
			result <= OPr1 + OPr2;
			WHEN "01" => -- Sub
			result <= OPr1 - OPr2;
			WHEN "10" =>
			result <= OPr1 OR OPr2;
			WHEN "11" =>
			result <= OPr1 AND OPr2;

			WHEN OTHERS => -- Preset
			result <= (OTHERS => '1');
		END CASE;
	END PROCESS;
	ALUr <= result;
	ALUz <= '1' WHEN OPr1 = x"0000" ELSE '0';
	ALUeq <= '1' WHEN OPr1 = OPr2 ELSE '0';
	ALugt <= '1' WHEN OPr1 > OPr2 ELSE '0';
END
ALU;
