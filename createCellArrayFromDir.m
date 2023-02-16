function [Cellarray] = createCellArrayFromDir(dir_name)
%dir_name is the name of directory containing your JPGs ex ( "car/"
%Import images to create decent base-cellArray
%the cellaray consista of cells containing filename, [L,a,b]-values, Array
%of acutal image. might be too much but why not :) 

%the array is in the format 1xNR
%N is number of images in the directory
%R is the internal cells which is a 1x3 cell (name,lab,image)

myfolder=dir_name;
filetype= "*.jpg"; % *.filetype
filepattern = fullfile(myfolder,filetype);
jpegFiles = dir(filepattern);

%different arrays 
test = {};
testArray = [];

%read images
for k = 1:length(jpegFiles)
    
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(myfolder, baseFileName);
    fprintf(1,"now reading %s\n", fullFileName);
    [imageArray,map,alpha] = imread(fullFileName);
    imageArray = im2double(imageArray);
    imageArray = imresize(imageArray,0.5,"bicubic");
    
    %convert RBG to lab
    lab = rgb2lab(imageArray);
    L = mean2(lab(:,:,1));
    a = mean2(lab(:,:,2));
    b = mean2(lab(:,:,3));
    
    %add cell containing filename, Lab values and the acutal image
    test{k} = {fullFileName,[L,a,b],imageArray};
  
    
    drawnow;
end

Cellarray=test;


end

