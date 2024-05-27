LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;

-- This entity contains the logic for power-ups within the game. The power
-- ups in this game will be a heart that appears every 7 pipes which will add a life
-- when the player touches the same

ENTITY power_up IS

  PORT (bird_on, clk, vert_sync, enable, pipe_quarterway: IN STD_LOGIC;
        current_level: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
        pipe_horz_pos: IN STD_LOGIC_VECTOR(10 DOWNTO 0); 
        score: IN INTEGER RANGE 999 DOWNTO 0;
        gap_y_pos, bird_y_pos: IN STD_LOGIC_VECTOR(9 DOWNTO 0); 
        pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        red, green, blue: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        power_up_on, power_up_flag : OUT STD_LOGIC);

END ENTITY power_up;


architecture behaviour of power_up is

-- signal definitions for the logic
SIGNAL power_up_x_pos: STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL power_up_y_pos: STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL size: STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL t_power_up_alpha: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_power_up_red: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_power_up_green : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL t_power_up_blue: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL power_up_x_motion: STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL t_power_up_on, t_power_up_flag: STD_LOGIC;

-- importing component heart_rom to fetch data from the mif file
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

    -- size of the power up is 16x16
    size <= CONV_STD_LOGIC_VECTOR(7 , 10);
    power_up_y_pos <= gap_y_pos; -- y position is same as the center of the gap of input pipe

    -- the speed of the power up changes based on the current difficulty
    power_up_x_motion <=	- CONV_STD_LOGIC_VECTOR(2, 11) WHEN current_level = "10" ELSE
                            - CONV_STD_LOGIC_VECTOR(3, 11) WHEN current_level = "11" ELSE
                            - CONV_STD_LOGIC_VECTOR(1, 11);

    -- mapping the signals to the heart_rom
    power_up_sprite: heart_rom PORT MAP(
        font_row => pixel_row(3 DOWNTO 0) - (power_up_y_pos(3 downto 0) + size(3 downto 0) + CONV_STD_LOGIC_VECTOR(2,4)),   
        -- font_col => pixel_column(4 DOWNTO 1) - CONV_STD_LOGIC_VECTOR(4,4),
        font_col => pixel_column(3 DOWNTO 0) - (power_up_x_pos(3 downto 0) + size(3 downto 0)),
        --font_col => pixel_column(4 DOWNTO 1),
        clock => clk,
        heart_data_alpha => t_power_up_alpha,
        heart_data_red =>   t_power_up_red,
        heart_data_green => t_power_up_green,
        heart_data_blue =>  t_power_up_blue
    );

    -- the power up will follow the input pipe by a horizontal offset
    power_up_x_pos <= pipe_horz_pos + CONV_STD_LOGIC_VECTOR(240, 11);
    
    -- the power up will turn on only every 7 pipes, when the game is not paused, and within a certain 
    -- area of the screen
    t_power_up_on <= '1'  when ((score /= 0) AND (score mod 3 = 0)) AND (enable = '1') AND
                ('0' & power_up_x_pos <= '0' & pixel_column + size + CONV_STD_LOGIC_VECTOR(1,10)) AND
                ('0' & pixel_column <= '0' & power_up_x_pos + size ) AND
                ('0' & power_up_y_pos <= pixel_row + size ) AND
                (pixel_row <= power_up_y_pos + size + CONV_STD_LOGIC_VECTOR(1,10)) AND
                (t_power_up_alpha = "0001") else '0';

    power_up_on <= t_power_up_on;

    PROCESS (clk)

    BEGIN
        IF (RISING_EDGE(clk)) THEN
        
            IF ((power_up_x_pos >= CONV_STD_LOGIC_VECTOR(295, 11)) AND (power_up_x_pos <= CONV_STD_LOGIC_VECTOR(331, 11))) THEN
                IF ((bird_y_pos - CONV_STD_LOGIC_VECTOR(7, 10) <= power_up_y_pos + size) AND (bird_y_pos + CONV_STD_LOGIC_VECTOR(7, 10) >= power_up_y_pos - size)) THEN
                    t_power_up_flag <= '1';
                ELSE
                    t_power_up_flag <= '0';
                END If;
            END IF;
        END IF;
        power_up_flag <= t_power_up_flag;
    END PROCESS;


    -- assigning the colors
    red <=    t_power_up_red;
    blue <=   t_power_up_blue;
    green <=  t_power_up_green;

end behaviour;