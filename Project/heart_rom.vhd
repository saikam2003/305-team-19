LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY heart_rom IS
	PORT
	(
		font_row, font_col	:	IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		heart_data_alpha	:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		heart_data_red		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		heart_data_green	:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		heart_data_blue		:	OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END heart_rom;


ARCHITECTURE SYN OF heart_rom IS

	SIGNAL rom_data		: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL rom_address	: STD_LOGIC_VECTOR (7 DOWNTO 0);

	COMPONENT altsyncram
	GENERIC (
		address_aclr_a			: STRING;
		clock_enable_input_a	: STRING;
		clock_enable_output_a	: STRING;
		init_file				: STRING;
		intended_device_family	: STRING;
		lpm_hint				: STRING;
		lpm_type				: STRING;
		numwords_a				: NATURAL;
		operation_mode			: STRING;
		outdata_aclr_a			: STRING;
		outdata_reg_a			: STRING;
		widthad_a				: NATURAL;
		width_a					: NATURAL;
		width_byteena_a			: NATURAL
	);
	PORT (
		clock0		: IN STD_LOGIC ;
		address_a	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_a			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	END COMPONENT;

BEGIN

	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "heart_data.mif",
		intended_device_family => "Cyclone III",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 256,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 8,
		width_a => 16,
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clock,
		address_a => rom_address,
		q_a => rom_data
	);

	rom_address <= font_row & font_col;
	heart_data_alpha <= rom_data(15 downto 12);
	heart_data_red <= rom_data (11 downto 8);
	heart_data_green <= rom_data (7 downto 4);
	heart_data_blue <= rom_data (3 downto 0);

END SYN;