LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY text_display IS
	PORT(Clk, enable, option_in: IN STD_LOGIC;
			game_mode_in: IN STD_LOGIC_VECTOR(1 downto 0);
			score_in: IN INTEGER RANGE 999 downto 0;
			pixel_row, pixel_column: IN STD_LOGIC_VECTOR(9 downto 0);
			red, blue, green : OUT STD_LOGIC_VECTOR(3 downto 0);
			text_on: OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behaviour OF text_display IS
	SIGNAL t_text_on, char_1_on, char_2_on, char_3_on, char_4_on, char_5_on, char_6_on, char_7_on: STD_LOGIC := '0';
	SIGNAL size_row, size_col: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL char_address_1, char_address_2, char_address_3, char_address_4, char_address_5, char_address_6, char_address_7, char_address_final: STD_LOGIC_VECTOR (5 DOWNTO 0);
--	SIGNAL temp_score, temp_high_score: INTEGER RANGE 999 to 0;
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
	text_on <= 	t_text_on when enable = '1' and char_1_on = '1' else
					'1' when enable = '1' and (char_2_on = '1' or char_3_on ='1' or char_4_on= '1' or char_5_on ='1' or char_6_on = '1' or char_7_on = '1') else '0';
	
	red <= "0000" when t_text_on = '1' and char_2_on = '1' and option_in = '1' else 
				"0000" when t_text_on = '1' and char_3_on = '1' and option_in = '0' else (t_text_on,t_text_on,t_text_on,t_text_on);
	blue <= "0000" when t_text_on = '1' and char_2_on = '1' and option_in = '1' else 
				"0000" when t_text_on = '1' and char_3_on = '1' and option_in = '0' else (t_text_on,t_text_on,t_text_on,t_text_on);
	green <= (t_text_on,t_text_on,t_text_on,t_text_on);
	
	char_address_final <= char_address_1 when char_1_on = '1'  else 
								char_address_2 when char_2_on = '1' else
								char_address_3 when char_3_on = '1' else 
								char_address_4 when char_4_on = '1' else
								char_address_5 when char_5_on = '1' else
								char_address_6 when char_6_on = '1' else
								char_address_7 when char_7_on = '1' else "100000";
								
	process(pixel_row,pixel_column)
	begin
		if(pixel_row >= 63 and pixel_row <= 95) then
			-- ==================== TITLE ====================
			char_1_on <= '1';
			size_row <= pixel_row(4 downto 2);
			size_col <= pixel_column(4 downto 2);
			if(game_mode_in = "11") then
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
			elsif(game_mode_in = "00") then
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
		-- ==================== option 0 ====================
			char_2_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode_in = "11" then
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
			elsif(game_mode_in = "00") then
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
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(9, 6);  -- I
					 when CONV_STD_LOGIC_VECTOR(6, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(14, 6); -- N
					 when CONV_STD_LOGIC_VECTOR(7, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(7, 6);  -- G
					 when CONV_STD_LOGIC_VECTOR(8, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(32, 6); -- " "
					 when CONV_STD_LOGIC_VECTOR(9, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(13, 6); -- M
					 when CONV_STD_LOGIC_VECTOR(10, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(11, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(4, 6); -- D
					 when CONV_STD_LOGIC_VECTOR(12, 6) =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when others =>
						  char_address_2 <= CONV_STD_LOGIC_VECTOR(32, 6); -- " "
						  char_2_on <= '0';
				end case;
			end if;
		elsif(pixel_row >= 255 and pixel_row <= 271) then
			-- ==================== option 1 ====================
			char_3_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode_in = "11" then
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
			elsif(game_mode_in = "00") then
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
		elsif(pixel_row >= 319 and pixel_row < 335) then
			-- ==================== key bindings 1 ====================
			char_4_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode_in = "00" then
				case ("0" & pixel_column(9 downto 4)) is
					 when CONV_STD_LOGIC_VECTOR(0, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
					 when CONV_STD_LOGIC_VECTOR(1, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(23, 6); -- W
					 when CONV_STD_LOGIC_VECTOR(2, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(48, 6); -- 0
					 when CONV_STD_LOGIC_VECTOR(3, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(4, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(3, 6); -- C
					 when CONV_STD_LOGIC_VECTOR(5, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(8, 6); -- H
					 when CONV_STD_LOGIC_VECTOR(6, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(1, 6); -- A
					 when CONV_STD_LOGIC_VECTOR(7, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(14, 6); -- N
					 when CONV_STD_LOGIC_VECTOR(8, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(7, 6); -- G
					 when CONV_STD_LOGIC_VECTOR(9, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when CONV_STD_LOGIC_VECTOR(10, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
					 when CONV_STD_LOGIC_VECTOR(11, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(12, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(13, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(16, 6); -- P
					 when CONV_STD_LOGIC_VECTOR(14, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
					 when CONV_STD_LOGIC_VECTOR(15, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(9, 6); -- I
					 when CONV_STD_LOGIC_VECTOR(16, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(17, 7) =>
						  char_address_4 <= CONV_STD_LOGIC_VECTOR(14, 6); -- N
					 when others =>
							char_address_4 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_4_on <= '0';
				end case;
			else 
				char_4_on <= '0';
			end if;
		elsif(pixel_row >= 351 and pixel_row < 367) then
			-- ==================== key bindings 2 ====================
			char_5_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode_in = "00" then
				case ("0" & pixel_column(9 downto 4)) is
					 when CONV_STD_LOGIC_VECTOR(0, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(18, 6); -- R
					 when CONV_STD_LOGIC_VECTOR(1, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(9, 6); -- I
					 when CONV_STD_LOGIC_VECTOR(2, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(7, 6); -- G
					 when CONV_STD_LOGIC_VECTOR(3, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(8, 6); --H
					 when CONV_STD_LOGIC_VECTOR(4, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
					 when CONV_STD_LOGIC_VECTOR(5, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(6, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(3, 6); -- C
					 when CONV_STD_LOGIC_VECTOR(7, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(12, 6); -- L
					 when CONV_STD_LOGIC_VECTOR(8, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(9, 6); -- I
					 when CONV_STD_LOGIC_VECTOR(9, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(3, 6); -- C
					 when CONV_STD_LOGIC_VECTOR(10, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(11, 6); -- K
					 when CONV_STD_LOGIC_VECTOR(11, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(12, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T 
					 when CONV_STD_LOGIC_VECTOR(13, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(14, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(15, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
					 when CONV_STD_LOGIC_VECTOR(16, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when CONV_STD_LOGIC_VECTOR(17, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(12, 6); -- L
					 when CONV_STD_LOGIC_VECTOR(18, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when CONV_STD_LOGIC_VECTOR(19, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(3, 6); -- C
					 when CONV_STD_LOGIC_VECTOR(20, 7) =>
						  char_address_5 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
					 when others =>
							char_address_5 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_5_on <= '0';
				end case;
			else 
				char_5_on <= '0';
			end if;
		elsif(pixel_row >= 383 and pixel_row < 399) then
			-- ==================== key bindings 3 / prev score ====================
			char_6_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode_in = "00" then -- key binding 3 in main menu
				case ("0" & pixel_column(9 downto 4)) is
					 when CONV_STD_LOGIC_VECTOR(0, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
					 when CONV_STD_LOGIC_VECTOR(1, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(23, 6); -- W
					 when CONV_STD_LOGIC_VECTOR(2, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(49, 6); -- 1
					 when CONV_STD_LOGIC_VECTOR(3, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(4, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
					 when CONV_STD_LOGIC_VECTOR(5, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(6, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(7, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(16, 6); -- P
					 when CONV_STD_LOGIC_VECTOR(8, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(1, 6); -- A
					 when CONV_STD_LOGIC_VECTOR(9, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(21, 6); -- U
					 when CONV_STD_LOGIC_VECTOR(10, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
					 when CONV_STD_LOGIC_VECTOR(11, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when others =>
							char_address_6 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_6_on <= '0';
				end case;
			elsif game_mode_in = "11" then -- prev score in game over
				case ("0" & pixel_column(9 downto 4)) is
					 when CONV_STD_LOGIC_VECTOR(0, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
					 when CONV_STD_LOGIC_VECTOR(1, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(3, 6); -- C
					 when CONV_STD_LOGIC_VECTOR(2, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(3, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(18, 6); -- R
					 when CONV_STD_LOGIC_VECTOR(4, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when CONV_STD_LOGIC_VECTOR(5, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(45, 6); -- -
					 when CONV_STD_LOGIC_VECTOR(6, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(7, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR((score_in / 100) + 48, 6); -- score hundreds
					 when CONV_STD_LOGIC_VECTOR(8, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR(((score_in mod 100) / 10) + 48, 6); -- score tens
					 when CONV_STD_LOGIC_VECTOR(9, 7) =>
						  char_address_6 <= CONV_STD_LOGIC_VECTOR((score_in mod 10) + 48, 6); -- score ones
					 when others =>
							char_address_6 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_6_on <= '0';
				end case;
			end if;
		elsif(pixel_row >= 415 and pixel_row <= 431) then
			-- ==================== key bindings 4 / high score ====================
			char_7_on <= '1';
			size_row <= pixel_row(3 downto 1);
			size_col <= pixel_column(3 downto 1);
			if game_mode_in = "00" then -- key binding 4 in main menu
				case ("0" & pixel_column(9 downto 4)) is
					 when CONV_STD_LOGIC_VECTOR(0, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(11, 6); -- K
					 when CONV_STD_LOGIC_VECTOR(1, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when CONV_STD_LOGIC_VECTOR(2, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(25, 6); -- Y
					 when CONV_STD_LOGIC_VECTOR(3, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(15, 6); --0
					 when CONV_STD_LOGIC_VECTOR(4, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(5, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
					 when CONV_STD_LOGIC_VECTOR(6, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
					 when CONV_STD_LOGIC_VECTOR(7, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(32, 6); -- 
					 when CONV_STD_LOGIC_VECTOR(8, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(18, 6); -- R
					 when CONV_STD_LOGIC_VECTOR(9, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when CONV_STD_LOGIC_VECTOR(10, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
					 when CONV_STD_LOGIC_VECTOR(11, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(5, 6); -- E
					 when CONV_STD_LOGIC_VECTOR(12, 7) =>
						  char_address_7 <= CONV_STD_LOGIC_VECTOR(20, 6); -- T 
					 when others =>
							char_address_7 <= CONV_STD_LOGIC_VECTOR(32, 6);
						  char_7_on <= '0';
				end case;
			else 
				char_7_on <= '0';
			end if;
		end if;
	end process;
END ARCHITECTURE behaviour;
			
		