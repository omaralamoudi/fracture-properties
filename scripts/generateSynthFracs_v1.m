%% generate a 2D image
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
imgDim = 2; 

% Given length of a single edge [pixels or voxels]
% dim = 512;
dim = 40;           % smaller for testing code

% Given fracture aparturs
% fracAps = [2,10,15,30];
fracAps = [0.25 0.5 1 2];      % simpler for testign code

% Given Signal to noise ratio (5 --> noise amp is 1/5 of the signal) 
SNR = 10;

% Given box filter size (must be an odd integer)
filterSize = 3;

% IMAGE GENERATION AND DISPLAY
% Creating a folder named output to save output images
mkdir output
addpath('output'); 
% Generating crisp (not blurred) images
img(1).img          = MakeFracImage2D(dim,fracAps);
imwrite(img(1).img,'output/synthetic.tif'); 
img(1).description  = "Synthetic Fracture Image (SFI)";
img(2).img          = MakeFracImage2D(dim,fracAps,true,SNR);
imwrite(img(2).img,'output/synthetic+noise.tif'); 
img(2).description = "SFI + Noise";

% Generating blurred images
img(3).img          = imboxfilt(img(1).img,filterSize);
imwrite(img(3).img,'output/synthetic+blurred.tif'); 
img(3).description  = "Synthetic Blurred Fracture Image (SBFI)";
img(4).img          = AddNoise(img(3).img,SNR);
imwrite(img(4).img,'output/synthetic+blurred+noise.tif'); 
% img(4).img          = imboxfilt(img(2).img,filterSize);
img(4).description  = "SBFI + Noise";

% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,1);
ShowImage(img(1));

subplot(2,2,2);
ShowImage(img(2));

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(1).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(1),traverseXCoor); 

subplot(2,2,4);
dim = size(img(2).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(2),traverseXCoor); 

% blurred images
fig2 = figure('Position',[100 100 800 800],'Name','Blured Images');
subplot(2,2,1);
ShowImage(img(3));

subplot(2,2,2);
ShowImage(img(4));

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(3).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(3),traverseXCoor); 

subplot(2,2,4);
dim = size(img(4).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(4),traverseXCoor); 