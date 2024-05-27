LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;



ENTITY power_up IS

  PORT (bird_on, clk, vert_sync, enable, pipe_quarterway: IN STD_LOGIC;
        score: IN INTEGER RANGE 999 DOWNTO 0;
        gap_y_pos: IN STD_LOGIC_VECTOR(9 DOWNTO 0); 
        pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        red, green, blue: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        power_up_on : OUT STD_LOGIC);

END ENTITY power_up;


architecture behaviour of power_up is

SIGNAL power_up_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL power_up_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL size: STD_LOGIC_VECTOR(9 DOWNTO 0);
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

size <= CONV_STD_LOGIC_VECTOR(15, 10);
power_up_x_pos <= CONV_STD_LOGIC_VECTOR(313, 11);
power_up_y_pos <= gap_y_pos;

power_up_sprite: heart_rom PORT MAP(
    font_row => pixel_row(4 DOWNTO 1) - (power_up_x_pos(4 downto 1) + size(4 downto 1)),
    --font_col => pixel_column(4 DOWNTO 1) - (power_up_y_pos(4 downto 1) + size(4 downto 1)),
    font_col => pixel_column(4 DOWNTO 1),
    clock => clk,
    heart_data_alpha => t_power_up_alpha,
    heart_data_red =>   t_power_up_red,
    heart_data_green => t_power_up_green,
    heart_data_blue =>  t_power_up_blue
);


power_up_on <= '1' when ((score /= 0) AND (score mod 5 = 0)) AND (enable = '1') AND 
                ('0' & power_up_x_pos <= '0' & pixel_column + size - 1) AND
                ('0' & pixel_column <= '0' & power_up_x_pos + size) AND
                ('0' & power_up_y_pos <= pixel_row + size) AND
                (pixel_row <= power_up_y_pos + size + 1) AND
                (t_power_up_alpha = "0001") else '0';

red <=    t_power_up_red;
blue <=   t_power_up_blue;
green <=  t_power_up_green;


end behaviour;