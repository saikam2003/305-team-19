LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CLOCK_DIVIDER IS
	PORT(clk_input: IN STD_LOGIC;
			clk_output: OUT STD_LOGIC);
END ENTITY CLOCK_DIVIDER;

ARCHITECTURE behaviour of CLOCK_DIVIDER IS
BEGIN 

	PROCESS(clk_input)
		VARIABLE counter: INTEGER RANGE 0 TO 4:= 0;
	BEGIN
		IF (RISING_EDGE(clk_input)) then
			IF (counter = 2) THEN
				clk_output <= '1';
			ELSIF (counter = 4) THEN
				clk_output <= '0';
				counter:= 0;
			END IF;
			counter:= counter + 1;
		END IF;
	END PROCESS;
END ARCHITECTURE behaviour;
		