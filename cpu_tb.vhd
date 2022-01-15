LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY cpu_tb IS
END cpu_tb;

ARCHITECTURE behav OF cpu_tb IS
	COMPONENT cpu
		PORT (
			clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			address_cpu : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

			Mre_cpu : OUT STD_LOGIC;
			Mwe_cpu : OUT STD_LOGIC;

			data_out_mem_t : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_in_mem_t : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;

	CONSTANT clk_period : TIME := 15 ns;

	SIGNAL clk : STD_LOGIC := '1';
	SIGNAL reset : STD_LOGIC := '1';
	SIGNAL address_cpu : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Mre_cpu : STD_LOGIC;
	SIGNAL Mwe_cpu : STD_LOGIC;
	SIGNAL data_out_mem_t : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL data_in_mem_t : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

	clk <= NOT clk AFTER clk_period / 2;

	DUT : ENTITY work.cpu
		PORT MAP(clk, reset, address_cpu, Mre_cpu, Mwe_cpu, data_out_mem_t, data_in_mem_t);

	PROCESS
	BEGIN
		reset <= '1';
		WAIT FOR clk_period * 2;

		reset <= '0';
		WAIT FOR clk_period * 110;
	END PROCESS;

END behav;
