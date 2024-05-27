LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

-- This entity handles the logic to display the background sprite
ENTITY background IS
	PORT
		( clk, enable, vert_sync, horz_sync	: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue : OUT STD_LOGIC_VECTOR(3 downto 0);
		  background_on 			: OUT std_logic);		
END background;

architecture behavior of background is

	-- signal definitions for the transparency, red, green and blue for the background
	SIGNAL t_bg_alpha, t_bg_red, t_bg_blue,  t_bg_green: STD_LOGIC_VECTOR(3 DOWNTO 0);

		-- importing the custom bacground rom component that will fetch the data for the 
		-- colors of the pixels of the background.
	COMPONENT custom_bg_rom
		PORT(
        font_row:    IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        font_col:    IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        clock                :     IN STD_LOGIC ;
        background_data_alpha        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        background_data_red        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        background_data_green        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        background_data_blue        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
	END COMPONENT;
	
BEGIN
	
	-- the background should always be ON
	background_on <= '1';
	
	background_sprite: custom_bg_rom PORT MAP
									(
										font_row => pixel_row,
										font_col => pixel_column,
										clock => clk,
										background_data_alpha => t_bg_alpha,
										background_data_red => t_bg_red,
										background_data_green => t_bg_green,
										background_data_blue => t_bg_blue
									);

	background_display: PROCESS(clk)
	BEGIN
		IF (RISING_EDGE(clk)) THEN
			red <= t_bg_red;
			green <= t_bg_green;
			blue <= t_bg_blue;
		END IF;
	END PROCESS background_display;

END behavior;