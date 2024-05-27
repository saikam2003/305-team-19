LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY FSM IS
	port(clk, select_option, select_input, game_over: IN STD_LOGIC;
		  game_mode_out: OUT STD_LOGIC_VECTOR(1 downto 0);
		  game_level_out: OUT STD_LOGIC_VECTOR(1 downto 0));
END ENTITY;

ARCHITECTURE BEHAVIOUR OF FSM IS
	SIGNAL game_mode: STD_LOGIC_VECTOR(1 downto 0) := "00";
	
BEGIN 
	
	FSM_game_mode: PROCESS(select_input, game_over)
		variable prev_select: STD_LOGIC;
	begin
	
		if(rising_edge(clk)) then
			if(prev_select = '1' and select_input = '0') then
				if(game_mode = "00") then
					if(select_option = '0') then
						game_mode <= "01";
					elsif(select_option = '1') then
						game_mode <= "10";
					end if;
				elsif(game_mode = "11") then
					if(select_option = '0') then
						game_mode <= "10";
					elsif(select_option = '1') then
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
			prev_select := select_input;
		end if;

	end process FSM_game_mode;
	
	game_mode_out <= game_mode;
end architecture;