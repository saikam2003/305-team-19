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
	-- just a register to store the current random value
	SIGNAL level_easy_reg: STD_LOGIC_VECTOR(7 DOWNTO 0):="00000001";
	
BEGIN
	PROCESS(clk)
		-- feedback variable that will bce concatenated with level_easy_reg to get random values
		VARIABLE feedback: STD_LOGIC;
	BEGIN
		IF RISING_EDGE(clk) THEN
			-- feedback is equal to the primitive polynomial equation for 8 bits
			-- feedback:= level_easy_reg(7) XOR level_easy_reg(5) XOR level_easy_reg(4) XOR level_easy_reg(0);
			feedback:= level_easy_reg(7) XOR level_easy_reg(3) XOR level_easy_reg(2) XOR level_easy_reg(1);

			-- overwriting the level_easy_reg with concatenated reg and feedback
			level_easy_reg <= level_easy_reg(6 DOWNTO 0) & feedback;
		END IF;
	END PROCESS;
	
	-- the range for random values to be outputted
	rnd <= (("00" & level_easy_reg) + CONV_STD_LOGIC_VECTOR(100, 10));
	-- raising an output flag when the enable is 1
	flag <= '1' WHEN enable = '1' ELSE '0';
	-- the flag will mostly be used by pipe to enable random only when the pipe appears
END ARCHITECTURE;