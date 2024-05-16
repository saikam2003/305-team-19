LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

ENTITY HEART IS 

	PORT(clk, vert_sync, mouse_clicked, colour_input: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
			red, green, blue : OUT STD_LOGIC_VECTOR(3 downto 0);
			heart_on: OUT STD_LOGIC
			--heart_y_position: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
			);

END ENTITY HEART;

ARCHITECTURE behaviour OF HEART IS
	
	SIGNAL ball_on: STD_LOGIC;
	SIGNAL size: STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(16,10);
	SIGNAL heart_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL heart_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
	
	SIGNAL t_heart_alpha	: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL t_heart_red	: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL t_heart_green : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL t_heart_blue	: STD_LOGIC_VECTOR(3 downto 0);
	
	
	
	COMPONENT heart_rom IS
		PORT
			(
				font_row, font_col	:	IN STD_LOGIC_VECTOR (3 DOWNTO 0);
				clock				: 	IN STD_LOGIC ;
				heart_data_alpha		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
				heart_data_red		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
				heart_data_green		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
				heart_data_blue		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
			);
	END COMPONENT;
			

BEGIN
	
	heart_sprite: heart_rom PORT MAP(
		font_row => pixel_row(4 downto 1) - (heart_y_pos(4 downto 1) + size(4 downto 1)) ,
		font_col => pixel_column(3 downto 0),
		clock => clk,
		heart_data_alpha	=>	t_heart_alpha,
		heart_data_red	=>		t_heart_red,
		heart_data_green	=>	t_heart_green,
		heart_data_blue	=>		t_heart_blue
	);
	
	
	heart_on <= '1' when ((pixel_row >= CONV_STD_LOGIC_VECTOR(19,10)) AND (pixel_row <= CONV_STD_LOGIC_VECTOR(51,10)) AND (pixel_column >= CONV_STD_LOGIC_VECTOR(549,10)) AND (pixel_column <= CONV_STD_LOGIC_VECTOR(581,10)) AND t_heart_alpha = "0001");
	
	red <= t_heart_red;
	blue <= t_heart_blue;
	green <= t_heart_green;
	
	
END behaviour;
