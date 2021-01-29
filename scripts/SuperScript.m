% go to correct directory
if (ispc)
    cd 'C:\Users\oma385\Dropbox\GraduateSchool\PhD\CourseWork\Spring2019\3DAnalysisOfVolumetricData\Project\scripts';
elseif (ismac)
    cd '~/Dropbox/GraduateSchool/PhD/CourseWork/2-Spring2019/3DAnalysisOfVolumetricData/Project/scripts';    
end
addpath(genpath('.'));

clear variables; clc;
InitColormaps();

%% scipt  1
% Ex_gaussian_function; 

%% Generating Symth fractures
generateSynthFracs3D_v2;

clc
