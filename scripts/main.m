%% This is the entry way into the rest of the scripts

%% Go to primary directory

if (ispc)
    cd 'C:\Users\oma385\Dropbox\GraduateSchool\PhD\Projects\';
elseif (ismac)
    cd '~/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/scripts';    
end
addpath(genpath('.'));

home;
InitColormaps();

%% Generating 2D synthetic imags
generateSynthFracs2D;

FracMap_Prototype2D;