LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY program_counter IS
	PORT (
		clk : IN STD_LOGIC;
		PCclr : IN STD_LOGIC;
		PCinc : IN STD_LOGIC;
		PCld : IN STD_LOGIC;

		PCd_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		PCd_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END program_counter;

ARCHITECTURE behav OF program_counter IS
	SIGNAL data : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
	PROCESS (clk, PCclr)
	BEGIN
		IF (PCclr = '1') THEN
			data <= X"0000";
		ELSIF (clk = '1'AND clk'event) THEN
			IF (PCld = '1') THEN
				data <= X"00" & PCd_in;
			END IF;
			IF (PCinc = '1') THEN
				data <= data + "1";
			END IF;
		END IF;
	END PROCESS;
	PCd_out <= data;

END behav;
