% an attempt at understanding the amplitude produced using fspecial
close all; clc; clearvars
figure
s = 2;
range = 5:4:23;
tl = tiledlayout('flow');
for i = 5:4:23
    zz = fspecial('gaussian',i,s);
    sum(zz(:))
%     max(zz(:))*(s*sqrt(2*pi))
    nexttile
    imagesc(zz);
    colorbar
    axis square
%     plot((1:i)-ceil(i/2),zz(ceil(i/2),:)); hold on;
end

% CONCLUSION:
% The amplitude is simple the multiplicative reciprocal of sum of all 
% kernel elements 1/sum(zz(:)) as Nicola suspected. This was implemented in
% getHessianKernels_prototype