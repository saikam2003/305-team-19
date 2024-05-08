LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY text IS
	PORT(Clk, enable: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, blue, green, text_on: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behaviour OF text IS
	SIGNAL t_text_on: STD_LOGIC;
	
	COMPONENT char_rom IS
		PORT(
			character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			clock				: 	IN STD_LOGIC ;
			rom_mux_output		:	OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN
	
	char_comp: char_rom PORT MAP(
		character_address => pixel_row(9 downto 4),
		font_row => pixel_row(3 downto 1),
		font_col => pixel_column(3 downto 1),
		clock => clk,
		rom_mux_output => t_text_on);
		
	blue <= '0';
	green <= '0';
	
	red <= t_text_on;
	text_on <= t_text_on;
END ARCHITECTURE behaviour;
			
		