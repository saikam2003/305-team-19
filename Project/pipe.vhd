LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY PIPE is

	PORT(enable, vert_sync, colour_input: IN STD_LOGIC;
			pipe_x: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			pipe_y: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			random_flag: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, green, blue : OUT STD_LOGIC_VECTOR(3 downto 0);
			pipe_on, random_enable: OUT STD_LOGIC;
			pipe_halfway, collision_chance: OUT STD_LOGIC;
			pipe_position: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));

END ENTITY PIPE;


ARCHITECTURE behaviour OF PIPE IS
	
	SIGNAL pipe_on_output: STD_LOGIC;
	SIGNAL size_x: STD_LOGIC_VECTOR(9 DOWNTO 0);
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
	
	
	-- Setting the y position of the pipe and converting it into a 10 bit std_logic_vector
	
	gap_y_pos <= pipe_y WHEN random_flag = '1';
	gap_x_pos <= pipe_x_pos;
	pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(1, 11);
	
	pipe_on_output <= --'0' WHEN enable = '0' ELSE
			'0' WHEN ( ('0' & gap_x_pos <= '0' & pixel_column + gap_size_x) AND ('0' & pixel_column <= '0' & gap_x_pos + gap_size_x) 	-- x_pos - size <= pixel_column <= x_pos + size
			AND ('0' & gap_y_pos <= pixel_row + gap_size_y) AND ('0' & pixel_row <= gap_y_pos + gap_size_y) )  ELSE
			'1' WHEN ( ('0' & pipe_x_pos <= '0' & pixel_column + size_x) AND ('0' & pixel_column <= '0' & pipe_x_pos + size_x)) ELSE	-- x_pos - size <= pixel_column <= x_pos + size
			'0';
	
	
	
	-- Setting the colour of the pipe
	blue <= "0000";
	pipe_on <= pipe_on_output;
	pipe_position <= gap_y_pos;
	
	
	Move_Pipe: PROCESS (vert_sync, random_flag)
		variable counter: integer range 0 to 5:= 0;
		variable half_counter: integer range 0 to 2:= 0;
	BEGIN
		
		IF (RISING_EDGE(vert_sync)) THEN
			IF(colour_input = '1') THEN
					red <= "1111";
					green <= "0000";
				ELSE
					green <= "1111";
					red <= "0000";
				END IF;
			IF (enable = '1') THEN
				
							
				-- INCREMENTING THE HALF COUNTER
				half_counter:= half_counter + 1;

				-- Bounce the pipe off the left or right of the screen
				IF (counter = 1) THEN
					IF (pipe_x_pos <=  CONV_STD_LOGIC_VECTOR(0, 11)) THEN
						pipe_x_pos <= CONV_STD_LOGIC_VECTOR(679, 11);
						random_enable <= '1';
					ELSE
						random_enable <= '0';
						IF (half_counter = 2) THEN
							pipe_x_pos <= pipe_x_pos + pipe_x_motion;
							half_counter:= 0;
						END IF;
					END IF;
					
					IF (('0' & pipe_x_pos <= CONV_STD_LOGIC_VECTOR(339, 11) - size_x)) THEN
						pipe_halfway <= '1';
					ELSE
						pipe_halfway <= '0';
					END IF;
					-- Computer next ball X position
					
					IF ((pipe_x_pos >= 295) AND (pipe_x_pos <= 345)) THEN
						collision_chance <= '1';
					ELSE
						collision_chance <= '0';
					END IF;
				ELSE
					pipe_x_pos <= CONV_STD_LOGIC_VECTOR(639, 11);
					random_enable <= '1';
					counter:= 1;
				END IF;
			END IF;
		END IF;
	END PROCESS Move_Pipe;
END behaviour;