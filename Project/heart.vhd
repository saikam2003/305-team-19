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
	SIGNAL size: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL size_times_6: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL heart_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL heart_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
	
	SIGNAL t_heart_alpha	: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL t_heart_red		: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL t_heart_green 	: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL t_heart_blue		: STD_LOGIC_VECTOR(3 downto 0);
	
	
	
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
		font_row => pixel_row(3 downto 0),
		font_col => pixel_column(3 downto 0),
		clock => clk,
		heart_data_alpha	=>	t_heart_alpha,
		heart_data_red	=>		t_heart_red,
		heart_data_green	=>	t_heart_green,
		heart_data_blue	=>		t_heart_blue
	);
	
	size <= CONV_STD_LOGIC_VECTOR(7,10);
	--size_times_5 <= CONV_STD_LOGIC_VECTOR(39,10);
	--heart_x_pos <= CONV_STD_LOGIC_VECTOR(600,11);
	size_times_6 <= CONV_STD_LOGIC_VECTOR(48,10);
	heart_x_pos <= CONV_STD_LOGIC_VECTOR(608,11);
	heart_y_pos <= CONV_STD_LOGIC_VECTOR(39,10);
	
	
	--heart_on <= '1' WHEN ( ('0' & heart_x_pos <= '0' & pixel_column + size) AND ('0' & pixel_column <= '0' & heart_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
	--				AND ('0' & heart_y_pos <= pixel_row + size) AND ('0' & pixel_row <= heart_y_pos + size) AND (t_heart_alpha = "0001") )  ELSE	-- y_pos - size <= pixel_row <= y_pos + size
	--		'0';
			
	--Working Heart Code		
	--heart_on <= '1' WHEN ( ('0' & heart_x_pos <= '0' & pixel_column + size_times_5) AND ('0' & pixel_column<= '0' & heart_x_pos + size + CONV_STD_LOGIC_VECTOR(1,10)) 	-- x_pos - size <= pixel_column <= x_pos + size
	--				AND ('0' & heart_y_pos <= pixel_row + size) AND ('0' & pixel_row <= heart_y_pos + size + CONV_STD_LOGIC_VECTOR(1,10)) AND (t_heart_alpha = "0001") )  ELSE	-- y_pos - size <= pixel_row <= y_pos + size
	--		'0';
	
	heart_on <= '1' WHEN ( ('0' & heart_x_pos <= '0' & pixel_column + size_times_6 - CONV_STD_LOGIC_VECTOR(1,10)) AND ('0' & pixel_column <= '0' & heart_x_pos) 	-- x_pos - size <= pixel_column <= x_pos + size
					AND ('0' & heart_y_pos <= pixel_row + size) AND ('0' & pixel_row <= heart_y_pos + size + CONV_STD_LOGIC_VECTOR(1,10)) AND (t_heart_alpha = "0001") )  ELSE	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
	
	
	red <= t_heart_red;
	blue <= t_heart_blue;
	green <= t_heart_green;
	
	
END behaviour;
