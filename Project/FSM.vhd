LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY FSM IS
	port(clk, option_input, select_input, game_over, reset: IN STD_LOGIC;
		  score_in: IN INTEGER RANGE 999 downto 0;
		  game_mode_out: OUT STD_LOGIC_VECTOR(1 downto 0);
		  game_level_out: OUT STD_LOGIC_VECTOR(1 downto 0));
END ENTITY;

ARCHITECTURE BEHAVIOUR OF FSM IS
	TYPE mode_type IS (Main_menu, Training, Normal, End_screen);
	TYPE level_type IS (Easy, Medium, Hard);
	SIGNAL current_state, next_state: mode_type;
	SIGNAL current_level, next_level: level_type;
	
BEGIN 
	CLOCK: PROCESS(clk)
	begin
		if(rising_edge(clk)) then
			current_state <= next_state;
			current_level <= next_level;
		end if;
	end process;
	
	NEXT_STATE_DECODE: PROCESS(select_input, game_over, score_in)
		variable prev_select: STD_LOGIC;
	begin
		if(reset = '1') then
			next_state <= Main_menu;
			next_level <= Easy;
		else
			if(prev_select = '1' and select_input = '0') then -- option selected with right click
				if(current_state = Main_menu) then -- in Main Menu
					if(option_input = '0') then -- switch to training mode
						next_state <= Training;
						next_level <= Easy;
					elsif(option_input = '1') then -- switch to normal mode
						next_state <= Normal;
						next_level <= Easy;
					end if;
				elsif(current_state = End_screen) then -- in Game Over
					if(option_input = '0') then -- switch to main menu
						next_state <= Normal;
						next_level <= Easy;
					elsif(option_input = '1') then -- switch to normal mode
						next_state <= Main_menu;
					end if;
				end if;
			elsif (game_over = '1') then -- no lives left
				if(current_state = Normal or current_state = Training) then 
					next_state <= End_screen;
				end if;
			end if;
			
			IF(current_state = Normal) THEN -- in normal mode
				IF(score_in > 30) THEN -- switch to hard
					next_level <= Hard;
				ELSIF(score_in <= 30 and score_in > 15) THEN -- switch to medium
					next_level <= Easy;
				END IF;
			END IF;
			prev_select := select_input;
		end if;
	end process;
	
	OUTPUT_DECODE : PROCESS(current_state, current_level)
	begin
		case(current_state) is
			when Main_menu => game_mode_out <= "00";
			when Training => game_mode_out <= "01";
			when Normal => game_mode_out <= "10";
			when End_screen => game_mode_out <= "11";
			when others => game_mode_out <= "00";
		end case;
		
		case(current_level) is
			when Easy => game_level_out <= "01";
			when Medium => game_level_out <= "10";
			when Hard => game_level_out <= "11";
			when others => game_level_out <= "01";
		end case;
	end process;
	
	
end architecture;