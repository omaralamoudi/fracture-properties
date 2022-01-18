clearvars; close all; clc
data = loadImageSeq('output/3D/synth images/voorn','.tif');
loadSyntheticImageParams;
%%
s = fracAps/2;
inputimage = data.image;
cumresult = zeros(size(data.image));
gamma = 0.9;
for i = 1:length(s)
    svalue = ones(1,ndims(inputimage)) * s(i);
    mshffResult(i) = mshff_prototype(inputimage,svalue,gamma);
    cumresult = cumresult + mshffResult(i).Cs.image; 
end
cumresult_norm = cumresult / max(cumresult(:));
%%
figure('Position',[0 100 800 350]);
suptitle("s = ["+num2str(s)+"], $\gamma$ = "+num2str(gamma));
subplot(1,2,1);
imagesc(data.image(:,:,2));
colorbar
subplot(1,2,2);
imagesc(1-cumresult_norm(:,:,2));
colormap gray
colorbar