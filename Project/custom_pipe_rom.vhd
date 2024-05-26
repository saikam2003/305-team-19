LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY custom_pipe_rom IS
    PORT (
        font_row: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        font_col: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        clock: IN STD_LOGIC;
        pipe_data_red: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        pipe_data_green: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        pipe_data_blue: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END custom_pipe_rom;

ARCHITECTURE SYN OF custom_pipe_rom IS

    SIGNAL rom_data: STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL rom_address: STD_LOGIC_VECTOR(14 DOWNTO 0); -- 17 bits required for addressing
    SIGNAL adjusted_col: STD_LOGIC_VECTOR(9 DOWNTO 0);

    COMPONENT altsyncram
    GENERIC (
        address_aclr_a: STRING;
        clock_enable_input_a: STRING;
        clock_enable_output_a: STRING;
        init_file: STRING;
        intended_device_family: STRING;
        lpm_hint: STRING;
        lpm_type: STRING;
        numwords_a: NATURAL;
        operation_mode: STRING;
        outdata_aclr_a: STRING;
        outdata_reg_a: STRING;
        widthad_a: NATURAL;
        width_a: NATURAL;
        width_byteena_a: NATURAL
    );
    PORT (
        clock0: IN STD_LOGIC;
        address_a: IN STD_LOGIC_VECTOR(14 DOWNTO 0); -- Adjusted to 17 bits
        q_a: OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
    END COMPONENT;

BEGIN

    altsyncram_component : altsyncram
    GENERIC MAP (
        address_aclr_a => "NONE",
        clock_enable_input_a => "BYPASS",
        clock_enable_output_a => "BYPASS",
        init_file => "custom_pipe_data.mif",
        intended_device_family => "Cyclone III",
        lpm_hint => "ENABLE_RUNTIME_MOD=NO",
        lpm_type => "altsyncram",
        numwords_a => 30696,
        operation_mode => "ROM",
        outdata_aclr_a => "NONE",
        outdata_reg_a => "UNREGISTERED",
        widthad_a => 15, -- Adjusted to 17 bits
        width_a => 12,
        width_byteena_a => 1
    )
    PORT MAP (
        clock0 => clock,
        address_a => rom_address,
        q_a => rom_data
    );
    
    rom_address <= font_row & font_col;
    pipe_data_red <= rom_data(11 DOWNTO 8);
    pipe_data_green <= rom_data(7 DOWNTO 4);    
    pipe_data_blue <= rom_data(3 DOWNTO 0);

END SYN;