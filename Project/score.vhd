LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;


ENTITY SCORE IS

  PORT(bird_pass, score_reset, collision: IN STD_LOGIC;
        current_score: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));

END ENTITY SCORE;

ARCHITECTURE behaviour OF SCORE IS

  SIGNAL temp_score: STD_LOGIC_VECTOR(7 DOWNTO 0):= CONV_STD_LOGIC_VECTOR(0, 8);
  
BEGIN
  temp_score <= (temp_score + CONV_STD_LOGIC_VECTOR(1, 8)) WHEN (bird_pass = '1' AND collision = '0') ELSE
                CONV_STD_LOGIC_VECTOR(0, 8) WHEN score_reset = '1' ELSE
                temp_score;

  current_score <= temp_score;

END ARCHITECTURE behaviour;