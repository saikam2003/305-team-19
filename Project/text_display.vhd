LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY text_display IS
	PORT(Clk, enable: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, blue, green, text_on: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behaviour OF text_display IS
	SIGNAL t_text_on: STD_LOGIC;
	SIGNAL size_row, size_col: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL char_address_1, char_address_2, char_address_final: STD_LOGIC_VECTOR (5 DOWNTO 0);
	
	COMPONENT char_rom IS
		PORT(
			character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			clock				: 	IN STD_LOGIC ;
			rom_mux_output		:	OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN
	
	char_comp: char_rom PORT MAP(
		character_address => char_address_final,
		font_row => size_row,
		font_col => size_col,
		clock => clk,
		rom_mux_output => t_text_on);
		
	blue <= '0';
	green <= '0';
	
	red <= t_text_on;
	text_on <= t_text_on when (pixel_row <= 47 and pixel_column <= 300) else '0';
	char_address_final <= char_address_2 when (pixel_row <= 47 and pixel_row > 31) else char_address_1;
	size_row <= pixel_row(3 downto 1) when (pixel_row <= 47 and pixel_row > 31) else pixel_row(4 downto 2) ;
	size_col <= pixel_column(3 downto 1) when (pixel_row <= 47 and pixel_row > 31) else pixel_column(4 downto 2) ;
	with pixel_column(9 downto 5) select
		char_address_1 <= CONV_STD_LOGIC_VECTOR(7,6) when CONV_STD_LOGIC_VECTOR(0,5),
							 CONV_STD_LOGIC_VECTOR(1,6) when CONV_STD_LOGIC_VECTOR(1,5),
							 CONV_STD_LOGIC_VECTOR(13,6) when CONV_STD_LOGIC_VECTOR(2,5),
							 CONV_STD_LOGIC_VECTOR(5,6) when CONV_STD_LOGIC_VECTOR(3,5),
							 CONV_STD_LOGIC_VECTOR(32,6) when CONV_STD_LOGIC_VECTOR(4,5),
							 CONV_STD_LOGIC_VECTOR(15,6) when CONV_STD_LOGIC_VECTOR(5,5),
							 CONV_STD_LOGIC_VECTOR(22,6) when CONV_STD_LOGIC_VECTOR(6,5),
							 CONV_STD_LOGIC_VECTOR(5,6) when CONV_STD_LOGIC_VECTOR(7,5),
							 CONV_STD_LOGIC_VECTOR(18,6) when CONV_STD_LOGIC_VECTOR(8,5),
							 CONV_STD_LOGIC_VECTOR(32,6) when others;
							 
	with pixel_column(8 downto 4) select
		char_address_2 <= CONV_STD_LOGIC_VECTOR(18,6) when CONV_STD_LOGIC_VECTOR(0,5),
							 CONV_STD_LOGIC_VECTOR(5,6) when CONV_STD_LOGIC_VECTOR(1,5),
							 CONV_STD_LOGIC_VECTOR(19,6) when CONV_STD_LOGIC_VECTOR(2,5),
							 CONV_STD_LOGIC_VECTOR(20,6) when CONV_STD_LOGIC_VECTOR(3,5),
							 CONV_STD_LOGIC_VECTOR(1,6) when CONV_STD_LOGIC_VECTOR(4,5),
							 CONV_STD_LOGIC_VECTOR(18,6) when CONV_STD_LOGIC_VECTOR(5,5),
							 CONV_STD_LOGIC_VECTOR(20,6) when CONV_STD_LOGIC_VECTOR(6,5),
							 CONV_STD_LOGIC_VECTOR(32,6) when others;
END ARCHITECTURE behaviour;
			
		