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
data(1).img          = MakeFracImage2D(dim,fracAps);
imwrite(data(1).img,[targetdir,filesep,'synthetic.tif']); 
data(1).description  = "Synthetic Fracture Image (SFI)";
data(2).img          = AddNoise(data(1).img,SNR);
imwrite(data(2).img,[targetdir,filesep,'synthetic+noise.tif']); 
data(2).description = "SFI + Noise";

%% Generating blurred images
data(3).img          = imboxfilt(data(1).img,filterSize);
imwrite(data(3).img,[targetdir,filesep,'synthetic+blurred.tif']); 
data(3).description  = "Synthetic Blurred Fracture Image (SBFI)";
data(4).img          = imboxfilt(data(2).img,filterSize);
imwrite(data(4).img,[targetdir,filesep,'synthetic+blurred+noise.tif']); 
% data(4).img          = imboxfilt(data(2).img,filterSize);
data(4).description  = "SBFI + Noise";

%% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,1);
ShowImage(data(1),fontSize);

subplot(2,2,2);
ShowImage(data(2),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(data(1).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(data(1),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(data(2).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(data(2),traverseXCoor,fontSize); 

% blurred images
fig2 = figure('Position',[100 100 800 800],'Name','Blured Images');
subplot(2,2,1);
ShowImage(data(3),fontSize);

subplot(2,2,2);
ShowImage(data(4),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(data(3).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(data(3),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(data(4).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(data(4),traverseXCoor,fontSize);

fig = gcf;
