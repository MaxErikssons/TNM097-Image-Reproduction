%% Function to calculate the color difference
function [deltaE] = colorDifference(L,a,b, L_ref, a_ref, b_ref)
    deltaE = sqrt((L - L_ref).^2 + (a - a_ref).^2 + (b - b_ref).^2);
end