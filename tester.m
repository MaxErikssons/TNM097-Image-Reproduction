
clear all
img = imread('./peppers_color.tif');
imgNe = imresize(imresize(img,0.25,'nearest'),4,'nearest');

[a,b,c] = qualityMeasure(img,imgNe)