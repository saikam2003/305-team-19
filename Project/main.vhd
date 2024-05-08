
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY MAIN IS 

	PORT(background_on, clk_input, jump_input, start_input, reset_input, colour_bird, colour_pipe: IN STD_LOGIC;
		horizontal_sync, vertical_sync: IN STD_LOGIC;
		pixel_row_input, pixel_column_input: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		red_output, green_output, blue_output: OUT STD_LOGIC;
		led1, led2: OUT STD_LOGIC);

END ENTITY MAIN;


ARCHITECTURE behvaiour OF MAIN IS
	
	SIGNAL bird_red, bird_green, bird_blue, t_bird_on: STD_LOGIC;
	SIGNAL t_bird_position: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL text_red, text_blue, text_green, t_text_on: STD_LOGIC;
	SIGNAL pipe_red, pipe_green, pipe_blue, t_pipe_on, t_pipe_halfway, t_collision_chance, t_collision_detected: STD_LOGIC;
	SIGNAL pipe_red_2, pipe_green_2, pipe_blue_2, t_pipe_on_2, t_pipe_halfway_2, t_collision_chance_2, t_collision_detected_2: STD_LOGIC;
	SIGNAL t_pipe_position, t_pipe_position_2: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL t_pipe_x, t_pipe_x_2: STD_LOGIC_VECTOR(10 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(679, 11);
	SIGNAL t_pipe_enable_2: STD_LOGIC:= '0';
	SIGNAL t_pipe_enable: STD_LOGIC:= '0';
	SIGNAL background_red, background_green, background_blue, t_background_on: STD_LOGIC;
	
	COMPONENT BIRD IS
		PORT(clk, vert_sync, mouse_clicked, colour_input: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			red, green, blue, bird_on: OUT STD_LOGIC;
			bird_y_position: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT PIPE IS
		PORT(enable, horz_sync, colour_input: IN STD_LOGIC;
			pipe_x: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, green, blue, pipe_on: OUT STD_LOGIC;
			pipe_halfway, collision_chance: OUT STD_LOGIC;
			pipe_position: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT BACKGROUND IS
		PORT
		( clk, vert_sync, horz_sync: IN std_logic;
		  pixel_row, pixel_column: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue, background_on: OUT std_logic);	
	END COMPONENT;
	
	COMPONENT COLLISION IS
		PORT(clk, pipe_on, pipe_collision_chance: IN STD_LOGIC;
			pipe_y_position, bird_y_position: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			collision_detected: OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT TEXT_DISPLAY IS
		PORT(Clk, enable: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, blue, green, text_on: OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN 
	
	bird_component: BIRD
						PORT MAP(
							clk => clk_input,
							vert_sync => vertical_sync,
							mouse_clicked => jump_input,
							colour_input => colour_bird,
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => bird_red,
							green => bird_green,
							blue => bird_blue,
							bird_on => t_bird_on,
							bird_y_position => t_bird_position
						);
	
	pipe_component: PIPE
						PORT MAP(
							enable => t_pipe_enable,
							horz_sync => vertical_sync,
							colour_input => colour_pipe,
							pipe_x => t_pipe_x,
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => pipe_red,
							green => pipe_green,
							blue => pipe_blue,
							pipe_on => t_pipe_on,
							pipe_halfway => t_pipe_halfway,
							collision_chance => t_collision_chance,
							pipe_position => t_pipe_position
						);
						
	collision_detection_pipe: COLLISION 
						PORT MAP(
							clk => clk_input,
							pipe_on => t_pipe_on,
							pipe_collision_chance => t_collision_chance,
							pipe_y_position => CONV_STD_LOGIC_VECTOR(218, 10),
							bird_y_position => t_bird_position,
							collision_detected => t_collision_detected
						);
	collision_detection_pipe_2: COLLISION 
						PORT MAP(
							clk => clk_input,
							pipe_on => t_pipe_on_2,
							pipe_collision_chance => t_collision_chance_2,
							pipe_y_position => CONV_STD_LOGIC_VECTOR(218, 10),
							bird_y_position => t_bird_position,
							collision_detected => t_collision_detected_2
						);
	pipe_component_2: PIPE
						PORT MAP(
							enable => t_pipe_enable_2,
							horz_sync => vertical_sync,
							colour_input => colour_pipe,
							pipe_x => t_pipe_x_2,
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => pipe_red_2,
							green => pipe_green_2,
							blue => pipe_blue_2,
							pipe_on => t_pipe_on_2,
							pipe_halfway => t_pipe_halfway_2,
							collision_chance => t_collision_chance_2,
							pipe_position => t_pipe_position_2
						);
	
	background_component: BACKGROUND
								PORT MAP(
									clk => clk_input,
									vert_sync => vertical_sync,
									horz_sync => horizontal_sync,
									pixel_row => pixel_row_input,
									pixel_column => pixel_column_input,
									red => background_red,
									green => background_green,
									blue => background_blue,
									background_on => t_background_on
								);
								
	text_component: TEXT_DISPLAY
						PORT MAP(Clk => clk_input,
							enable => '1',
							pixel_row => pixel_row_input, 
							pixel_column => pixel_column_input,
							red => text_red, 
							blue => text_blue, 
							green => text_green, 
							text_on => t_text_on);

	
	screen_display: PROCESS(clk_input)
		VARIABLE counter: INTEGER RANGE 0 TO 1:= 0;
	BEGIN
		IF (RISING_EDGE(clk_input)) THEN
			IF ((t_collision_detected = '1' OR t_collision_detected_2 = '1')) then
				t_pipe_enable <= '0';
				t_pipe_enable_2 <= '0';
			END IF;
			
			IF((t_pipe_enable = '0') AND start_input = '0') THEN
				t_pipe_enable <= '1';
--				t_pipe_enable_2 <= '1';
			END IF;
			
			
			IF (t_text_on = '1') THEN
				red_output <= text_red;
				green_output <= text_green;
				blue_output <= text_blue;
			ELSIF (t_bird_on = '1') THEN
				red_output <= bird_red;
				green_output <= bird_green;
				blue_output <= bird_blue;
			ELSIF (t_pipe_on = '1') THEN
				red_output <= pipe_red;
				green_output <= pipe_green;
				blue_output <= pipe_blue;
			ELSIF (t_pipe_on_2 = '1') THEN
				red_output <= pipe_red_2;
				green_output <= pipe_green_2;
				blue_output <= pipe_blue_2;
			ELSIF (t_background_on = '1') THEN
				red_output <= background_red;
				green_output <= background_green;
				blue_output <= background_blue;
			ELSE
				red_output <= '0';
				green_output <= '1';
				blue_output <= '1';
			END IF;
--			IF (counter = 0) THEN
				IF (t_pipe_halfway = '1' and t_collision_detected = '0' and t_collision_detected_2 = '0') THEN
					t_pipe_enable_2 <= '1';
					counter:= 1;
				END IF;
--			END IF;
		END IF;
	END PROCESS screen_display;
	led1 <= t_collision_detected;
	led2 <= t_collision_detected_2;
END ARCHITECTURE;
	
	