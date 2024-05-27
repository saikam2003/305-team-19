
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;


ENTITY MAIN IS
	PORT(background_on, clk_input, jump_input, pause_input, select_input, option_input, global_reset_button: IN STD_LOGIC;
		horizontal_sync, vertical_sync: IN STD_LOGIC;
		pixel_row_input, pixel_column_input: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		red_output, green_output, blue_output, score_hundreds, score_tens, score_ones: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		led1, led2: OUT STD_LOGIC);

END ENTITY MAIN;

	pipe_q => pipe_1_quarter AND pipe_2_quarter
ARCHITECTURE behvaiour OF MAIN IS
	
	SIGNAL t_collision_1, t_collision_2, t_collision_flag, collisions_reset, collision_tracker, pipe_1_infront, pipe_1_collision_chance, pipe_2_collision_chance, t_game_over, t_game_started: STD_LOGIC:= '0';
	SIGNAL t_pipes_show, t_bird_show, t_text_show, t_bird_reset, paused_game, t_power_up_enable: STD_LOGIC;
	SIGNAL bird_red, bird_green, bird_blue: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL t_bird_position: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL text_red, text_blue, text_green: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL pipe_red, pipe_green, pipe_blue,pipe_red_2, pipe_green_2, pipe_blue_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL heart_red, heart_green, heart_blue : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL t_pipe_reset, t_pipe_on, t_pipe_halfway, t_bird_on, t_random_flag, t_random_enable: STD_LOGIC;
	SIGNAL t_pipe_on_2, t_pipe_halfway_2, t_text_on, t_heart_on, t_background_on, t_random_flag_2, t_random_enable_2, t_power_up_on: STD_LOGIC;
	SIGNAL t_pipe_position, t_pipe_position_2: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL t_pipe_x, t_pipe_x_2: STD_LOGIC_VECTOR(10 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(679, 11);
	SIGNAL t_pipe_y, t_pipe_y_2: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL t_pipe_enable_2: STD_LOGIC:= '0';
	SIGNAL t_pipe_enable: STD_LOGIC:= '0';
	SIGNAL background_red, background_green, background_blue: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL game_mode, game_level: STD_LOGIC_VECTOR(1 downto 0) := "00";
	SIGNAL collision_counter: INTEGER RANGE 3 downto 0;
	SIGNAL t_score, best_score, prev_score: INTEGER RANGE 999 downto 0;
	COMPONENT HEART IS
		PORT(clk, vert_sync, mouse_clicked, colour_input: IN STD_LOGIC;
			 pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			 collision_counter : IN INTEGER RANGE 0 TO 3;
			 red, green, blue : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			 heart_on: OUT STD_LOGIC
		);
	END COMPONENT;
	
	
	COMPONENT BIRD IS
	PORT(clk, enable, reset, vert_sync, mouse_clicked, colour_input: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			red, green, blue : OUT STD_LOGIC_VECTOR(3 downto 0);
			bird_on: OUT STD_LOGIC;
			bird_y_position: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));

	END COMPONENT;
	
	COMPONENT PIPE IS
	PORT(pipe_reset, enable, vert_sync, colour_input, clk: IN STD_LOGIC;
			pipe_x: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			pipe_y: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			random_flag: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, green, blue : OUT STD_LOGIC_VECTOR(3 downto 0);
			pipe_on, random_enable: OUT STD_LOGIC;
			pipe_halfway, collision_chance: OUT STD_LOGIC;
			pipe_position: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT BACKGROUND IS
		PORT
		( clk, enable, vert_sync, horz_sync	: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue : OUT STD_LOGIC_VECTOR(3 downto 0);
		  background_on 			: OUT std_logic);		
	END COMPONENT;
	
	COMPONENT TEXT_DISPLAY IS
		PORT(Clk, enable, option_in: IN STD_LOGIC;
			game_mode_in: IN STD_LOGIC_VECTOR(1 downto 0);
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, blue, green : OUT STD_LOGIC_VECTOR(3 downto 0);
			text_on: OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT LFSR IS
		PORT(clk, enable: IN STD_LOGIC;
			rnd: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
			flag: OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT FSM IS
		port(clk, option_input, select_input, game_over, reset: IN STD_LOGIC;
		  game_mode_out: OUT STD_LOGIC_VECTOR(1 downto 0);
		  game_level_out: OUT STD_LOGIC_VECTOR(1 downto 0));
	END COMPONENT;
	
	COMPONENT COLLISION IS
		PORT(reset, clk, pipe_on, bird_on: IN STD_LOGIC;
			collision_detected: OUT STD_LOGIC);
	END COMPONENT COLLISION;
	
	
	COMPONENT power_up IS
		PORT (bird_on, clk, vert_sync, enable, pipe_quarterway: IN STD_LOGIC;
					score: IN INTEGER RANGE 999 DOWNTO 0;
					gap_y_pos: IN STD_LOGIC_VECTOR(9 DOWNTO 0); 
					pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
					red, green, blue: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
					power_up_on : OUT STD_LOGIC;
	END COMPONENT;

	BEGIN 
	
	bird_component: BIRD
						PORT MAP(
							clk => clk_input,
							enable => (not(paused_game)),
							reset => t_bird_reset,
							vert_sync => vertical_sync,
							mouse_clicked => jump_input,
							colour_input => '0',
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => bird_red,
							green => bird_green,
							blue => bird_blue,
							bird_on => t_bird_on,
							bird_y_position => t_bird_position
						);
						
	heart_component: HEART
						PORT MAP (
							clk => clk_input,
							vert_sync => vertical_sync,
							mouse_clicked => jump_input,
							colour_input => '0',
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							collision_counter => collision_counter,
							red 	=> heart_red,
							blue 	=> heart_blue,
							green 	=> heart_green,
							heart_on => t_heart_on
						);
						
	
	pipe_component: PIPE
						PORT MAP(
							clk => clk_input,
							pipe_reset => t_pipe_reset,
							enable => (t_pipe_enable and not(pause_input)),
							vert_sync => vertical_sync,
							colour_input => '0',
							pipe_x => t_pipe_x,
							pipe_y => t_pipe_y,
							random_flag => t_random_flag,
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => pipe_red,
							green => pipe_green,
							blue => pipe_blue,
							pipe_on => t_pipe_on,
							random_enable => t_random_enable,
							pipe_halfway => t_pipe_halfway,
							collision_chance => pipe_1_collision_chance,
							pipe_position => t_pipe_position
						);
						
	pipe_component_2: PIPE
						PORT MAP(
							clk => clk_input,
							pipe_reset => t_pipe_reset,
							enable => (t_pipe_enable_2 and not(pause_input)),
							vert_sync => vertical_sync,
							colour_input => '0',
							pipe_x => t_pipe_x_2,
							pipe_y => t_pipe_y_2,
							random_flag => t_random_flag_2,
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => pipe_red_2,
							green => pipe_green_2,
							blue => pipe_blue_2,
							pipe_on => t_pipe_on_2,
							random_enable => t_random_enable_2,
							pipe_halfway => t_pipe_halfway_2,
							collision_chance => pipe_2_collision_chance,
							pipe_position => t_pipe_position_2
						);
	
	background_component: BACKGROUND
								PORT MAP(
									clk => clk_input,
									enable => '1',
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
							option_in => option_input,
							game_mode_in => game_mode,
							pixel_row => pixel_row_input, 
							pixel_column => pixel_column_input,
							red => text_red, 
							blue => text_blue, 
							green => text_green, 
							text_on => t_text_on);
	
	prng: LFSR
			PORT MAP(
				clk => clk_input,
				enable => t_random_enable,
				rnd => t_pipe_y,
				flag => t_random_flag
			);
			
	prng_2: LFSR
			PORT MAP(
				clk => clk_input,
				enable => t_random_enable_2,
				rnd => t_pipe_y_2,
				flag => t_random_flag_2
			);
			
	FSM_DUT: FSM
			port map(clk => clk_input,
						option_input => option_input, 
						select_input => select_input, 
						game_over => t_game_over,
						reset => not(global_reset_button),
						game_mode_out => game_mode,
						game_level_out => game_level
			);
	
	COLLISION_1: COLLISION
			port map(reset => collisions_reset, 
						clk => clk_input, 
						pipe_on => t_pipe_on,
						bird_on => t_bird_on, 
						collision_detected => t_collision_1);		
						
	COLLISION_2: COLLISION
			port map(reset => collisions_reset, 
						clk => clk_input, 
						pipe_on => t_pipe_on_2,
						bird_on => t_bird_on, 
						collision_detected => t_collision_2);		


	POWER_UP_COMPONENT: POWER_UP
			port map(bird_on => t_bird_on,
							clk => clk_input,
							vert_sync => vertical_sync,
							enable => '1',
							pipe_quarterway => t_pipe_halfway_2,
							score => t_score,
							gap_y_pos => CONV_STD_LOGIC_VECTOR(0,10),
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => t_power_up_red,
							green => t_power_up_green,
							blue => t_power_up_blue,
							power_up_on => t_power_up_on
							)
							
	t_pipe_enable_2 <= '0' WHEN  (t_pipe_enable = '0') ELSE '1' WHEN (t_pipe_halfway = '1') ELSE t_pipe_enable_2; -- start second pipe after firt reaches halfway
	
	led1 <= t_collision_1;
	led2 <= t_collision_2;
	
    score_hundreds <= CONV_STD_LOGIC_VECTOR(t_score / 100, 4); -- Hundreds place
    score_tens <= CONV_STD_LOGIC_VECTOR((t_score mod 100) / 10, 4); -- Tens place
    score_ones <= CONV_STD_LOGIC_VECTOR((t_score mod 10), 4); -- Ones place
		t_power_up_enable <= '0' when t_bird_on = '1' AND t_power_up_on = '1' else '0';
		paused_game <= pause_input;

	screen_display: PROCESS(clk_input)
	BEGIN
		IF (RISING_EDGE(clk_input)) THEN
		
			IF(game_mode = "00") THEN -- Main Menu
				t_bird_show <= '0';
				t_pipes_show <= '0';
				t_text_show <= '1';
				t_bird_reset <= '1';
				t_pipe_reset <= '1';
				t_pipe_enable <= '0';
				collisions_reset <= '1';
				collision_counter <= 0;
				t_collision_flag <= '0';
				t_game_over <= '0';
				pipe_1_infront <= '1';
				t_score <= 0;
			ELSIF(game_mode = "01") THEN -- Training Mode
				t_bird_show <= '1';
				t_pipes_show <= '1';
				t_text_show <= '0';
				t_bird_reset <= '0';
				t_pipe_reset <= '0';
				t_pipe_enable <= '1';
				collisions_reset <= '0';
			ELSIF(game_mode = "10") THEN -- Normal Mode
				t_bird_show <= '1';
				t_pipes_show <= '1';
				t_text_show <= '0';
				t_bird_reset <= '0';
				t_pipe_reset <= '0';
				t_pipe_enable <= '1';
				collisions_reset <= '0';
			ELSIF(game_mode = "11") THEN -- Game Over
				t_bird_show <= '0';
				t_pipes_show <= '0';
				t_text_show <= '1';
				t_bird_reset <= '1';
				t_pipe_reset <= '1';
				t_pipe_enable <= '0';
				collisions_reset <= '1';
				collision_counter <= 0;
				t_collision_flag <= '0';
				t_game_over <= '0';
				pipe_1_infront <= '1';
				t_score <= 0;
			END IF;

			-- ============ collision detection ==============
			
			IF(t_collision_flag = '0' and (t_collision_1 = '1' or t_collision_2 = '1'))THEN
				
				collision_counter <= collision_counter + 1;
				IF(collision_counter = 2) THEN
					t_game_over <= '1';
				END IF;
				
				t_collision_flag <= '1';
				if(t_collision_1 = '1') THEN
					collision_tracker <= '1';
				else
					collision_tracker <= '0';
				end if;
			ELSIF(t_collision_flag = '1')THEN
				if(collision_tracker = '1' and pipe_2_collision_chance = '1')then
					t_collision_flag <= '0';
				elsif(collision_tracker = '0' and pipe_1_collision_chance = '1') then 
					t_collision_flag <= '0';
				end if;
			END IF;
			
			-- ============ score counter ==============
			
			IF(pipe_1_infront = '1' and t_pipe_halfway = '1') THEN
				pipe_1_infront <= '0';
				t_score <= t_score + 9;
			ELSIF(pipe_1_infront = '0' and t_pipe_halfway_2 = '1') THEN
				pipe_1_infront <= '1';
				t_score <= t_score + 9;
			END IF;
			
			
			
			-- ============ vga sync input ==============
			
			IF (t_heart_on = '1' and t_pipes_show = '1') THEN
				red_output <=   heart_red;
				green_output <= heart_green;
				blue_output <=  heart_blue;
			ELSIF (t_text_on = '1' and t_text_show = '1') THEN
				red_output <= text_red;
				green_output <= text_green;
				blue_output <= text_blue;
			ELSIF (t_bird_on = '1' and t_bird_show = '1') THEN
				red_output <= bird_red;
				green_output <= bird_green;
				blue_output <= bird_blue;
			ELSIF (t_pipe_on = '1' and t_pipes_show = '1') THEN
				red_output <= pipe_red;
				green_output <= pipe_green;
				blue_output <= pipe_blue;
			ELSIF (t_pipe_on_2 = '1' and t_pipes_show = '1') THEN
				red_output <= pipe_red_2;
				green_output <= pipe_green_2;
				blue_output <= pipe_blue_2;
			ELSIF (t_power_up_on = '1') THEN
				red_output <= 	t_power_up_red;
				green_output <= t_power_up_green;
				blue_output <= 	t_power_up_blue;
			ELSIF (t_background_on = '1') THEN
				red_output <= background_red;
				green_output <= background_green;
				blue_output <= background_blue;
			ELSE
				red_output <= "0000";
				green_output <= "1010";
				blue_output <= "1011";
			END IF;
			

		END IF;
	END PROCESS screen_display;


END ARCHITECTURE;
	
	