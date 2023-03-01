% This function compare the LAB-value for each tile with the LAB-values for
% all images stored in the reduced database. It then stores the path for
% this image. This is done for each tile before reshaping the paths into
% 2D-array instead of 1D-vector. 

function [paths] = getPaths(reducedDatabase, tiles, numberOfColumns, numberOfRows)

%% Load LAB-values for all images.
load('labValuesFlowers.mat');

%% Extract the LAB-values for the reduced database from the database storing all LAB-values.
labValues = [];
for i = 1:length(stored_Lab_values)
    for j = 1:length(reducedDatabase)
    if ~isempty(intersect(stored_Lab_values{i}{1}, reducedDatabase{j}))
        labValues{end+1} = stored_Lab_values{i};
    end
    end
end

%% Initialize a cell array to store the path of each tile
paths = cell(length(tiles),1);

%% Loop over each tile and find the image with the closest color match in the database
for j = 1:length(tiles)
    lab = rgb2lab(tiles(:,:,:,j));
    L_ref = mean2(lab(:,:,1));
    a_ref = mean2(lab(:,:,2));
    b_ref = mean2(lab(:,:,3));
    differences = zeros(1,length(labValues)); %%allocate space.
    for i = 1:length(labValues)
        [~, L, a, b] = deal(labValues{i}{1}, labValues{i}{2}, labValues{i}{3}, labValues{i}{4});
        differences(i) = colorDifference(L,a,b, L_ref, a_ref, b_ref);
    end

    [~, idx] = min(differences);
    paths{j} = labValues{idx}{1};
end

%% Reshape paths into numberOfRows x numberOfRows cell.
paths = reshape(paths, numberOfRows, numberOfColumns);
end