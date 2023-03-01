function [SCIELAB,SSIM,SNR] = qualityMeasure(originalImage,reproducedImage)

addpath('scielab/')
% compares the quality of the reproduced image to the original
% returns S-CIELAB, SSIM and SNR

% make sure we have doubles
original_2_double = im2double(originalImage);
reproduced_2_double = im2double(reproducedImage);

% snr calculation
SNR = snr(original_2_double, original_2_double - reproduced_2_double);

% ssim calculation
SSIM = ssim(original_2_double, reproduced_2_double);

% s-cielab calculation (full reference)

% convert to xyz
original_2_xyz = rgb2xyz(original_2_double);
reproduced_2_xyz = rgb2xyz(reproduced_2_double);

% pixels per inch
ppi = 72;
% viewing distance in inch
d = 100/2.5;
sample_per_degree = ppi * d * tan(pi/180);
white_point = [95.05, 100, 108.9];
scilab_val = scielab(sample_per_degree, original_2_xyz, reproduced_2_xyz, white_point, 'xyz');
SCIELAB = mean(mean(scilab_val));

end