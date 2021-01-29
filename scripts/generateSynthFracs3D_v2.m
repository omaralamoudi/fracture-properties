%% generate a 3D image
% Dependencies: this script needs to access to a directory with the
% following functions:
%   MakeFracImage2D.m
%   AddNoise.m
%   ShowImage.m
%   ShowProfile.m

% adding the directory funtions that contains the functions used in this
% script
addpath('functions'); 

% USER SPECIFIED PARAMETERS 
% Givin an image dimentions (either 2D or 3D)
imgDim = 3; 

% Given length of a single edge [pixels or voxels]
% dim = 512;
dim = 100;           % smaller for testing code

% Given fracture aparturs
% fracAps = [2,10,15,30];
fracAps = [1,2,3,4,6];      % simpler for testign code

% Given Signal to noise ratio (5 --> noise amp is 1/5 of the signal) 
SNR = 10;

% Given box filter size (must be an odd integer)
filterSize = 3;

% IMAGE GENERATION AND DISPLAY
% Creating a folder named output to save output images
% mkdir output
% addpath('output');


% Generating crisp (not blurred) images
img(1).img          = MakeFracImage3D(dim,fracAps);
for i = 1:3
    imwrite(img(1).img(:,:,i),['output/3Dsynthetic_',num2str(i),'.tif']); 
end
img(1).description  = "Synthetic Fracture Image (SFI)";
img(1).abreriation  = "SFI";
img(2).img          = MakeFracImage3D(dim,fracAps,true,SNR);
for i = 1:3
    imwrite(img(2).img,['output/3Dsynthetic+noise_',num2str(i),'.tif']);
end
img(2).description = "SFI + Noise";
img(2).abreriation = "SFIN";

% Generating blurred images
img(3).img          = imboxfilt3(img(1).img,filterSize);
for i = 1:3
    imwrite(img(3).img,['output/3Dsynthetic+blurred_',num2str(i),'.tif']); 
end
img(3).description  = "Synthetic Blurred Fracture Image (SBFI)";
img(3).abreriation  = "SBFI";
img(4).img          = AddNoise(img(3).img,SNR);
for i = 1:3 
    imwrite(img(4).img,['output/synthetic+blurred+noise_',num2str(i),'.tif']); 
end
img(4).description  = "SBFI + Noise";
img(4).abreriation  = "SBFIN";

% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,1);
ShowImage3D(img(1));

subplot(2,2,2);
ShowImage3D(img(2));

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(1).img,1);
traverseXCoor = floor(dim/2);
ShowProfile3D(img(1),traverseXCoor); 

subplot(2,2,4);
dim = size(img(2).img,1);
traverseXCoor = floor(dim/2);
ShowProfile3D(img(2),traverseXCoor); 
print('..\Presentation\figures\3DSyntheticFractureImages','-dpng');

% blurred images
fig2 = figure('Position',[100 100 800 800],'Name','Blured Images');
subplot(2,2,1);
ShowImage3D(img(3));

subplot(2,2,2);
ShowImage3D(img(4));

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(3).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(3),traverseXCoor); 

subplot(2,2,4);
dim = size(img(4).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(4),traverseXCoor);
print('..\Presentation\figures\3DSyntheticBlurredFractureImages','-dpng');