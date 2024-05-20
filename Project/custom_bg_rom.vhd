LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY custom_bg_rom IS
    PORT
    (
        font_row:    IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        font_col:    IN STD_LOGIC_VECTOR (10 DOWNTO 0);
        clock                :     IN STD_LOGIC ;
        background_data_alpha        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        background_data_red        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        background_data_green        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        background_data_blue        :    OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END custom_bg_rom;

ARCHITECTURE SYN OF custom_bg_rom IS

    SIGNAL rom_data        : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL rom_address    : STD_LOGIC_VECTOR (18 DOWNTO 0);

    COMPONENT altsyncram
    GENERIC (
        address_aclr_a            : STRING;
        clock_enable_input_a    : STRING;
        clock_enable_output_a    : STRING;
        init_file                : STRING;
        intended_device_family    : STRING;
        lpm_hint                : STRING;
        lpm_type                : STRING;
        numwords_a                : NATURAL;
        operation_mode            : STRING;
        outdata_aclr_a            : STRING;
        outdata_reg_a            : STRING;
        widthad_a                : NATURAL;
        width_a                    : NATURAL;
        width_byteena_a            : NATURAL
    );
    PORT (
        clock0        : IN STD_LOGIC ;
        address_a    : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
        q_a            : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    END COMPONENT;

BEGIN

    altsyncram_component : altsyncram
    GENERIC MAP (
        address_aclr_a => "NONE",
        clock_enable_input_a => "BYPASS",
        clock_enable_output_a => "BYPASS",
        init_file => "background_data.mif",
        intended_device_family => "Cyclone III",
        lpm_hint => "ENABLE_RUNTIME_MOD=NO",
        lpm_type => "altsyncram",
        numwords_a => 307200,
        operation_mode => "ROM",
        outdata_aclr_a => "NONE",
        outdata_reg_a => "UNREGISTERED",
        widthad_a => 29,
        width_a => 16,
        width_byteena_a => 1
    )
    PORT MAP (
        clock0 => clock,
        address_a => rom_address,
        q_a => rom_data
    );

    -- rom_address <= STD_LOGIC_VECTOR(to_unsigned((unsigned(font_row) * 640 + unsigned(font_col)), 19));
    rom_address <= "0000000000000000000";
    background_data_alpha <= rom_data(15 downto 12);
    background_data_red <= rom_data (11 downto 8);
    background_data_green <= rom_data (7 downto 4);    
    background_data_blue <= rom_data (3 downto 0);

END SYN;
