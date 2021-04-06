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

saveFigures = 0; 
writeImages = 1;

% USER SPECIFIED PARAMETERS 
% Givin an image dimentions (either 2D or 3D)
imgDim = 3; 

% IMAGE GENERATION AND DISPLAY
% Creating a folder named output with a subdirectory structure 
% 3D/synth images that contains the generated synthetic 3D images

targetdir = ['output',filesep,'3D',filesep,'synth images'];
if not(exist(targetdir,'dir')), mkdir(targetdir); end
addpath(genpath(targetdir));

%% Generating crisp (not blurred) images

img(1).img          = MakeFracImage3D(dim,fracAps);
img(1).description  = "Synthetic Fracture Image (SFI)";
img(1).abreviation  = "SFI";

if writeImages; writeimageseq(img(1).img,targetdir,'synthetic_','.tif'); end %#ok<*UNRCH>

% Crips noisy image
img(2).img          = MakeFracImage3D(dim,fracAps,true,SNR);
img(2).description  = "SFI + Noise";
img(2).abreviation  = "SFIN";

if writeImages; writeimageseq(img(2).img,targetdir,'synthetic+noise','.tif'); end %#ok<*UNRCH>

% Blurring clean image
img(3).img          = imboxfilt3(img(1).img,filterSize);
img(3).description  = "Synthetic Blurred Fracture Image (SBFI)";
img(3).abreviation  = "SBFI";

if writeImages; writeimageseq(img(3).img,targetdir,'synthetic+blurred','.tif'); end %#ok<*UNRCH>

% Blurry noisy image
for i = 1:3
    img(4).img      = AddNoise(img(3).img,SNR);
end
img(4).description  = "SBFI + Noise";
img(4).abreviation  = "SBFIN";

if writeImages; writeimageseq(img(4).img,targetdir,'synthetic+blurred+noise','.tif'); end %#ok<*UNRCH>

% % generating a sequence of 27 images to use with Voorn
% mkdir([targetdir,filesep,'voorn'])
% for i = 1:27
%     tmp = MakeFracImage2D(dim,fracAps,true,SNR);
%     tmp = imboxfilt(tmp,filterSize);
%     imwrite(tmp,[targetdir,filesep,'voorn-input_',num2str(i),'.tif']);
% end

%% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,1);
ShowImage3D(img(1),fontSize);

subplot(2,2,2);
ShowImage3D(img(2),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(1).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(1),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(img(2).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(2),traverseXCoor,fontSize); 
% the following line is to save the figures
if (saveFigures), print([figuresDirectory,'3DSyntheticFractureImages'],'-dpng'); end 

% blurred images
fig2 = figure('Position',[100 100 800 800],'Name','Blured Images');
subplot(2,2,1);
ShowImage3D(img(3),fontSize);

subplot(2,2,2);
ShowImage3D(img(4),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(img(3).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(3),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(img(4).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(img(4),traverseXCoor,fontSize);
if (saveFigures), print([figuresDirectory,'3DSyntheticBlurredFractureImages'],'-dpng');end  