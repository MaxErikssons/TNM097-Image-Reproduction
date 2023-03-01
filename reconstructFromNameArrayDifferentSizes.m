function [reproducedImage] = reconstructFromNameArrayDifferentSizes(namearray)
%This function takes a namearray and reproduces an image, the image will
%then consist of smaller images of varying sizes
[row,col] = size(namearray);
%imshow(reconstructFromNameArray(namearray,1));
%min första tanke är gå så långt åt ett håll som möjligt sen gör det åt
%andra hållet och loopa... lite bökigt när jag skriver det såhär men det
%kanske blir tydligt när jag löst det
Repoduced = zeros(row*25,col*25,3);



for i = 1:row
    for j=1:col
        
        depth = 0;
        %%check depth of every row
        while i+depth <= row && namearray(i,j) == namearray(i+depth,j) 
            depth = depth+1;
            
        end
        
        
        reach = 0;
        %%check depth of every row
        while j+reach <= col && namearray(i,j) == namearray(i,j+reach) 
            reach = reach+1;
        end
        
        
        iterator = min(depth,reach)-1;
        
        notOk = true;
        %pretty simple, go as far right/down as we can (staying as the same
        %color/name) then iterate in a square until all elements in this
        %square are of the same color/name, If any of the emelents is not
        %the same as the start we reduce the size of the square
        while notOk
            for x = i:i+iterator
                for y = j:j+iterator
                   
                    if namearray(i,j)~= namearray(x,y)
                        iterator = iterator-1;
                    end
                end
            end
            notOk = false;
        end
        
        iterator= iterator+1;
        
        baseSize = 25;
                    
        current = imread(namearray(i,j)); %Read img
        current = im2double(current); %make double
                   
                    
        current = imresize(current,[baseSize*iterator baseSize*iterator],"bicubic"); %resize according to first step
                   
        start = (i)*baseSize-baseSize+1;
        start2 = (j)*baseSize-baseSize+1;
                   
                    
        if Repoduced(start:start+length(current)-1, start2:start2+length(current)-1, :) == 0;
              Repoduced(start:start+length(current)-1, start2:start2+length(current)-1, :) = current; %replace "namepixel" with image
        end
        

    end
end






smallTiles = reconstructFromNameArray(namearray,1);
[row,col] = size(smallTiles);


for i = 1:row
    for j = 1:col
        if Repoduced(i,j)==0
            Repoduced(i,j)= smallTiles(i,j);
        end
    end
end



%imshow(reconstructFromNameArray(namearray,1));

%%sista du måste göra är att maska värderna så att det svarta blir
%%originalet och restan blir som det ska vara, alternativt att du löser
%%1orna men helt originalet



reproducedImage = Repoduced;

end

