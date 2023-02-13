function [outputArg1,outputArg2,clusterCores] = KmeansOnCellArray(cellArray,Nr_clusters)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ArrayOflab = [];
CIDb =cellArray;
for i=1:length(CIDb)
    labValues = cell2mat(CIDb{i}(2));
    ArrayOflab(i,:) = [labValues(1),labValues(2),labValues(3)];
end


%k-means do split the colors into clusters
[index,C] = kmeans(ArrayOflab,Nr_clusters);
rgbColorsRaw = [];

%displays the colors given from the cluster cores
for i = 1:length(C)
    rgbColorsRaw(i,1:3) = lab2rgb(C(i,1:3));
end



% now we need to connect the ClusterColors to the filenames #profit

counter = 1;
newDatabase = {};
valueBestMatch=1000;
rgbColorsFromMatrix =[];

%Way too complicated than it should be but it works... 
for i = 1:length(C)
    for j =1:length(CIDb)
        cluster = C(i,1:3);
        cellmat = cell2mat(CIDb{j}(1,2));
        %apparently The centroid issnt always a value from the original
        %matrix... 
        deltaE = sqrt((cellmat(1)-cluster(1))^2+(cellmat(2)-cluster(2))^2+(cellmat(3)-cluster(3))^2);
        
         if valueBestMatch>deltaE
            valueBestMatch = deltaE;
            newDatabase{counter} = CIDb{i};
            rgbColorsFromMatrix(counter,1:3) = lab2rgb(cellmat(1,1:3));
         end
        
        
    end
    valueBestMatch = 100;
    counter = counter+1;
end

outputArg1 = newDatabase;
outputArg2 = rgbColorsFromMatrix;
clusterCores = rgbColorsRaw;

end

