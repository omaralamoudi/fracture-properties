%% This is the entry way into the rest of the scripts

%% Go to primary directory

if (ispc)
    error('Determine the path to the project'); 
elseif (ismac)
    cd '~/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/scripts/matlab';    
end

addpath(genpath('.'));

clearvars; close all; home;

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
filterSize = 3;

% font size for figures
fontSize = 16; 
%% setting some style parametrs
home;
InitColormaps();
setEdgerStyle();

%% Generating 2D synthetic imags
% generateSynthFracs2D;
% FracMap_Prototype2D;

%% Generating 3D synthtic images
generateSynthFracs3D;
FracMap_Prototype3D;
%% Showing Voorns output

showingVoornsOutput;