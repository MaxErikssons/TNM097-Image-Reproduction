function [outputArg1] = reconstructWithSsim(FilePath,imageDataBase,subImageScale)
%Start för 1.5: return of the ssim, the tale of defeat

% read an image
 if ~exist('subImageScale','var')
     % third parameter does not exist, so default it to something
      subImageScale = 1;
 end
[inpict,colmap] = imread(FilePath) % 384x512x3

kmeanedArray = imageDataBase;%%byt när vi gör detta till en funktion


%tileing 
[OGrow,OGcol,whatever] = size(inpict);
[tilesrow,tilescol,whatever] = size(imread(string(kmeanedArray{1}(1))));
tilescol= tilescol*subImageScale%%scaling factor on the images used to reproduce
tilesrow= tilesrow*subImageScale;
x = floor(OGrow/tilesrow);
y = floor(OGcol/tilescol);

Nr_row = x; %% HÄR BESTÄMMER NI HUR MÅNGA TILES DET SKA VARA Testa gärna med lite färre om ni ska köra 2500 tiles tar fan tid... 

tiling = [x y]; % [y x]
subimages = imdetile(inpict,tiling,'direction','row'); % 77x85x3x30
%split into tiles
montage(subimages,'size',tiling,'bordersize',[1 1],'backgroundcolor','w')

%start värden
valueBestMatch = 0;
nameOfBestMatch  ="";
ssimNameArray = strings;
bestLabMatch = 100;
labOfBestMatch = [];


%for varje tile 

%för alla tiles i subimage
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
    %%pick up the images closest to the best matching image, i think we
    %%might use a threshold to make this useable...
   
    for q = 1:length(kmeanedArray)
        %HOOOLD UP HERE IS SOMETHING WRONG I THINK! or maybe not... 
        labValues = cell2mat(kmeanedArray{q}(2));
        deltaE = sqrt((labOfBestMatch(1)-labValues(1))^2+(labOfBestMatch(2)-labValues(2))^2+(labOfBestMatch(3)-labValues(3))^2);
        
        %vi skulle kunna spara alla redan här... men det har också sina
        %problem 
        
        
        %%läste att 2.3 i deltaE är just noticable differense så vi kör det
        %%som default
        if deltaE < 2.3 %% this value needs to be configured
            if topMatches(1) == ""
                
                    topMatches(1) =kmeanedArray{q}(1);
            else
                
                    topMatches = vertcat(kmeanedArray{q}(1),topMatches);
            end
        end
    end
    %när det är gjort vill vi utväerdera vilken av bilderna som har bäst
    %ssim
    topMatches;
    
    stringWithBestSsim = "";
    currentBestSsim = -1;
    for t = 1:length(topMatches)
        grayTile = rgb2gray(im2double(subimages(:,:,:,i)));
        [row,col] = size(grayTile);
        %optimal is to keep the tileing such that each tile is 20x20 or
        %whatever size the images used to reproduce is
        grayImg = imresize(rgb2gray(im2double(imread(topMatches(t)))),[row,col],"bicubic");
        
        grayTile = imresize(grayTile,[row,col],"bicubic");
        ssimRes = ssim(grayImg,grayTile);
        if ssimRes > currentBestSsim 
            currentBestSsim = ssimRes;
            stringWithBestSsim = topMatches(t);
            
            
        end
        
    end
    bestLabMatch = 100;
    %hur vi bygger namearray
    row = mod(i-1,y)+1;
    col = ceil(i/(y));
    sep ="";
    if stringWithBestSsim == ""
        vafan = 0 
        topMatches
    end
    ssimNameArray(col,row) = stringWithBestSsim;
    valueBestMatch=0;
end

outputArg1 = ssimNameArray
end

