clearvars; clc; close all;
data2 = loadImageSeq('output/3D/synth images/blurred+noisy','.tif');
loadSyntheticImageParams;

%%
tt = tic;
s = fracAps/2;
cumresult = zeros(size(data2.image));
gamma = 0.7;
for i = 1:length(s)
    FracMapResult(i) = FracMap(data2.image,fracAps(i),s(i),gamma);
    cumresult = cumresult + FracMapResult(i).Cs.image; 
end
cumresult_norm = cumresult / max(cumresult(:));
TT = toc(tt);
%%
figure
subplot(1,2,1);
imagesc(data2.image(:,:,2));
colorbar
subplot(1,2,2);
imagesc(1-cumresult_norm(:,:,2));
colormap gray
colorbar