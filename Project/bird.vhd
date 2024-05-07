LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY BIRD IS 

	PORT(clk, vert_sync, mouse_clicked: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			red, green, blue, bird_on: OUT STD_LOGIC);

END ENTITY BIRD;

ARCHITECTURE behaviour OF BIRD IS
	
	SIGNAL ball_on: STD_LOGIC;
	SIGNAL size: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL ball_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL ball_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL ball_y_motion: STD_LOGIC_VECTOR(9 DOWNTO 0);
	

BEGIN
	-- Setting the size of the bird and converting it into a 10 bit std_logic_vector
	size <= CONV_STD_LOGIC_VECTOR(7, 10);
	
	-- Setting the x position of the ball and converting it into a 10 bit std_logic_vector
	ball_x_pos <= CONV_STD_LOGIC_VECTOR(320, 11);
	
	-- Logic to determine if we are inside the ball (haven't reached the end of the ball according to the size)
	-- to decide whether or not we want to display the ball
	ball_on <= '1' WHEN ( ('0' & ball_x_pos <= '0' & pixel_column + size) AND ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					AND ('0' & ball_y_pos <= pixel_row + size) AND ('0' & pixel_row <= ball_y_pos + size) )  ELSE	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
	
	-- Setting the colour of the bird
	red <= '1';
	green <= '1';
	blue <= '0';
	bird_on <= ball_on;
	
	Move_Bird: PROCESS (vert_sync)
	
	BEGIN
	
		IF (RISING_EDGE(vert_sync)) THEN
			-- Bounce off top or bottom of the screen
			IF (mouse_clicked = '1') THEN
				ball_y_motion <= - CONV_STD_LOGIC_VECTOR(5, 10);
			ELSIF (ball_y_pos >= (CONV_STD_LOGIC_VECTOR(479, 10) - size)) THEN
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(0, 10);
			ELSE
				ball_y_motion <= CONV_STD_LOGIC_VECTOR(1, 10);
			END IF;
			-- Compute next ball Y position
			ball_y_pos <= ball_y_pos + ball_y_motion;
		END IF;
	END PROCESS Move_Bird;
END behaviour;
