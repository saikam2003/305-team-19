LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY PIPE is

	PORT(clk, horz_sync: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, green, blue, pipe_on: OUT STD_LOGIC);

END ENTITY PIPE;


ARCHITECTURE behaviour OF PIPE IS
	
	SIGNAL pipe_on_output: STD_LOGIC;
	SIGNAL size_x: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL size_y: STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL pipe_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL pipe_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL pipe_x_motion: STD_LOGIC_VECTOR(9 DOWNTO 0);
	
BEGIN
	
	-- Setting the size of the pipe and converting it into a 10 bit std_logic_vector
	size_x <= CONV_STD_LOGIC_VECTOR(16, 10);
	size_y <= CONV_STD_LOGIC_VECTOR(239, 10);
	
	-- Setting the y position of the pipe and converting it into a 10 bit std_logic_vector
	
	pipe_y_pos <= CONV_STD_LOGIC_VECTOR(240, 10);
	
	
	pipe_on_output <= '1' WHEN ( ('0' & pipe_x_pos <= '0' & pixel_column + size_x) AND ('0' & pixel_column <= '0' & pipe_x_pos + size_x) 	-- x_pos - size <= pixel_column <= x_pos + size
					AND ('0' & pipe_y_pos <= pixel_row + size_y) AND ('0' & pixel_row <= pipe_y_pos + size_y) )  ELSE	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
	
	
	
	-- Setting the colour of the pipe
	red <= '0';
	green <= '1';
	blue <= '0';
	pipe_on <= pipe_on_output;
	
	Move_Pipe: PROCESS (horz_sync)
	
	BEGIN
		
		IF (RISING_EDGE(horz_sync)) THEN
			-- Bounce the pipe off the left or right of the screen
			IF (('0' & pipe_x_pos >= CONV_STD_LOGIC_VECTOR(679, 10) - size_x)) THEN
				pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(2, 10);
			ELSIF (pipe_x_pos <=  size_x) THEN
				pipe_x_motion <= CONV_STD_LOGIC_VECTOR(2, 10);
			END IF;
			
			-- Computer next ball X position
			pipe_x_pos <= pipe_x_pos + pipe_x_motion;
		END IF;
	END PROCESS Move_Pipe;
END behaviour;
			
				