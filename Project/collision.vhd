LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY COLLISION IS

	PORT(reset, clk, pipe_on, pipe_collision_chance: IN STD_LOGIC;
			pipe_y_position, bird_y_position: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			collision_detected: OUT STD_LOGIC;
			collision_counter: OUT integer range 0 to 3
			);
			
END ENTITY COLLISION;


ARCHITECTURE behaviour OF COLLISION IS
	CONSTANT gap_size_x: STD_LOGIC_VECTOR(9 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(20, 10);
	CONSTANT gap_size_y: STD_LOGIC_VECTOR(9 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(56, 10);
	CONSTANT bird_x_position: STD_LOGIC_VECTOR(10 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(313, 11);
	CONSTANT bird_size: STD_LOGIC_VECTOR(9 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(7, 10);
BEGIN
	-- collision_detected <= '0' WHEN reset = '1' ELSE
	-- 					'1' WHEN ((pipe_collision_chance = '1') 
	-- 					AND ((bird_y_position + bird_size >= pipe_y_position + gap_size_y) 
	-- 					OR (bird_y_position - bird_size <= pipe_y_position - gap_size_y)));
	
	
	PROCESS(pipe_collision_chance,reset)
	variable q_collision_counter : integer range 0 to 3;
	BEGIN
		IF (reset = '1') THEN
			collision_detected <= '0';
			
			--if (q_collision_counter = 3) then
			--	q_collision_counter := 0;
			--end if;
			
		ELSIF RISING_EDGE(pipe_collision_chance) THEN
		
			IF (pipe_collision_chance = '1') THEN
			
				IF ((bird_y_position + bird_size >= pipe_y_position + gap_size_y) OR (bird_y_position - bird_size <= pipe_y_position - gap_size_y)) THEN
				
					collision_detected <= '1';
					
					IF(q_collision_counter /= 3) then
						q_collision_counter := q_collision_counter + 1;
					ELSE
						q_collision_counter := 0;
					END IF;
					
				END IF;
			END IF;
		END IF;
		collision_counter <= q_collision_counter;
	END PROCESS;

END ARCHITECTURE behaviour;