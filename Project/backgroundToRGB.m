clear
clc

% Read the image
img = imread("new_background.jpg");

[height, width, ~] = size(img);

% Initialize the RGBA array (with alpha always set to 15, fully opaque)
rgba = zeros(height, width, 4); % Preallocate array
range = linspace(0, 15, 256);

for i = 1:height
    for j = 1:width
        % Extract RGB values from the image
        r = img(i, j, 1);
        g = img(i, j, 2);
        b = img(i, j, 3);

        % Map each value to a 4-bit representation (0-15)
        rgba(i, j, 1) = round(interp1(0 : 255, range, double(r)));
        rgba(i, j, 2) = round(interp1(0 : 255, range, double(g)));
        rgba(i, j, 3) = round(interp1(0 : 255, range, double(b)));
        rgba(i, j, 4) = 15; % Set alpha to 15 (fully opaque)
    end
end

% Open the file for writing
fileID = fopen('new_background_data.mif', 'w');

% Write the header information
fprintf(fileID, 'DEPTH = %d;\n', height * width);
fprintf(fileID, 'WIDTH = %d;\n', 16);
fprintf(fileID, 'ADDRESS_RADIX = BIN;\n'); % Change address radix to binary
fprintf(fileID, 'DATA_RADIX = BIN;\n');
fprintf(fileID, 'CONTENT BEGIN\n');

% Address calculation
for row = 0 : height-1
    for col = 0 : width-1
       address = bitshift(row, 10) + col; % Combine row and column into a 19-bit address
       address_bin = dec2bin(address, 19); % Convert address to 19-bit binary string
       fprintf(fileID, '%s : ', address_bin);
       r = dec2bin(rgba(row+1, col+1, 1), 4);
       g = dec2bin(rgba(row+1, col+1, 2), 4);
       b = dec2bin(rgba(row+1, col+1, 3), 4);
       a = dec2bin(rgba(row+1, col+1, 4), 4);
       out = [a r g b];
       fprintf(fileID, '%s;\n', out);
    end
end

% Write the end of the MIF file
fprintf(fileID, 'END;\n');

% Close the file
fclose(fileID);
