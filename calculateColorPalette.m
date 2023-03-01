% This function take an image and create a color palette using 
% "numberOfColors" amount of colors.

function [palette] = calculateColorPalette(img, numberOfColors)
I = im2double(img);

%% Convert the image to L*a*b color space
lab_I = rgb2lab(I);

%% Reshape the image into a 2D array of pixels
pixel_Lab = reshape(lab_I, [], 3);
rng(1);

%% Use the k-means clustering algorithm to cluster the pixels into x clusters
[clusterIdx, clusterCenter] = kmeans(double(pixel_Lab), numberOfColors);

%% Convert the cluster centers back to RGB color space
clusterRgb = lab2rgb(clusterCenter);

%% Count the frequency of each color cluster in the image
clusterCounts = histcounts(clusterIdx, numberOfColors);

%% Sort the frequency in descending order
[~, sortIdx] = sort(clusterCounts, 'descend');

%% Pick the top x clusters
top_clusters = sortIdx(1:numberOfColors);
palette = clusterRgb(top_clusters,:);
end