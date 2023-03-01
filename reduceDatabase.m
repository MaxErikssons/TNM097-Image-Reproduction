% This function loads the precalculated LAB-values for all images.
% It then compare these values with the colors in "palette" (converted to LAB) and
% picks the one with the least distance and saves this image in a reduced database.

function [reducedDatabase] = reduceDatabase(palette, numberOfColors, imagesPerColor)

%% Load LAB-values for all images.
load('labValuesFlowers.mat');
reducedDatabase = cell(numberOfColors*imagesPerColor, 1);

%% For each color of the palette, compare the LAB-value with the LAB-values store for all images.
%% And save the one with least distance.
for i = 1:numberOfColors
    targetColor = palette(i,:);
    targetColor = rgb2lab(targetColor);
    [L_ref, a_ref, b_ref] = deal(targetColor(1), targetColor(2), targetColor(3));
    distances = zeros(length(stored_Lab_values));
    for j = 1:length(stored_Lab_values)
        [L, a, b] = deal(stored_Lab_values{j}{2},stored_Lab_values{j}{3},stored_Lab_values{j}{4});
        distances(j) = colorDifference(L,a,b, L_ref, a_ref, b_ref);
    end
    [~, indices] = sort(distances);
    for k = 1:imagesPerColor
        filename = stored_Lab_values{indices(k)}{1};
        reducedDatabase{(i-1) * imagesPerColor + k} = filename; % store the result for this iteration in the cell array
    end
end

end