clearvars;

data4 = loadImageSeq('/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/fracture properties/using Voorn-2013/runs/test run 01/root/input','.tif');
inputimage = data4.image;

%%
tt = tic;
s = 1:2:7;
fracAps = 2*s;
FracMapCumResult = zeros(size(inputimage));
gamma = 0.7;
for i = 1:length(s)
    FracMapResult(i) = FracMap(inputimage,fracAps(i),s(i),gamma);
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
    svalue = ones(1,3) * s(i);
    mshffResult(i) = mshff(inputimage,svalue,gamma);
    mshffCumResult = mshffCumResult + mshffResult(i).Cs.image; 
end
mshffCumResult_norm = mshffCumResult / max(mshffCumResult(:));
TT = toc(tt);
disp(['mshff finished in: ',num2str(TT),' secs']);

%%
zslice = 50;

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