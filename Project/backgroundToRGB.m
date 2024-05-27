clear;
clc;

% Read the image
img = imread("cyber_city.jpg");

[height, width, ~] = size(img);

% Initialize the RGB array
rgb = zeros(height, width, 3); % Preallocate array
range = linspace(0, 15, 256);

for i = 1:height
    for j = 1:width
        % Extract RGB values from the image
        r = img(i, j, 1);
        g = img(i, j, 2);
        b = img(i, j, 3);

        % Map each value to a 4-bit representation (0-15)
        rgb(i, j, 1) = round(interp1(0 : 255, range, double(r)));
        rgb(i, j, 2) = round(interp1(0 : 255, range, double(g)));
        rgb(i, j, 3) = round(interp1(0 : 255, range, double(b)));
    end
end

% Open the file for writing
fileID = fopen('sky_background_data.mif', 'w');

% Write the header information
fprintf(fileID, 'DEPTH = %d;\n', height * width);
fprintf(fileID, 'WIDTH = %d;\n', 12); % Change WIDTH to 12 since we are not using alpha
fprintf(fileID, 'ADDRESS_RADIX = BIN;\n'); % Change address radix to binary
fprintf(fileID, 'DATA_RADIX = BIN;\n');
fprintf(fileID, 'CONTENT BEGIN\n');

% Address calculation
for row = 0 : height-1
    for col = 0 : width-1
       address = bitshift(row, 8) + col; % Combine row and column into a 17-bit address (9 bits for row, 8 bits for col)
       address_bin = dec2bin(address, 17); % Convert address to 17-bit binary string
       fprintf(fileID, '%s : ', address_bin);
       r = dec2bin(rgb(row+1, col+1, 1), 4);
       g = dec2bin(rgb(row+1, col+1, 2), 4);
       b = dec2bin(rgb(row+1, col+1, 3), 4);
       out = [r g b];
       fprintf(fileID, '%s;\n', out);
    end
end

% Write the end of the MIF file
fprintf(fileID, 'END;\n');

% Close the file
fclose(fileID);
