LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY background IS
	PORT
		( clk, vert_sync, horz_sync	: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END background;

architecture behavior of background is

SIGNAL cloud_on					: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL cloud_y_pos				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos				: std_logic_vector(10 DOWNTO 0);

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(20,10);

cloud_x_pos <= CONV_STD_LOGIC_VECTOR(540,11);

cloud_on <= '1' when ( ('0' & cloud_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & cloud_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos <= pixel_row + size) and ('0' & pixel_row <= cloud_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
-- Colours for pixel data on video signal

Red <=  cloud_on;
Green <= '1';
Blue <=  '1';

END behavior;