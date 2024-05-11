LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY cloud IS
	PORT
		( clk,enable,vert_sync 		: IN std_logic;
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

SIGNAL cloud_x_motion: STD_LOGIC_VECTOR(10 DOWNTO 0);

BEGIN           

size_a <= CONV_STD_LOGIC_VECTOR(10,10);
size_b_horizontal <= CONV_STD_LOGIC_VECTOR(30,10);
size_c <= CONV_STD_LOGIC_VECTOR(5,10);

----top box where x = 500, y = 200
--cloud_x_pos_a <= CONV_STD_LOGIC_VECTOR(top_cloud_x,11);
--cloud_y_pos_a <= CONV_STD_LOGIC_VECTOR(top_cloud_y,10);

--taking input from the file that will use this as a component
cloud_y_pos_a <= CONV_STD_LOGIC_VECTOR(top_y_pos,10);

--bottom
cloud_y_pos_b <= CONV_STD_LOGIC_VECTOR(top_y_pos + 20,10);

--right
cloud_y_pos_c <= CONV_STD_LOGIC_VECTOR(top_y_pos + 25,10);


cloud_x_motion <= - CONV_STD_LOGIC_VECTOR(1, 11);


cloud_on_a <= '1' when ( ('0' & cloud_x_pos_a <= '0' & pixel_column + size_a) and ('0' & pixel_column <= '0' & cloud_x_pos_a + size_a) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_a <= pixel_row + size_a) and ('0' & pixel_row <= cloud_y_pos_a + size_a) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
cloud_on_b <= '1' when ( ('0' & cloud_x_pos_b <= '0' & pixel_column + size_b_horizontal) and ('0' & pixel_column <= '0' & cloud_x_pos_b + size_b_horizontal) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_b <= pixel_row + size_a) and ('0' & pixel_row <= cloud_y_pos_b + size_a) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
			
cloud_on_c <= '1' when ( ('0' & cloud_x_pos_c <= '0' & pixel_column + size_c) and ('0' & pixel_column <= '0' & cloud_x_pos_c + size_c) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & cloud_y_pos_c <= pixel_row + size_c) and ('0' & pixel_row <= cloud_y_pos_c + size_c) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';
		
		
		Move_Cloud: PROCESS (vert_sync)
		variable pos_init_flag : STD_LOGIC := '0';
		variable half_counter: integer range 0 to 5:= 0;
		BEGIN 
			IF (RISING_EDGE(vert_sync)) THEN
			 IF (enable = '1') THEN
				IF (pos_init_flag = '1') THEN
					  half_counter := half_counter + 1;
					  If(half_counter  = 5) THEN
							IF(cloud_x_pos_a + size_a + size_c < CONV_STD_LOGIC_VECTOR(0,11)) THEN
								cloud_x_pos_a <= CONV_STD_LOGIC_VECTOR(669 , 11);
								cloud_x_pos_b <= CONV_STD_LOGIC_VECTOR(669 , 11);
								cloud_x_pos_c <= CONV_STD_LOGIC_VECTOR(704 , 11);
							ELSE
								cloud_x_pos_a <= cloud_x_pos_a + cloud_x_motion;
								cloud_x_pos_b <= cloud_x_pos_b + cloud_x_motion;
								cloud_x_pos_c <= cloud_x_pos_c + cloud_x_motion;
							half_counter := 0;
							END IF;
					  END IF;
				ELSE 
					pos_init_flag := '1';
					cloud_x_pos_a <= CONV_STD_LOGIC_VECTOR(top_x_pos,11);
					cloud_x_pos_b <= CONV_STD_LOGIC_VECTOR(top_x_pos,11);
					cloud_x_pos_c <= CONV_STD_LOGIC_VECTOR(top_x_pos + 35,11);

				END IF;
			END IF;
		END IF;  
		END PROCESS Move_Cloud;

-- Colours for pixel data on video signal
--Red <=  cloud_on_a or cloud_on_b or cloud_on_c or cloud_on_d;
Red <=  "1111";
Green <= "1111";
Blue <=  "1111";

cloud_on <= cloud_on_a or cloud_on_b or cloud_on_c;

END behavior;

