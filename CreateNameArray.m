function [outputArg1] = CreateNameArray(image_file_path,cellArray)
%read the img to be reproduced
%default CurrentImageDatabase = test %full database
CurrentImageDatabase = cellArray; %This is where we specifie which imagedatabase we're using from part 1
pictureToReproduce = im2double(imread(image_file_path)); %choose image to reproduce
%short test to see all individual images

imshow(pictureToReproduce);
ImgToRepLab = rgb2lab(pictureToReproduce);
ImageNameArray = strings;


%%start high coz we want low
valueBestMatch = 100;
nameOfBestMatch  ="";

%so we can handle different sized images
size(ImgToRepLab);
[row,col,dontCare] = size(ImgToRepLab);

%largest fucking forloop in my life
for i = 1:row %x img
    for j= 1:col% y img
        for k = 1:length(CurrentImageDatabase)% array with all img
            %extract the lab values from Cell
            labValues = cell2mat(CurrentImageDatabase{k}(2));
            deltaE = sqrt((ImgToRepLab(i,j,1)-labValues(1))^2+(ImgToRepLab(i,j,2)-labValues(2))^2+(ImgToRepLab(i,j,3)-labValues(3))^2);
            
                if valueBestMatch>deltaE
                    valueBestMatch = deltaE;
                    nameOfBestMatch = string(CurrentImageDatabase{k}(1));
                end
            %sqrt(ImgToRepLab(i,j,1)-test{k})
            
            
        end
        nameOfBestMatch;
        % creating NameArray where each "pixel" corresponds to the name of a picture in
        % the cell-database
        ImageNameArray(i,j) = nameOfBestMatch;
        valueBestMatch=100;
    end
end
outputArg1 = ImageNameArray;
end

