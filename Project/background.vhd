LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY background IS
	PORT
		( clk, enable, vert_sync, horz_sync	: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue : OUT STD_LOGIC_VECTOR(3 downto 0);
		  background_on 			: OUT std_logic);		
END background;

architecture behavior of background is

-- 	SIGNAL cloud_red_1, cloud_green_1, cloud_blue_1: STD_LOGIC_VECTOR(3 DOWNTO 0);
-- 	SIGNAL cloud_red_2, cloud_green_2, cloud_blue_2: STD_LOGIC_VECTOR(3 DOWNTO 0);
-- 	SIGNAL cloud_red_3, cloud_green_3, cloud_blue_3: STD_LOGIC_VECTOR(3 DOWNTO 0);
-- 	SIGNAL ground_on, grass_on, t_cloud_on_1, t_cloud_on_2, t_cloud_on_3 : STD_LOGIC;
-- 	SIGNAL grass : STD_LOGIC_VECTOR(11 downto 0) := "000001100000";
-- 	SIGNAL ground : STD_LOGIC_VECTOR(11 downto 0) := "010000100000";
	
-- 	-- signals for the custom cloud sprite
-- 	SIGNAL t_cloud_sprite_on : STD_LOGIC;
-- 	SIGNAL cloud_sprite_x_pos : STD_LOGIC_VECTOR(10 DOWNTO 0);
-- 	SIGNAL cloud_sprite_y_pos : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(239,10);
-- 	SIGNAL cloud_sprte_size : STD_LOGIC_VECTOR(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(32, 10);
-- 	SIGNAL cloud_sprite_x_motion : STD_LOGIC_VECTOR(10 DOWNTO 0);
-- 	SIGNAL t_cloud_sprite_alpha,t_cloud_sprite_red,t_cloud_sprite_green,t_cloud_sprite_blue : STD_LOGIC_VECTOR(3 DOWNTO 0); 


-- 	-- old cloud
-- 	COMPONENT cloud IS
-- 		PORT
-- 			( clk, enable, vert_sync 						: IN std_logic;
-- 			  top_x_pos, top_y_pos  : IN integer range 0 to 639;
-- 			  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
-- 			  red, green, blue : OUT std_logic_vector(3 downto 0);
-- 			  cloud_on 			: OUT std_logic);		
-- 	END COMPONENT;
	
-- 	-- custom cloud sprite
-- 	COMPONENT cloud_rom IS
-- 		PORT(
-- 				font_row	:	IN STD_LOGIC_VECTOR (7 DOWNTO 0);
-- 				font_col	:	IN STD_LOGIC_VECTOR (3 DOWNTO 0);
-- 				clock				: 	IN STD_LOGIC ;
-- 				cloud_data_alpha		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
-- 				cloud_data_red		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
-- 				cloud_data_green		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
-- 				cloud_data_blue		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
-- 			);		
-- 	END COMPONENT;
	
BEGIN          
-- 	cloud_sprite: CLOUD_ROM
-- 						PORT MAP (
-- 								font_row => pixel_row(7 DOWNTO 0),
-- 								font_col => pixel_column(3 DOWNTO 0),
-- 								clock => clk,								
-- 								cloud_data_alpha => t_cloud_sprite_alpha,
-- 								cloud_data_red	=> t_cloud_sprite_red,
-- 								cloud_data_green => t_cloud_sprite_green,
-- 								cloud_data_blue	=> t_cloud_sprite_blue
-- 							);
				
-- 	cloud_component: CLOUD
-- 						  PORT MAP (
-- 								clk => clk,
-- 								enable => enable,
-- 								vert_sync => vert_sync,
-- 								top_x_pos => 550,
-- 								top_y_pos => 200,
-- 								pixel_row => pixel_row,
-- 								pixel_column => pixel_column,
-- 								red => cloud_red_1,
-- 								green => cloud_green_1,
-- 								blue => cloud_blue_1,
-- 								cloud_on => t_cloud_on_1
-- 							);
-- 	cloud_component_2: CLOUD
-- 						  PORT MAP (
-- 								clk => clk,
-- 								enable => enable,
-- 								vert_sync => vert_sync,
-- 								top_x_pos => 150,
-- 								top_y_pos => 300,
-- 								pixel_row => pixel_row,
-- 								pixel_column => pixel_column,
-- 								red => cloud_red_2,
-- 								green => cloud_green_2,
-- 								blue => cloud_blue_2,
-- 								cloud_on => t_cloud_on_2
-- 							);

-- 	cloud_component_3: CLOUD
-- 						  PORT MAP (
-- 								clk => clk,
-- 								enable => enable,
-- 								vert_sync => vert_sync,
-- 								top_x_pos => 350,
-- 								top_y_pos => 150,
-- 								pixel_row => pixel_row,
-- 								pixel_column => pixel_column,
-- 								red => cloud_red_3,
-- 								green => cloud_green_3,
-- 								blue => cloud_blue_3,
-- 								cloud_on => t_cloud_on_3
-- 							);
							
		
	
-- 	grass_on <= '1' when pixel_row >= CONV_STD_LOGIC_VECTOR(454,10) and pixel_row < CONV_STD_LOGIC_VECTOR(459,10) else '0';
-- 	ground_on <= '1' when pixel_row >= CONV_STD_LOGIC_VECTOR(459,10) else '0';
	
	
-- 	background_on <= t_cloud_sprite_on or t_cloud_on_1 or t_cloud_on_2 or t_cloud_on_3 or ground_on or grass_on;

-- 	--t_cloud_sprite_on <= '1' when ('0' & )
-- 	--						t_cloud_sprite_alpha = "0001" else '0';
							
-- 	t_cloud_sprite_on <= '1' WHEN ( ('0' & cloud_sprite_x_pos <= '0' & pixel_column + cloud_sprte_size) AND ('0' & pixel_column <= '0' & cloud_sprite_x_pos + cloud_sprte_size) 	-- x_pos - size <= pixel_column <= x_pos + size
-- 					AND ('0' & cloud_sprite_y_pos <= pixel_row + cloud_sprte_size) AND ('0' & pixel_row <= cloud_sprite_y_pos + cloud_sprte_size) AND (t_cloud_sprite_alpha = "0001") )  ELSE	-- y_pos - size <= pixel_row <= y_pos + size
-- 			'0';
	
	
-- 	Move_Cloud_Sprite: PROCESS(vert_sync)
-- 	variable pos_init_flag : STD_LOGIC := '0';
-- 		variable half_counter: integer range 0 to 5:= 0;
-- 		BEGIN 
-- 			IF (RISING_EDGE(vert_sync)) THEN
-- 					IF (pos_init_flag = '1') THEN
-- 						half_counter := half_counter + 1;
-- 						If(half_counter  = 5) THEN
-- 								IF(cloud_sprite_x_pos + t_cloud_sprite_alpha < -CONV_STD_LOGIC_VECTOR(100,11)) THEN
-- 									cloud_sprite_x_pos <= CONV_STD_LOGIC_VECTOR(669 , 11);
-- 								ELSE
-- 									cloud_sprite_x_pos <= cloud_sprite_x_pos + cloud_sprite_x_motion;
-- 								half_counter := 0;
-- 								END IF;
-- 						END IF;
-- 					ELSE 
-- 						pos_init_flag := '1';
-- 						cloud_sprite_x_pos <= CONV_STD_LOGIC_VECTOR(500,11);

-- 					END IF;
-- 			END IF;  
-- 	END PROCESS Move_Cloud_Sprite;
	
-- 	background_display: PROCESS(clk)
-- 	BEGIN
-- 		IF (RISING_EDGE(clk)) THEN
-- 			IF (t_cloud_sprite_on = '1') THEN
-- 				red   <=  t_cloud_sprite_red;
-- 				green <=  t_cloud_sprite_green;
-- 				blue  <=  t_cloud_sprite_blue;
-- 			ELSIF (t_cloud_on_1 = '1') THEN
-- 				red   <=  cloud_red_1;
-- 				green <=  cloud_green_1;
-- 				blue  <=  cloud_blue_1;
-- 			ELSIF (t_cloud_on_2 = '1') THEN
-- 				red   <=  cloud_red_2;
-- 				green <=  cloud_green_2;
-- 				blue  <=  cloud_blue_2;
-- 			ELSIF (t_cloud_on_3 = '1') THEN
-- 				red   <=  cloud_red_3;
-- 				green <=  cloud_green_3;
-- 				blue  <=  cloud_blue_3;
-- 			ELSIF (ground_on = '1') THEN
-- 				red <= ground(11 downto 8);
-- 				green <= ground(7 downto 4);
-- 				blue <= ground(3 downto 0);
-- 			ELSIF (grass_on = '1') THEN
-- 				red <= grass(11 downto 8);
-- 				green <= grass(7 downto 4);
-- 				blue <= grass(3 downto 0);
-- 			ELSE
-- 				red <= "0000";
-- 				green <= "1100";
-- 				blue <= "1011";
-- 			END IF;
-- 		END IF;
-- 	END PROCESS background_display;

END behavior;