LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY background IS
	PORT
		( clk, vert_sync, horz_sync	: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue, cloud_on 			: OUT std_logic);		
END background;

architecture behavior of background is

SIGNAL cloud_on_a					: std_logic;
SIGNAL cloud_on_b					: std_logic;
SIGNAL cloud_on_c					: std_logic;
SIGNAL cloud_on_d				: std_logic;
SIGNAL size 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL cloud_y_pos_a				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos_a				: std_logic_vector(10 DOWNTO 0);
SIGNAL cloud_y_pos_b				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos_b				: std_logic_vector(10 DOWNTO 0);
SIGNAL cloud_y_pos_c				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos_c				: std_logic_vector(10 DOWNTO 0);
SIGNAL cloud_y_pos_d				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos_d				: std_logic_vector(10 DOWNTO 0);

BEGIN           

size <= CONV_STD_LOGIC_VECTOR(20,10);

cloud_x_pos_a <= CONV_STD_LOGIC_VECTOR(500,11);
cloud_y_pos_a <= CONV_STD_LOGIC_VECTOR(200,10);

cloud_x_pos_b <= CONV_STD_LOGIC_VECTOR(500,11);
cloud_y_pos_b <= CONV_STD_LOGIC_VECTOR(240,10);

cloud_x_pos_c <= CONV_STD_LOGIC_VECTOR(540,11);
cloud_y_pos_c <= CONV_STD_LOGIC_VECTOR(240,10);

cloud_x_pos_d <= CONV_STD_LOGIC_VECTOR(460,11);
cloud_y_pos_d <= CONV_STD_LOGIC_VECTOR(240,10);


cloud_on_a <= '1' when ( ('0' & cloud_x_pos_a <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & cloud_x_pos_a + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_a <= pixel_row + size) and ('0' & pixel_row <= cloud_y_pos_a + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
cloud_on_b <= '1' when ( ('0' & cloud_x_pos_b <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & cloud_x_pos_b + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_b <= pixel_row + size) and ('0' & pixel_row <= cloud_y_pos_b + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
cloud_on_c <= '1' when ( ('0' & cloud_x_pos_c <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & cloud_x_pos_c + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_c <= pixel_row + size) and ('0' & pixel_row <= cloud_y_pos_c + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
cloud_on_d <= '1' when ( ('0' & cloud_x_pos_d <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & cloud_x_pos_d + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_d <= pixel_row + size) and ('0' & pixel_row <= cloud_y_pos_d + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
-- Colours for pixel data on video signal
--Red <=  cloud_on_a or cloud_on_b or cloud_on_c or cloud_on_d;
Red <=  '1';
Green <= '1';
Blue <=  '1';

cloud_on <= cloud_on_a or cloud_on_b or cloud_on_c or cloud_on_d;

END behavior;