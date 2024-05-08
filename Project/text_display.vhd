LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY text_display IS
	PORT(Clk, enable, size: IN STD_LOGIC;
			input_address: IN STD_LOGIC_VECTOR(5 downto 0);
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			row_start, row_stop, col_start, col_stop: IN STD_LOGIC_VECTOR(9 downto 0);
			red, blue, green, text_on: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behaviour OF text_display IS
	SIGNAL t_text_on, char_output: STD_LOGIC;
	SIGNAL t_font_row, t_font_col: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL t_address: STD_LOGIC_VECTOR(5 downto 0);
	
	COMPONENT char_rom IS
		PORT(
			character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			clock				: 	IN STD_LOGIC ;
			rom_mux_output		:	OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN
	
	char_comp: char_rom PORT MAP(
		character_address =>  t_address,
		font_row => t_font_row,
		font_col => t_font_col,
		clock => clk,
		rom_mux_output => char_output);
		
	blue <= '0';
	green <= '0';
	

	t_text_on <= char_output WHEN (pixel_row >= row_start and pixel_row <= row_stop
											and pixel_column >= col_start and pixel_column <= col_stop) ELSE '0';
	t_address <= ("0" & input_address(5 downto 1)) when size = '1' ELSE input_address(5 downto 0);
	t_font_row <= pixel_row(4 downto 2) when size = '1' else pixel_row(3 downto 1);
	t_font_col <= pixel_column(3 downto 1);		
	red <= t_text_on;
	text_on <= t_text_on;
END ARCHITECTURE behaviour;
			
		