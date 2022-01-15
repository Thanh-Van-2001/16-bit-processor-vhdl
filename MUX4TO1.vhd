LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY mux4to1 IS
	GENERIC (DATA_WIDTH : INTEGER := 16);
	PORT (
		data_in_mux0, data_in_mux1, data_in_mux2, data_in_mux3 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
		SEL : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		Z : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
	);
END mux4to1;

ARCHITECTURE bev OF mux4to1 IS
BEGIN
	WITH sel SELECT
		z <= data_in_mux0 WHEN "00",
		data_in_mux1 WHEN "01",
		data_in_mux2 WHEN "10",
		data_in_mux3 WHEN OTHERS;
END bev;
