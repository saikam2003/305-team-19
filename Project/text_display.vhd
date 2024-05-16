LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY text_display IS
	PORT(Clk, enable, select_option, game_mode: IN STD_LOGIC;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, blue, green : OUT STD_LOGIC_VECTOR(3 downto 0);
			text_on: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behaviour OF text_display IS
	SIGNAL t_text_on, char_1_on, char_2_on, char_3_on: STD_LOGIC;
	SIGNAL size_row, size_col: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL char_address_1, char_address_2, char_address_3, char_address_final: STD_LOGIC_VECTOR (5 DOWNTO 0);
	
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
	text_on <= t_text_on;
	blue  <= "0000" ;
	green <= (t_text_on,t_text_on,t_text_on,t_text_on) when t_text_on = '1' and char_2_on = '1' and select_option = '1' else 
				(t_text_on,t_text_on,t_text_on,t_text_on) when t_text_on = '1' and char_3_on = '1' and select_option = '0' else "0000";
	
	red <= (t_text_on,t_text_on,t_text_on,t_text_on);
	char_address_final <= char_address_1 when char_1_on = '1'  else 
								char_address_2 when char_2_on = '1' else
								char_address_3 when char_3_on = '1'else "100000";
	process(pixel_row,pixel_column)
	begin
		if(pixel_row >= 63 and pixel_row <= 95) then
			char_1_on <= '1';
			size_row <= pixel_row(4 downto 2);
			size_col <= pixel_column(4 downto 2);
			if(game_mode = '1') then
				case pixel_column(9 downto 5) is
					 when CONV_STD_LOGIC_VECTOR(0, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(7, 6);
					 when CONV_STD_LOGIC_VECTOR(1, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(1, 6);
					 when CONV_STD_LOGIC_VECTOR(2, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(13, 6);
					 when CONV_STD_LOGIC_VECTOR(3, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(5, 6);
					 when CONV_STD_LOGIC_VECTOR(4, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(32, 6);
					 when CONV_STD_LOGIC_VECTOR(5, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(15, 6);
					 when CONV_STD_LOGIC_VECTOR(6, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(22, 6);
					 when CONV_STD_LOGIC_VECTOR(7, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(5, 6);
					 when CONV_STD_LOGIC_VECTOR(8, 5) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(18, 6);
					 when others =>
							char_address_1 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_1_on <= '0';
				end case;
			else
				case "0" & pixel_column(9 downto 5) is
					 when CONV_STD_LOGIC_VECTOR(0, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(13, 6);
					 when CONV_STD_LOGIC_VECTOR(1, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(1, 6);
					 when CONV_STD_LOGIC_VECTOR(2, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(9, 6);
					 when CONV_STD_LOGIC_VECTOR(3, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(14, 6);
					 when CONV_STD_LOGIC_VECTOR(4, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(32, 6);
					 when CONV_STD_LOGIC_VECTOR(5, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(13, 6);
					 when CONV_STD_LOGIC_VECTOR(6, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(5, 6);
					 when CONV_STD_LOGIC_VECTOR(7, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(14, 6);
					 when CONV_STD_LOGIC_VECTOR(8, 6) =>
						  char_address_1 <= CONV_STD_LOGIC_VECTOR(21, 6);
					 when others =>
						char_address_1 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_1_on <= '0';
				end case;
			end if;
			
		elsif(pixel_row >= 207 and pixel_row <= 223) then
			char_2_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode = '1' then
				case pixel_column(9 downto 4) is
					 when CONV_STD_LOGIC_VECTOR(0, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(13, 6);
					 when CONV_STD_LOGIC_VECTOR(1, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(1, 6);
					 when CONV_STD_LOGIC_VECTOR(2, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(9, 6);
					 when CONV_STD_LOGIC_VECTOR(3, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(14, 6);
					 when CONV_STD_LOGIC_VECTOR(4, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(32, 6);
					 when CONV_STD_LOGIC_VECTOR(5, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(13, 6);
					 when CONV_STD_LOGIC_VECTOR(6, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(5, 6);
					 when CONV_STD_LOGIC_VECTOR(7, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(14, 6);
					 when CONV_STD_LOGIC_VECTOR(8, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(21, 6);
					 when others =>
						char_address_2 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_2_on <= '0';
				end case;
			else
				case pixel_column(9 downto 4) is
					 when CONV_STD_LOGIC_VECTOR(0, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
					 when CONV_STD_LOGIC_VECTOR(1, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(18, 6); -- R
					 when CONV_STD_LOGIC_VECTOR(2, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(1, 6);  -- A
					 when CONV_STD_LOGIC_VECTOR(3, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(9, 6);  -- I
					 when CONV_STD_LOGIC_VECTOR(4, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(14, 6); -- N
					 when CONV_STD_LOGIC_VECTOR(5, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(14, 6); -- N
					 when CONV_STD_LOGIC_VECTOR(6, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(7, 6);  -- G
					 when CONV_STD_LOGIC_VECTOR(7, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(32, 6); -- " "
					 when CONV_STD_LOGIC_VECTOR(8, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(13, 6); -- M
					 when CONV_STD_LOGIC_VECTOR(9, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(10, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(4, 6); -- D
					 when CONV_STD_LOGIC_VECTOR(11, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when others =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(32, 6); -- " "
						  char_2_on <= '0';
				end case;
			end if;
		elsif(pixel_row >= 255 and pixel_row <= 271) then
			char_3_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode = '1' then
				case pixel_column(9 downto 4) is
					 when CONV_STD_LOGIC_VECTOR(0, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(16, 6);
					 when CONV_STD_LOGIC_VECTOR(1, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(12, 6);
					 when CONV_STD_LOGIC_VECTOR(2, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(1, 6);
					 when CONV_STD_LOGIC_VECTOR(3, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(25, 6);
					 when CONV_STD_LOGIC_VECTOR(4, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(32, 6);
					 when CONV_STD_LOGIC_VECTOR(5, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(1, 6);
					 when CONV_STD_LOGIC_VECTOR(6, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(7, 6);
					 when CONV_STD_LOGIC_VECTOR(7, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(1, 6);
					 when CONV_STD_LOGIC_VECTOR(8, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(9, 6);
					 when CONV_STD_LOGIC_VECTOR(9, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(14, 6);
					 when others =>
							char_address_3 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_3_on <= '0';
				end case;
			else
				case pixel_column(9 downto 4) is
					 when CONV_STD_LOGIC_VECTOR(0, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(14, 6); -- N
					 when CONV_STD_LOGIC_VECTOR(1, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(2, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(18, 6);  -- R
					 when CONV_STD_LOGIC_VECTOR(3, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(13, 6);  -- M
					 when CONV_STD_LOGIC_VECTOR(4, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(1, 6); -- A
					 when CONV_STD_LOGIC_VECTOR(5, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(12, 6); -- L
					 when CONV_STD_LOGIC_VECTOR(6, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(32, 6); -- " "
					 when CONV_STD_LOGIC_VECTOR(7, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(13, 6); -- M
					 when CONV_STD_LOGIC_VECTOR(8, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(9, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(4, 6); -- D
					 when CONV_STD_LOGIC_VECTOR(10, 6) =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when others =>
						  char_address_3 <= CONV_STD_LOGIC_VECTOR(32, 6); -- " "
						  char_3_on <= '0';
				end case;
			end if;
		end if;
	end process;
--	text_on <= t_text_on when (pixel_row <= 47 and pixel_column <= 300) else '0';
--	char_address_final <= char_address_2 when (pixel_row <= 47 and pixel_row > 31) else char_address_1;
--	size_row <= pixel_row(3 downto 1) when (pixel_row <= 47 and pixel_row > 31) else pixel_row(4 downto 2) ;
--	size_col <= pixel_column(3 downto 1) when (pixel_row <= 47 and pixel_row > 31) else pixel_column(4 downto 2) ;
--	with pixel_column(9 downto 5) select
--		char_address_1 <= CONV_STD_LOGIC_VECTOR(7,6) when CONV_STD_LOGIC_VECTOR(0,5),
--							 CONV_STD_LOGIC_VECTOR(1,6) when CONV_STD_LOGIC_VECTOR(1,5),
--							 CONV_STD_LOGIC_VECTOR(13,6) when CONV_STD_LOGIC_VECTOR(2,5),
--							 CONV_STD_LOGIC_VECTOR(5,6) when CONV_STD_LOGIC_VECTOR(3,5),
--							 CONV_STD_LOGIC_VECTOR(32,6) when CONV_STD_LOGIC_VECTOR(4,5),
--							 CONV_STD_LOGIC_VECTOR(15,6) when CONV_STD_LOGIC_VECTOR(5,5),
--							 CONV_STD_LOGIC_VECTOR(22,6) when CONV_STD_LOGIC_VECTOR(6,5),
--							 CONV_STD_LOGIC_VECTOR(5,6) when CONV_STD_LOGIC_VECTOR(7,5),
--							 CONV_STD_LOGIC_VECTOR(18,6) when CONV_STD_LOGIC_VECTOR(8,5),
--							 CONV_STD_LOGIC_VECTOR(32,6) when others;
--							 
--	with pixel_column(8 downto 4) select
--		char_address_2 <= CONV_STD_LOGIC_VECTOR(18,6) when CONV_STD_LOGIC_VECTOR(0,5),
--							 CONV_STD_LOGIC_VECTOR(5,6) when CONV_STD_LOGIC_VECTOR(1,5),
--							 CONV_STD_LOGIC_VECTOR(19,6) when CONV_STD_LOGIC_VECTOR(2,5),
--							 CONV_STD_LOGIC_VECTOR(20,6) when CONV_STD_LOGIC_VECTOR(3,5),
--							 CONV_STD_LOGIC_VECTOR(1,6) when CONV_STD_LOGIC_VECTOR(4,5),
--							 CONV_STD_LOGIC_VECTOR(18,6) when CONV_STD_LOGIC_VECTOR(5,5),
--							 CONV_STD_LOGIC_VECTOR(20,6) when CONV_STD_LOGIC_VECTOR(6,5),
--							 CONV_STD_LOGIC_VECTOR(32,6) when others;
END ARCHITECTURE behaviour;
			
		