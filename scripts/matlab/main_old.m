%% This is the entry way into the rest of the scripts

%% Go to primary directory

if (ispc)
    error('Determine the path to the project'); 
elseif (ismac)
    cd '~/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/scripts/matlab';    
end

addpath(genpath('.'));

clearvars; close all; home;

%% loading parameters
loadparams; 
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