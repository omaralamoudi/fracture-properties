% defining the figures directory
figuresDirectory = '../../manuscripts/figures/';

%% Synthetic image parametrs. These are used inside the functions gnerateSynthFracs*.m

% defining fracture aparturs use in the 2d and 3d synthetic frac images
% fracAps = [2,10,15,30];
fracAps = [1,2,3,4,6];      % simpler for testign code

% defining length of a image single edge [pixels or voxels]
% dim = 512;
dim = 100;           % smaller for testing code

% defining Signal to noise ratio (5 --> noise amp is 1/5 of the signal) 
SNR = 5;

% definig blurring box filter size (must be an odd integer)
filterSize = 5;

% font size for figures
fontSize = 16; 
