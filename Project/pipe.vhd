LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY PIPE is

	PORT(enable, horz_sync: IN STD_LOGIC;
			pipe_x: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, green, blue, pipe_on: OUT STD_LOGIC;
			pipe_halfway: OUT STD_LOGIC;
			pipe_position: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));

END ENTITY PIPE;


ARCHITECTURE behaviour OF PIPE IS
	
	SIGNAL pipe_on_output: STD_LOGIC;
	SIGNAL size_x: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL size_y: STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL pipe_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL pipe_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL pipe_x_motion: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL gap_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL gap_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL gap_size_y: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL gap_size_x: STD_LOGIC_VECTOR(9 DOWNTO 0);
	
BEGIN
	
	
	-- Setting the size of the gap between the pipes
	gap_size_y <= CONV_STD_LOGIC_VECTOR(56, 10);
	gap_size_x <= CONV_STD_LOGIC_VECTOR(16, 10);
	
	-- Setting the size of the pipe and converting it into a 10 bit std_logic_vector
	size_x <= CONV_STD_LOGIC_VECTOR(16, 10);
	size_y <= CONV_STD_LOGIC_VECTOR(211, 10);
	
	-- Setting the y position of the pipe and converting it into a 10 bit std_logic_vector
	
	pipe_y_pos <= CONV_STD_LOGIC_VECTOR(218, 10);
	gap_y_pos <= CONV_STD_LOGIC_VECTOR(218, 10);
	gap_x_pos <= pipe_x_pos;
	pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(1, 11);
	
	pipe_on_output <= '0' WHEN enable = '0' ELSE
			'0' WHEN ( ('0' & gap_x_pos <= '0' & pixel_column + gap_size_x) AND ('0' & pixel_column <= '0' & gap_x_pos + gap_size_x) 	-- x_pos - size <= pixel_column <= x_pos + size
			AND ('0' & gap_y_pos <= pixel_row + gap_size_y) AND ('0' & pixel_row <= gap_y_pos + gap_size_y) )  ELSE
			'1' WHEN ( ('0' & pipe_x_pos <= '0' & pixel_column + size_x) AND ('0' & pixel_column <= '0' & pipe_x_pos + size_x)) ELSE	-- x_pos - size <= pixel_column <= x_pos + size
			'0';
	
	
	
	-- Setting the colour of the pipe
	red <= '0';
	green <= '1';
	blue <= '0';
	pipe_on <= pipe_on_output;
	pipe_position <= pixel_column WHEN pipe_on_output = '1' else CONV_STD_LOGIC_VECTOR(0, 10);
	
	
	Move_Pipe: PROCESS (horz_sync)
		variable counter: integer range 0 to 5:= 0;
	BEGIN
		
		IF (RISING_EDGE(horz_sync) AND enable = '1') THEN
			-- Bounce the pipe off the left or right of the screen
			IF (counter = 1) THEN
				IF (pipe_x_pos <=  CONV_STD_LOGIC_VECTOR(0, 11)) THEN
					pipe_x_pos <= CONV_STD_LOGIC_VECTOR(679, 11);
				ELSE
					pipe_x_pos <= pipe_x_pos + pipe_x_motion;
				END IF;
				
				IF (('0' & pipe_x_pos <= CONV_STD_LOGIC_VECTOR(339, 11) - size_x)) THEN
					pipe_halfway <= '1';
				ELSE
					pipe_halfway <= '0';
				END IF;
				-- Computer next ball X position
			ELSE
				pipe_x_pos <= pipe_x;
				counter:= 1;
			END IF;
		END IF;
	END PROCESS Move_Pipe;
END behaviour;