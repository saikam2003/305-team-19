LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


-- This entity will handle the logic where the lives of the player
-- are displayed as hearts. Every time the player collides once, 
-- exactly one perfect heart is deleted and displayed on the screen.
ENTITY HEART IS 
PORT(
    clk, vert_sync, mouse_clicked, colour_input: IN STD_LOGIC;
    pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    collision_counter : IN INTEGER RANGE 0 TO 3;
    red, green, blue : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    heart_on: OUT STD_LOGIC
);
END ENTITY HEART;

ARCHITECTURE behaviour OF HEART IS
-- signal definitions for the heart
SIGNAL ball_on: STD_LOGIC;
SIGNAL size: UNSIGNED(9 DOWNTO 0);
SIGNAL size_times_6: UNSIGNED(9 DOWNTO 0);
SIGNAL heart_x_pos: UNSIGNED(10 DOWNTO 0);
SIGNAL heart_y_pos: UNSIGNED(9 DOWNTO 0);

SIGNAL t_heart_alpha: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_heart_red: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_heart_green : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_heart_blue: STD_LOGIC_VECTOR(3 DOWNTO 0);

-- importing the heart component to fetch the data from the mif file
-- that contains the information of the heart sprite
COMPONENT heart_rom IS
PORT(
    font_row, font_col: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    clock: IN STD_LOGIC;
    heart_data_alpha: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    heart_data_red: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    heart_data_green: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    heart_data_blue: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
);
END COMPONENT;

BEGIN
-- mapping the correct signals to the heart_rom
heart_sprite: heart_rom PORT MAP(
    font_row => pixel_row(4 DOWNTO 1),
    font_col => pixel_column(4 DOWNTO 1),
    clock => clk,
    heart_data_alpha => t_heart_alpha,
    heart_data_red => t_heart_red,
    heart_data_green => t_heart_green,
    heart_data_blue => t_heart_blue
);

-- defining the vertical size for the 32x32 hearts
size <= to_unsigned(15, 10);

-- the hearts will be displayed in the top right of the screen

-- setting the x position as the end of the rightmost heart
heart_x_pos <= to_unsigned(608, 11);
-- setting an appropriate y position for the hearts
heart_y_pos <= to_unsigned(47, 10);
-- defining the horizontal size of the hearts from the right-end
-- this is 3 times 32 width heart
size_times_6 <= to_unsigned(96, 10);

-- heart is only on when it is within a certain range on the screen and when the alpha signal 1,
-- which means the heart is not transparent in those pixels
heart_on <= '1' WHEN ( 
    (unsigned('0' & heart_x_pos) <= unsigned('0' & pixel_column) + size_times_6 - (32*collision_counter) - 1) AND
    (unsigned('0' & pixel_column) <= unsigned('0' & heart_x_pos)) AND
    (unsigned('0' & heart_y_pos) <= unsigned(pixel_row) + size) AND
    (unsigned(pixel_row) <= unsigned(heart_y_pos) + size + 1) AND
    (t_heart_alpha = "0001")
) ELSE '0';

-- assigning the colors of the heart as output
red <= t_heart_red;
blue <= t_heart_blue;
green <= t_heart_green;

END behaviour;