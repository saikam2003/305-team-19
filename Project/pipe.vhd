LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY PIPE is

	PORT(pipe_reset, enable, vert_sync, colour_input: IN STD_LOGIC;
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
	-- Setting the size of the pipe and converting it into a 10 bit std_logic_vector
	size_x <= CONV_STD_LOGIC_VECTOR(20, 10);
	
	-- Setting the size of the gap between the pipes
	gap_size_y <= CONV_STD_LOGIC_VECTOR(56, 10);
	gap_size_x <= size_x;
	
	
	
	
	-- Setting the y position of the gap to the y position of the pipe only when random flag is 1
	gap_y_pos <= pipe_y WHEN random_flag = '1' ELSE gap_y_pos;
	gap_x_pos <= pipe_x_pos; -- gap position is always the same as pipe center
	pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(2, 11); -- the pipe moves by 1 pixel by default
	
	-- setting when the pipe should be on
	pipe_on_output <= --'0' WHEN enable = '0' ELSE
			'0' WHEN ( ('0' & gap_x_pos <= '0' & pixel_column + gap_size_x) AND ('0' & pixel_column <= '0' & gap_x_pos + gap_size_x) 	-- x_pos - size <= pixel_column <= x_pos + size
			AND ('0' & gap_y_pos <= pixel_row + gap_size_y) AND ('0' & pixel_row <= gap_y_pos + gap_size_y) )  ELSE
			'1' WHEN ( ('0' & pipe_x_pos <= '0' & pixel_column + size_x) AND ('0' & pixel_column <= '0' & pipe_x_pos + size_x)) ELSE	-- x_pos - size <= pixel_column <= x_pos + size
			'0';


	-- Setting the colour of the pipe
	blue <= "0000";

	-- setting t he output of entity
	pipe_on <= pipe_on_output;
	-- the pipe position is the same as gap_y_position
	pipe_position <= gap_y_pos;
	
	
	Move_Pipe: PROCESS (vert_sync, pipe_reset)
		variable first_iteration: STD_LOGIC := '0';
		--variable half_counter: integer range 0 to 2:= 0;
	BEGIN
		IF (pipe_reset = '1') THEN
			--if the pipe is reset, then
				pipe_x_pos <= CONV_STD_LOGIC_VECTOR(679, 11); -- send the pipe all the way to the end
				random_enable <= '1'; -- reset random_enable as 0
				-- reset counters
				first_iteration := '0';
				--half_counter := 0;
				-- reset chance of collision because pipe is reset to the end
				collision_chance <= '0';
				pipe_halfway <= '0';
				
		
		ELSIF (RISING_EDGE(vert_sync)) THEN

		-- moving the pipes only when enable is 1
			IF (enable = '1') THEN
				
			-- changing color according to switch input
				IF(colour_input = '1') THEN
					red <= "1011";
					green <= "0000";
				ELSE
					green <= "1100";
					red <= "0000";
				END IF;

				-- INCREMENTING THE HALF COUNTER
				--half_counter:= half_counter + 1;

				-- if the counter is 1
				IF (first_iteration = '1') THEN
					-- then check if the pipe os going beyond 0
					IF ((pipe_x_pos + size_x) <  - CONV_STD_LOGIC_VECTOR(39, 11)) THEN
						--if so resest pipecenter to the right end of screen
						pipe_x_pos <= CONV_STD_LOGIC_VECTOR(679, 11);
						random_enable <= '1'; -- re-enable random_enable
					ELSE
					-- otherwise, random enable is set to 0
						random_enable <= '0';

						-- moving the pipe every 2 vertical syncs to slow down the pipes
						--IF (half_counter = 2) THEN
						-- if the half counter is 2 only then move pipe
							pipe_x_pos <= pipe_x_pos + pipe_x_motion;
							-- and reset the counter
							--half_counter:= 0;
						--END IF;

					END IF;
					
					-- if the current pipe reaches halfway,set halfway output 
					IF (('0' & pipe_x_pos <= CONV_STD_LOGIC_VECTOR(339, 11) - size_x)) THEN
						pipe_halfway <= '1';
					ELSE
						pipe_halfway <= '0';
					END IF;


					-- Compute next ball X position
					
					-- only when the pipe is coming towards the center (where the bird is)
					IF ((pipe_x_pos >= 295) AND (pipe_x_pos <= 345)) THEN
						collision_chance <= '1'; -- the chance of collision is high
					ELSE
						collision_chance <= '0';
					END IF;
				ELSE

					-- setting the default position at the very end
					pipe_x_pos <= CONV_STD_LOGIC_VECTOR(679, 11);
					random_enable <= '1'; -- random enable is always 1
					first_iteration:= '1'; -- resetting counter to 1

				END IF;
			END IF;
		END IF;
	END PROCESS Move_Pipe;

-- end of architechture
END behaviour;