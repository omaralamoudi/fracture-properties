clearvars; close all; clc
data(1).path.pc = 'C:\Users\oma385\Dropbox\GraduateSchool\PhD\Projects\fracture properties\using Voorn-2013\runs\test run 01\root\input';
data(1).path.mac= '~/Dropbox/GraduateSchool/PhD/Projects/fracture properties/using Voorn-2013/runs/test run 01/root/input';
data(2).path.pc = 'C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/scripts/matlab/output/3D/synth images/voorn';
data(2).path.mac= '~/Dropbox/GraduateSchool/PhD/Projects/fracture properties/scripts/matlab/output/3D/synth images/voorn';

i = 2;
data2 = loadImageSeq(data(i).path.pc,'.tif');
% data4 = uiLoadImageSeq('.tif');
% inputimage = data4.image(:,:,5:20);
inputimage = data2.image;

s = 1:2:7;
fracAps = 2*s;
gamma = 0.7;

%%
tt = tic;
FracMapCumResult = zeros(size(inputimage));
for i = 1:length(s)
    FracMapResult(i) = FracMap_prototype(inputimage,fracAps(i),s(i),gamma);
    FracMapCumResult = FracMapCumResult + FracMapResult(i).Cs.image; 
end
FracMapCumResult_norm = FracMapCumResult / max(FracMapCumResult(:));
TT = toc(tt);
disp(['FracMap finished in: ',num2str(TT),' secs']);

%%
tt = tic;
s = fracAps/2;
mshffCumResult = zeros(size(inputimage));
for i = 1:length(s)
    svalue = ones(1,ndims(inputimage)) * s(i);
    mshffResult(i) = mshff_prototype(inputimage,svalue,gamma);
    mshffCumResult = mshffCumResult + mshffResult(i).Cs.image; 
end
mshffCumResult_norm = mshffCumResult / max(mshffCumResult(:));
TT = toc(tt);
disp(['mshff finished in: ',num2str(TT),' secs']);

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
imagesc(1-FracMapCumResult_norm(:,:,zslice));
title('FracMap');
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