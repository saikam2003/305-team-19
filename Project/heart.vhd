LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

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
SIGNAL ball_on: STD_LOGIC;
SIGNAL size: UNSIGNED(9 DOWNTO 0);
SIGNAL size_times_6: UNSIGNED(9 DOWNTO 0);
SIGNAL heart_x_pos: UNSIGNED(10 DOWNTO 0);
SIGNAL heart_y_pos: UNSIGNED(9 DOWNTO 0);

SIGNAL t_heart_alpha: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_heart_red: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_heart_green : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_heart_blue: STD_LOGIC_VECTOR(3 DOWNTO 0);

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
heart_sprite: heart_rom PORT MAP(
    font_row => pixel_row(4 DOWNTO 1),
    font_col => pixel_column(4 DOWNTO 1),
    clock => clk,
    heart_data_alpha => t_heart_alpha,
    heart_data_red => t_heart_red,
    heart_data_green => t_heart_green,
    heart_data_blue => t_heart_blue
);

size <= to_unsigned(15, 10);
heart_x_pos <= to_unsigned(608, 11);
heart_y_pos <= to_unsigned(47, 10);
size_times_6 <= to_unsigned(96, 10);

heart_on <= '1' WHEN ( 
    (unsigned('0' & heart_x_pos) <= unsigned('0' & pixel_column) + size_times_6 - (32*collision_counter) - 1) AND
    (unsigned('0' & pixel_column) <= unsigned('0' & heart_x_pos)) AND
    (unsigned('0' & heart_y_pos) <= unsigned(pixel_row) + size) AND
    (unsigned(pixel_row) <= unsigned(heart_y_pos) + size + 1) AND
    (t_heart_alpha = "0001")
) ELSE '0';

red <= t_heart_red;
blue <= t_heart_blue;
green <= t_heart_green;

END behaviour;
