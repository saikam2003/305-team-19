LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY MAIN IS 

	PORT(background_on, clk_input, vertical_sync, horizontal_sync: IN STD_LOGIC;
		pixel_row_input, pixel_column_input: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		red_output, green_output, blue_output: OUT STD_LOGIC);

END ENTITY MAIN;


ARCHITECTURE behvaiour OF MAIN IS
	
	SIGNAL bird_red, bird_green, bird_blue, t_bird_on: STD_LOGIC;
	SIGNAL pipe_red, pipe_green, pipe_blue, t_pipe_on: STD_LOGIC;
	
	COMPONENT BIRD IS
		PORT(clk, vert_sync: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			red, green, blue, bird_on: OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT PIPE IS
		PORT(clk, horz_sync: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, green, blue, pipe_on: OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN 
	
	bird_component: BIRD
						PORT MAP(
							clk => clk_input,
							vert_sync => vertical_sync,
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => bird_red,
							green => bird_green,
							blue => bird_blue,
							bird_on => t_bird_on
						);
	
	pipe_component: PIPE
						PORT MAP(
							clk => clk_input,
							horz_sync => vertical_sync,
							pixel_row => pixel_row_input,
							pixel_column => pixel_column_input,
							red => pipe_red,
							green => pipe_green,
							blue => pipe_blue,
							pipe_on => t_pipe_on
						);
						
						
--	red_output <= bird_red when t_bird_on = '1' else '0';
--	green_output <= bird_green when t_bird_on = '1' else '1';
--	blue_output <= bird_blue when t_bird_on = '1' else '1';
	
	red_output <= pipe_red when t_pipe_on = '1' else '0';
	green_output <= pipe_green when t_pipe_on = '1' else '1';
	blue_output <= pipe_blue when t_pipe_on = '1' else '1';
	
END ARCHITECTURE;
	
	