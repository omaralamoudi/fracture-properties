%% This script will serve as a comparison point for adding features or
% improving mshff. The basic approach is to add modifications to
% mshff_prototype.m and compare the performance with mshff.m. If the
% prototype is more performant, we adopt the change

%% Current objective
% Compare the performance after removing the the waitbar and replacing it
% with a TextProgressBar

%%
clearvars;
data(1).path.pc = 'C:\Users\oma385\Dropbox\GraduateSchool\PhD\Projects\fracture properties\using Voorn-2013\runs\test run 01\root\input';
data(1).path.mac= '~/Dropbox/GraduateSchool/PhD/Projects/fracture properties/using Voorn-2013/runs/test run 01/root/input';
data(2).path.pc = 'C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/scripts/matlab/output/3D/synth images/blurred+noisy';
data(2).path.mac= '~/Dropbox/GraduateSchool/PhD/Projects/fracture properties/scripts/matlab/output/3D/synth images/blurred+noisy';

i = 2;
data2 = loadImageSeq(data(i).path.pc,'.tif');
% data4 = uiLoadImageSeq('.tif');
% inputimage = data4.image(:,:,5:20);
inputimage = data2.image;

% s = 1:2:7;
s = 3;
fracAps = 2*s;
gamma = 0.7;

%% mshff_prototype
tt = tic;
s = fracAps/2;
mshff_prototypeCumResult = zeros(size(inputimage));
for i = 1:length(s)
    svalue = ones(1,ndims(inputimage)) * s(i);
    mshff_prototypeResult(i) = mshff_prototype(inputimage,svalue,gamma);
    mshff_prototypeCumResult = mshff_prototypeCumResult + mshff_prototypeResult(i).Cs.image; 
end
mshff_prototypeCumResult_norm = mshff_prototypeCumResult / max(mshff_prototypeCumResult(:));
TT = toc(tt);
disp(['All mshff_prototype finished in: ',num2str(TT),' secs']);

%%
tt = tic;
s = fracAps/2;
mshffCumResult = zeros(size(inputimage));
for i = 1:length(s)
    svalue = ones(1,ndims(inputimage)) * s(i);
    mshffResult(i) = mshff(inputimage,svalue,gamma);
    mshffCumResult = mshffCumResult + mshffResult(i).Cs.image; 
end
mshffCumResult_norm = mshffCumResult / max(mshffCumResult(:));
TT = toc(tt);
disp(['All mshff finished in: ',num2str(TT),' secs']);

%%
if ndims(inputimage) == 3
    zslice = ceil(size(inputimage,3)/2);
else
    zslice = 1;    
end

figure
subplot(2,2,1);
imagesc(inputimage(:,:,zslice));
colorbar
subplot(2,2,2);
imagesc(1-mshff_prototypeCumResult_norm(:,:,zslice));
title('mshff prototype');
colormap gray
colorbar

subplot(2,2,3);
imagesc(inputimage(:,:,zslice));
colorbar
subplot(2,2,4);
imagesc(1-mshffCumResult_norm(:,:,zslice));
title('mshff');
colormap gray
colorbar

%% Conclusion
% The removal of the waitbar in the prototype reduced the computational
% time from 14.1488 secs to 1.5906 secs. That is a significant reduction.
% Therefore I WILL REMOVE THE WAITBARS