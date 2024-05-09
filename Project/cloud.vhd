LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY cloud IS
	PORT
		( clk 						: IN std_logic;
		  top_x_pos, top_y_pos  : IN integer range 0 to 639;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue : OUT std_logic_vector(3 DOWNTO 0);
		  cloud_on 			: OUT std_logic);		
END cloud;

architecture behavior of cloud is

SIGNAL cloud_on_a					: std_logic;
SIGNAL cloud_on_b					: std_logic;
SIGNAL cloud_on_c					: std_logic;
SIGNAL size_a 						: std_logic_vector(9 DOWNTO 0);  
SIGNAL size_b_horizontal 		: std_logic_vector(9 DOWNTO 0);  
SIGNAL size_c 						: std_logic_vector(9 DOWNTO 0);  
SIGNAL cloud_y_pos_a				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos_a				: std_logic_vector(10 DOWNTO 0);
SIGNAL cloud_y_pos_b				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos_b				: std_logic_vector(10 DOWNTO 0);
SIGNAL cloud_y_pos_c				: std_logic_vector(9 DOWNTO 0);
SiGNAL cloud_x_pos_c				: std_logic_vector(10 DOWNTO 0);
--constant top_cloud_x 				: integer range 0 to 639 := 500;
--constant top_cloud_y 				: integer range 0 to 639 := 200;

BEGIN           

size_a <= CONV_STD_LOGIC_VECTOR(10,10);
size_b_horizontal <= CONV_STD_LOGIC_VECTOR(30,10);
size_c <= CONV_STD_LOGIC_VECTOR(5,10);

----top box where x = 500, y = 200
--cloud_x_pos_a <= CONV_STD_LOGIC_VECTOR(top_cloud_x,11);
--cloud_y_pos_a <= CONV_STD_LOGIC_VECTOR(top_cloud_y,10);

--taking input from the file that will use this as a component
cloud_x_pos_a <= CONV_STD_LOGIC_VECTOR(top_x_pos,11);
cloud_y_pos_a <= CONV_STD_LOGIC_VECTOR(top_y_pos,10);

--bottom
cloud_x_pos_b <= CONV_STD_LOGIC_VECTOR(top_x_pos,11);
cloud_y_pos_b <= CONV_STD_LOGIC_VECTOR(top_y_pos + 20,10);

--right
cloud_x_pos_c <= CONV_STD_LOGIC_VECTOR(top_x_pos + 35,11);
cloud_y_pos_c <= CONV_STD_LOGIC_VECTOR(top_y_pos + 25,10);

cloud_on_a <= '1' when ( ('0' & cloud_x_pos_a <= '0' & pixel_column + size_a) and ('0' & pixel_column <= '0' & cloud_x_pos_a + size_a) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_a <= pixel_row + size_a) and ('0' & pixel_row <= cloud_y_pos_a + size_a) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
cloud_on_b <= '1' when ( ('0' & cloud_x_pos_b <= '0' & pixel_column + size_b_horizontal) and ('0' & pixel_column <= '0' & cloud_x_pos_b + size_b_horizontal) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_b <= pixel_row + size_a) and ('0' & pixel_row <= cloud_y_pos_b + size_a) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
cloud_on_c <= '1' when ( ('0' & cloud_x_pos_c <= '0' & pixel_column + size_c) and ('0' & pixel_column <= '0' & cloud_x_pos_c + size_c) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_c <= pixel_row + size_c) and ('0' & pixel_row <= cloud_y_pos_c + size_c) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
-- Colours for pixel data on video signal
--Red <=  cloud_on_a or cloud_on_b or cloud_on_c or cloud_on_d;
Red <=  "1111";
Green <= "1111";
Blue <=  "1111";

cloud_on <= cloud_on_a or cloud_on_b or cloud_on_c;

END behavior;

