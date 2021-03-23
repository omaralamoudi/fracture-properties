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

% IMAGE GENERATION AND DISPLAY
% Creating a folder named output with a subdirectory structure 
% 2D/synth images that contains the generated synthetic 2D images

targetdir = ['output',filesep,'2D',filesep,'synth images'];
if not(exist(targetdir,'dir')), mkdir(targetdir); end
addpath(genpath(targetdir)); 

%% Generating crisp (not blurred) images
img(1).img          = MakeFracImage2D(dim,fracAps);
imwrite(img(1).img,[targetdir,filesep,'synthetic.tif']); 
img(1).description  = "Synthetic Fracture Image (SFI)";
img(2).img          = AddNoise(img(1).img,SNR);
imwrite(img(2).img,[targetdir,filesep,'synthetic+noise.tif']); 
img(2).description = "SFI + Noise";

%% Generating blurred images
img(3).img          = imboxfilt(img(1).img,filterSize);
imwrite(img(3).img,[targetdir,filesep,'synthetic+blurred.tif']); 
img(3).description  = "Synthetic Blurred Fracture Image (SBFI)";
img(4).img          = imboxfilt(img(2).img,filterSize);
imwrite(img(4).img,[targetdir,filesep,'synthetic+blurred+noise.tif']); 
% img(4).img          = imboxfilt(img(2).img,filterSize);
img(4).description  = "SBFI + Noise";

%% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,1);
ShowImage(img(1),fontSize);

subplot(2,2,2);
ShowImage(img(2),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(1).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(1),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(img(2).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(2),traverseXCoor,fontSize); 

% blurred images
fig2 = figure('Position',[100 100 800 800],'Name','Blured Images');
subplot(2,2,1);
ShowImage(img(3),fontSize);

subplot(2,2,2);
ShowImage(img(4),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(3).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(3),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(img(4).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(4),traverseXCoor,fontSize);

fig = gcf;
