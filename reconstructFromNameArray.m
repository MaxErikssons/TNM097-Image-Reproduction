function [reConstructed] = reconstructFromNameArray(nameArray,scale)
%For this to work the NameArray needs to contain the exact path of where to
%find the image

Repoduced = []
nameArrayToReprocude = nameArray; %Default




[row,col] = size(nameArrayToReprocude);
for i=1:row
    for j=1:col
        
        current = imread(nameArrayToReprocude(i,j)); %Read img
        current = im2double(current); %make double
        
        %One might want to edit the resizing! 
        %Ändrade lite här resize gör rutor som är 25x25 istället för att minska dom med skala, detta för att hantera rektangulära bilder
        current = imresize(current,[25 25],"bicubic"); %resize according to first step
        Repoduced((i-1)*length(current)+1:i*length(current), (j-1)*length(current)+1:j*length(current), :) = current; %replace "namepixel" with image
        
    end
end
reConstructed= Repoduced;
end

