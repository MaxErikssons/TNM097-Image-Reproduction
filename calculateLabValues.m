% This function calculate the lab values for a given folder 
% and saves them in the mat file "name".

function [] = calculateLabValues(folder, name)
imagefiles = dir(fullfile(folder,'*.jpg')); % Store the images
nfiles = length(imagefiles); % Define number of images.

stored_Lab_values = cell(1, nfiles); % Allocate space
prog = 0;
tic
for i = 1:nfiles
    filename=fullfile(folder,imagefiles(i).name); % Get filename of current image.
    Im =im2double(imread(filename)); % Read the imagefile, convert to double and store it.
    im_to_lab = rgb2lab(Im);
    [L, a, b] = deal(mean2(im_to_lab(:,:,1)), mean2(im_to_lab(:,:,2)), mean2(im_to_lab(:,:,3)));
    stored_Lab_values{i} = {filename, L, a, b};
    prog = ( 100*(i/nfiles) );
    fprintf(1,'\b\b\b\b%3.0f%%',prog); % Deleting 4 characters (The three digits and the % symbol)
end
fprintf('\n'); % To go to a new line after reaching 100% progress
fprintf('All Lab values has been stored\n')

save(name,'stored_Lab_values');
toc
end