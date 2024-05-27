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
	SIGNAL game_mode: STD_LOGIC_VECTOR(1 downto 0) := "00";
BEGIN 
	
	FSM_game_mode: PROCESS(select_input, game_over)
		variable prev_select: STD_LOGIC;
	begin
		if(reset = '1') then
			game_mode <= "00";
			game_level_out <= "01";
		elsif(rising_edge(clk)) then
			if(prev_select = '1' and select_input = '0') then
				if(game_mode = "00") then
					if(option_input = '0') then
						game_mode <= "01";
						game_level_out <= "01";
					elsif(option_input = '1') then
						game_mode <= "10";
						game_level_out <= "01";
					end if;
				elsif(game_mode = "11") then
					if(option_input = '0') then
						game_mode <= "10";
						game_level_out <= "01";
					elsif(option_input = '1') then
						game_mode <= "00";
					end if;
				end if;
			elsif (game_over = '1') then
				if(game_mode = "01") then 
					game_mode <= "11";
				elsif(game_mode = "10") then
					game_mode <= "11";
				end if;
			end if;
			
			IF(game_mode = "10") THEN
				IF(score_in > 30) THEN
					game_level_out <= "11";
				ELSIF(score_in <= 30 and score_in > 15) THEN
					game_level_out <= "10";
				END IF;
			END IF;
			prev_select := select_input;
		end if;

	end process FSM_game_mode;
	
	game_mode_out <= game_mode;
end architecture;