
data2 = loadImageSeq('output/3D/synth images/blurred+noisy','.tif');
inputimage = data2.image;
%%
tt = tic;
s = fracAps/2;
FracMapCumResult = zeros(size(inputimage));
gamma = 0.7;
for i = 1:length(s)
    FracMapResult(i) = FracMap(inputimage,fracAps(i),s(i),gamma);
    FracMapCumResult = FracMapCumResult + FracMapResult(i).Cs.image; 
end
FracMapCumResult_norm = FracMapCumResult / max(FracMapCumResult(:));
TT = toc(tt);

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
%%
figure
subplot(2,2,1);
imagesc(inputimage(:,:,2));
colorbar
subplot(2,2,2);
imagesc(1-FracMapCumResult_norm(:,:,2));
title('FracMap');
colormap gray
colorbar

subplot(2,2,3);
imagesc(inputimage(:,:,2));
colorbar
subplot(2,2,4);
imagesc(1-mshffCumResult_norm(:,:,2));
title('mshff');
colormap gray
colorbar