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

	SIGNAL cloud_red_1, cloud_green_1, cloud_blue_1: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL cloud_red_2, cloud_green_2, cloud_blue_2: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ground_on, grass_on, t_cloud_on_1, t_cloud_on_2 : STD_LOGIC;
	SIGNAL grass : STD_LOGIC_VECTOR(11 downto 0) := "000001100000";
	SIGNAL ground : STD_LOGIC_VECTOR(11 downto 0) := "010000100000";

	COMPONENT cloud IS
		PORT
			( clk, enable, vert_sync 						: IN std_logic;
			  top_x_pos, top_y_pos  : IN integer range 0 to 639;
			  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
			  red, green, blue : OUT std_logic_vector(3 downto 0);
			  cloud_on 			: OUT std_logic);		
	END COMPONENT;
	
BEGIN          
	cloud_component: CLOUD
						  PORT MAP (
								clk => clk,
								enable => enable,
								vert_sync => vert_sync,
								top_x_pos => 500,
								top_y_pos => 200,
								pixel_row => pixel_row,
								pixel_column => pixel_column,
								red => cloud_red_1,
								green => cloud_green_1,
								blue => cloud_blue_1,
								cloud_on => t_cloud_on_1
							);
	cloud_component_2: CLOUD
						  PORT MAP (
								clk => clk,
								enable => enable,
								vert_sync => vert_sync,
								top_x_pos => 200,
								top_y_pos => 400,
								pixel_row => pixel_row,
								pixel_column => pixel_column,
								red => cloud_red_2,
								green => cloud_green_2,
								blue => cloud_blue_2,
								cloud_on => t_cloud_on_2
							);
							
	
	grass_on <= '1' when pixel_row >= CONV_STD_LOGIC_VECTOR(454,10) and pixel_row < CONV_STD_LOGIC_VECTOR(459,10) else '0';
	ground_on <= '1' when pixel_row >= CONV_STD_LOGIC_VECTOR(459,10) else '0';
	
	
	background_on <= t_cloud_on_1 or t_cloud_on_2 or ground_on or grass_on;

	
	
	background_display: PROCESS(clk)
	BEGIN
		IF (RISING_EDGE(clk)) THEN
			IF (t_cloud_on_1 = '1') THEN
				red   <=  cloud_red_1;
				green <=  cloud_green_1;
				blue  <=  cloud_blue_1;
			ELSIF (t_cloud_on_2 = '1') THEN
				red   <=  cloud_red_2;
				green <=  cloud_green_2;
				blue  <=  cloud_blue_2;
			ELSIF (ground_on = '1') THEN
				red <= ground(11 downto 8);
				green <= ground(7 downto 4);
				blue <= ground(3 downto 0);
			ELSIF (grass_on = '1') THEN
				red <= grass(11 downto 8);
				green <= grass(7 downto 4);
				blue <= grass(3 downto 0);
			ELSE
				red <= "0000";
				green <= "1100";
				blue <= "1011";
			END IF;
		END IF;
	END PROCESS background_display;

END behavior;