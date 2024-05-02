LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY COLOUR_SWITCHER IS
	PORT(clk, switch_1, switch_2, switch_3: IN STD_LOGIC;
		red_output, green_output, blue_output, horizontal_sync, vertical_sync: OUT STD_LOGIC);
END ENTITY COLOUR_SWITCHER;

ARCHITECTURE behaviour OF COLOUR_SWITCHER IS

	COMPONENT CLOCK_DIVIDER IS
		PORT(clk_input: IN STD_LOGIC;
			clk_output: OUT STD_LOGIC);
	END COMPONENT;
	
--	COMPONENT VGA_SYNC IS
--		PORT(clock_25Mhz, red, green, blue: IN STD_LOGIC;
--				red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: OUT STD_LOGIC;
--				pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
--	END COMPONENT;
	
	SIGNAL t_clk, t_red_output, t_green_output, t_blue_output, t_horizontal_sync, t_vertical_sync: STD_LOGIC;
	SIGNAL t_pixel_row, t_pixel_column: STD_LOGIC_VECTOR(9 downto 0);
	
BEGIN

--	FINAL_VGA_SYNC: VGA_SYNC
--						PORT MAP(
--							clock_25Mhz => t_clk,
--							red => switch_1,
--							green => switch_2,
--							blue => switch_3,
--							red_out => t_red_output,
--							green_out => t_green_output,
--							blue_out => t_blue_output,	
--							horiz_sync_out => t_horizontal_sync,
--							vert_sync_out => t_vertical_sync,
--							pixel_row => t_pixel_row,
--							pixel_column => t_pixel_column
--						);
	
	DIVIDED_CLOCK: CLOCK_DIVIDER
						PORT MAP(
							clk_input => clk,
							clk_output => t_clk
						);
	
--	red_output <= t_red_output;
--	green_output <= t_green_output;
--	blue_output <= t_blue_output;
--	horizontal_sync <= t_horizontal_sync;
--	vertical_sync <= t_vertical_sync;
	
END ARCHITECTURE;