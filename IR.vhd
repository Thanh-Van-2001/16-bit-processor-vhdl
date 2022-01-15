LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY instruction_register IS
	GENERIC (DATA_WIDTH : INTEGER := 16);
	PORT (
		clk : IN STD_LOGIC;
		IRld : IN STD_LOGIC;
		IRin : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
		IRout : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
	);
END instruction_register;

ARCHITECTURE behav OF instruction_register IS
	SIGNAL data : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
BEGIN
	PROCESS (clk)
	BEGIN
		IF (clk = '1' AND clk'event) THEN
			IF (IRld = '1') THEN
				data <= IRin;
			END IF;
		END IF;
	END PROCESS;
	IRout <= data;
END behav;
