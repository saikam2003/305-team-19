LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY background IS
	PORT
		( clk, vert_sync, horz_sync	: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue, background_on 			: OUT std_logic);		
END background;

architecture behavior of background is

	SIGNAL cloud_red_1, cloud_green_1, cloud_blue_1, t_cloud_on_1: STD_LOGIC;
	SIGNAL cloud_red_2, cloud_green_2, cloud_blue_2, t_cloud_on_2: STD_LOGIC;


	COMPONENT cloud IS
		PORT
			( clk 						: IN std_logic;
			  top_x_pos, top_y_pos  : IN integer range 0 to 639;
			  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
			  red, green, blue, cloud_on 			: OUT std_logic);		
	END COMPONENT;
	
BEGIN          
	cloud_component: CLOUD
						  PORT MAP (
								clk => clk,
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
								top_x_pos => 200,
								top_y_pos => 400,
								pixel_row => pixel_row,
								pixel_column => pixel_column,
								red => cloud_red_2,
								green => cloud_green_2,
								blue => cloud_blue_2,
								cloud_on => t_cloud_on_2
							);
							
	background_on <= t_cloud_on_1 or t_cloud_on_2;

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
			ELSE
				red <= '0';
				green <= '1';
				blue <= '1';
			END IF;
		END IF;
	END PROCESS background_display;

END behavior;