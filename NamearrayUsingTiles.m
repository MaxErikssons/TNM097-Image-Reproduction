function [outputArg1,outputArg2] = NamearrayUsingTiles(FilePath,imageDataBase,TileSize)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

nrOftiles = 42;
inpict =FilePath% 384x512x3
kmeanedArray = imageDataBase;%%byt när vi gör detta till en funktion

[OGrow,OGcol,whatever] = size(inpict);

if OGcol > OGrow
    
    tilesrow= nrOftiles;
    tilescol= nrOftiles/(min(OGrow,OGcol)/(max(OGrow,OGcol)));
else
    
    
    
    tilesrow= nrOftiles/(min(OGrow,OGcol)/(max(OGrow,OGcol)));
    tilescol= nrOftiles;
end
tileSize= TileSize;
testx =OGrow/tilesrow;
testy =OGcol/tilescol;

tilesrow = OGrow/tileSize;
tilescol = OGcol/tileSize;

x = floor(tilesrow);
y = floor(tilescol);

tiling = [x y]; % [y x]
subimages = imdetile(inpict,tiling,'direction','row'); % 77x85x3x30
%split into tiles
montage(subimages,'size',tiling,'bordersize',[1 1],'backgroundcolor','w')


valueBestMatch = 0;
nameOfBestMatch  ="";
nameArray = strings;
bestLabMatch = 100;
labOfBestMatch = [];


for i = 1:x*y
    %för alla bilder i databasen
    %list of best matches 
    topMatches = strings;
    
    for k = 1:length(kmeanedArray)
       
        
        %hitta average färg för tile...
        %convertera till LAB
        lab = rgb2lab(subimages(:,:,:,i));
        L = mean2(lab(:,:,1));
        a = mean2(lab(:,:,2));
        b = mean2(lab(:,:,3));
        
        labValues = cell2mat(kmeanedArray{k}(2));
        deltaE = sqrt((L-labValues(1))^2+(a-labValues(2))^2+(b-labValues(3))^2);
            
                %Det här ger oss en lista med top fynden, den här listan
                %kan ha olika storlek beroende hur bra första träffen är,
                %lite skrev då 0000 nästan alltid kommer med :/ 
        if bestLabMatch>deltaE
            bestLabMatch = deltaE;
            nameOfBestMatch = string(kmeanedArray{k}(1));
            labOfBestMatch =labValues;
        end
         
        
    
    end
    
    bestLabMatch =100;
    row = mod(i-1,y)+1;
    col = ceil(i/(y));
    
    nameArray(col,row) = nameOfBestMatch;
end

outputArg1 = nameArray;

end

