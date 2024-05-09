LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY LFSR IS
	PORT(clk, enable: IN STD_LOGIC;
			rnd: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			flag: OUT STD_LOGIC);
END ENTITY LFSR;

ARCHITECTURE behaviour OF LFSR IS
	SIGNAL level_easy_reg: STD_LOGIC_VECTOR(7 DOWNTO 0):="00000001";
	
BEGIN
	PROCESS(clk, enable)
		VARIABLE feedback: STD_LOGIC;
	BEGIN
		IF RISING_EDGE(clk) THEN
			feedback:= level_easy_reg(7) XOR level_easy_reg(5) XOR level_easy_reg(4) XOR level_easy_reg(0);
			level_easy_reg <= feedback & level_easy_reg(6 DOWNTO 0);
		END IF;
	END PROCESS;
	
	rnd <= (("00" & level_easy_reg) + CONV_STD_LOGIC_VECTOR(100, 10));
	flag <= '1' WHEN enable = '1' ELSE '0';
END ARCHITECTURE;