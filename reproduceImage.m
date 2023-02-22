% This function takes an image and reproduce it using images stored in the database. 
% Some optimization is done reducing the number of images in the database. 
function [renderedImage] = reproduceImage(image, name, numberOfColors, imagesPerColor)
tic
%% Show image and calculate its color palette
I = im2double(image);
figure;
imshow(I);
title('Image to reproduce');


palette = calculateColorPalette(I, numberOfColors);

%% Plot the color palette
% figure
% for k = 1:numberOfColors
%     rectangle('Position', [k-1, 0, 1, 1], 'FaceColor', palette(k,:))
% end
% title('Color palette over the most occuring colors in the image');
% axis off

%% Reduce the database to only include images with colors in the palette for the image to reproduce.
reducedDatabase = reduceDatabase(palette, numberOfColors, imagesPerColor);

%% Divide the image into equaly sized tiles
numberOfRows = 120; %% Number of tiles in each direction.
tiling = [numberOfRows numberOfRows]; % [y x]
tiles = imdetile(I, tiling, 'direction', 'row');

%% Caluclate path for each image to replace tile with.
paths = getPaths(reducedDatabase, tiles, numberOfRows);

%% Add the "best" image to the corresponding position.
renderedImage = zeros(5040, 5040, 3);

for i = 1:length(paths)
    for j = 1:length(paths)
        Im = im2double(imread(paths{j,i}));
        Im = imresize(Im, [42 42] ,"bicubic");
        renderedImage((i-1)*42+1:i*42, (j-1)*42+1:j*42, :) = Im;
    end
end

%% Render the image
imwrite(renderedImage, name);
toc
end