% This function takes an image and reproduce it using images stored in the database.
% Some optimization is done reducing the number of images in the database.
function [renderedImage] = reproduceImage(image, name, numberOfColors, imagesPerColor)
tic
%% Show image and calculate its color palette
I = im2double(image);
figure;
imshow(I);
title('Image to reproduce');

[height, width, ~] = size(I);
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

%% Divide the image into tiles
minRowsCols = 70;
maxRowsCols = 140;
found = false;

% Find a value that is divisble with the height. 
while ~found
    for numberOfColoumns = maxRowsCols:-1:minRowsCols
        if mod(height, numberOfColoumns) == 0
            found = true;
            break;
        end
    end
    if ~found
        height = height + 1;
    end
end

% Find a value that is divisble with the width. 
found = false;
while ~found
    for numberOfRows = maxRowsCols:-1:minRowsCols
        if mod(width, numberOfRows) == 0
            found = true;
            break;
        end
    end
    if ~found
        width = width + 1;
    end
end

I = imresize(I, [height, width], 'bicubic');
ratio = height/width;

tiling = [numberOfColoumns numberOfRows]; % [y x]
tiles = imdetile(I, tiling, 'direction', 'row');
montage(tiles,'size',tiling,'bordersize',[1 1],'backgroundcolor','w')
tileRatio = numberOfColoumns/numberOfRows;
%% Caluclate path for each image to replace tile with.
paths = getPaths(reducedDatabase, tiles, numberOfColoumns, numberOfRows);

%% Add the "best" image to the corresponding position.
if(ratio < 1)
    smallImagesSize = [ceil(42*ratio/tileRatio) 42];
else
    smallImagesSize = [42 ceil(42/ratio*tileRatio)];
end

renderedImage = zeros(floor(smallImagesSize(1)*numberOfColoumns), floor(smallImagesSize(2)*numberOfRows), 3);
pathSize = size(paths);
for i = 1:pathSize(2)
    for j = 1:pathSize(1)
        Im = im2double(imread(paths{j,i}));
        Im = imresize(Im, smallImagesSize ,"bicubic");
        renderedImage((i-1)*smallImagesSize(1)+1:i*smallImagesSize(1), (j-1)*smallImagesSize(2)+1:j*smallImagesSize(2), :) = Im;
    end
end

%% Render the image
imwrite(renderedImage, name);
toc
end