% This function loads the precalculated color palettes for all images. 
% It then compare these palettes with the colors in "palette" and
% picks the one with the least distance and saves this image in a reduced database.  

%%THIS FUNCTION SHOULD BE CHANGED IN THE FUTURE. WE DO NOT USE THE ENTIRE
%%COLOR PALETTE FOR ALL IMAGES, JUST THE MOST OCCURING COLOR!

function [reducedDatabase] = reduceDatabase(palette, numberOfColors)

%% Load color palettes for all images.
load('ImagePalettes.mat')

folder = "Images/flower"; % locate folder
imageFiles = dir(fullfile(folder,'*.jpg'));
nfiles = length(imageFiles);

reducedDatabase = cell(numberOfColors, 1);

%% For each color of the palette, compare the color with the palettes for all images.
for i = 1:numberOfColors
    targetColor = palette(i,:);
    targetColor = repmat(targetColor, [nfiles, 1]);
    distances = sqrt((image_palettes(:,1,1) - targetColor(:,1)).^2 + (image_palettes(:,1,2) - targetColor(:,2)).^2 + (image_palettes(:,1,3) - targetColor(:,3)).^2);
    minVal = min(distances);
    index = distances == minVal;
    filename=fullfile(folder,imageFiles(index).name); % get filename of current image.
    reducedDatabase{i} = filename; % store the result for this iteration in the cell array
end
end