%% This is the entry way into the rest of the scripts

%% Go to primary directory

goto(3); 

addpath(genpath('.'));

clearvars; close all; home;

%% loading parameters
loadSyntheticImageParams; 
%% setting some style parametrs
home;
InitColormaps();
setEdgerStyle();

%% Generating 2D synthetic imags
% generateSynthFracs2D;
%% Enhancing 2d image
% FracMap_Prototype2D;
%% Generating 3D synthtic images
generateSynthFracs3D;
%% Enhancing 3d image
FracMap_Prototype3D;
%% Showing Voorns output
showingVoornsOutput;