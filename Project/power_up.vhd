LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY power_up IS

  PORT (bird_on, clk, vert_sync, enable, pipe_quarterway: IN STD_LOGIC;
        score: IN INTEGER RANGE 999 DOWNTO 0;
        gap_y_pos: IN STD_LOGIC_VECTOR(9 DOWNTO 0); 
        pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        red, green, blue: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
        power_up_on : OUT STD_LOGIC;

END ENTITY power_up;


architecture behaviour of power_up is

SIGNAL power_up_x_pos: UNSIGNED(10 DOWNTO 0);
SIGNAL power_up_y_pos: UNSIGNED(9 DOWNTO 0);
SIGNAL size: UNSIGNED(9 DOWNTO 0);
SIGNAL t_power_up_alpha: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_power_up_red: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_power_up_green : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_power_up_blue: STD_LOGIC_VECTOR(3 DOWNTO 0);


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

size <= to_unsigned(15, 10);
power_up_x_pos <= to_unsigned(313, 11);
power_up_y_pos <= to_unsigned(47, 10);

power_up_sprite: heart_rom PORT MAP(
    font_row => pixel_row(3 DOWNTO 0),
    font_col => pixel_column(3 DOWNTO 0),
    clock => clk,
    heart_data_alpha => t_power_up_alpha,
    heart_data_red =>   t_power_up_red,
    heart_data_green => t_power_up_green,
    heart_data_blue =>  t_power_up_blue
);


-- power_up_on <= '1' when (score mod 10 = 0) and (pipe_quarterway = '1') and (t_power_up_alpha = "0001") else 
--               '0';
power_up_on <= '1' when (score mod 10 = 0) and (pipe_quarterway = '1') AND (enable = '1') AND 
                (unsigned('0' & heart_x_pos) <= unsigned('0' & pixel_column) + size - 1) AND
                (unsigned('0' & pixel_column) <= unsigned('0' & heart_x_pos) + size) AND
                (unsigned('0' & heart_y_pos) <= unsigned(pixel_row) + size) AND
                (unsigned(pixel_row) <= unsigned(heart_y_pos) + size + 1) AND
                (t_heart_alpha = "0001") else '0';

red <=    t_power_up_red;
blue <=   t_power_up_blue;
green <=  t_power_up_green;


end behaviour;