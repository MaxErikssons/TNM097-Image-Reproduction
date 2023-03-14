function [outputArg1] = verifyImage(imgPath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
inpic = imread(imgPath);

[row,col,colors] = size(inpic)

%%om någon dimension är mindre än 100 px
if min(row,col) < 100
    if min(row,col) == row
        newRow = 100;
        newCol = (col/row)*100;
    else
        newCol = 100;
        newRow = (row/col)*100;
    end
    disp('Image is smaller than 100px, scaling performed. consider using larger picture')

    outImg = imresize(inpic,[newRow,newCol],"bilinear");

end

if max(row,col) > 1300
    if max(row,col) == row
        newRow = 1300;
        newCol = (col/row)*1300;
    else
        newCol = 1300;
        newRow = (row/col)*1300;
    end
    disp('Image is larger than 1300px, scaling performed. This might affect the result. Consider using a smaller picture')

    outImg = imresize(inpic,[newRow,newCol],"bilinear");
end

if max(row,col) <= 1300 && min(row,col) >= 100
    outImg = inpic;
    disp('Image is OK!')
end

outputArg1 = outImg;

end