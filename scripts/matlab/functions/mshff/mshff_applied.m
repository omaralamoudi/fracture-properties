clearvars; close all; clc
data = loadImageSeq('output/3D/synth images/voorn','.tif');
loadSyntheticImageParams;

% s = fracAps/2;
s = fracAps(1)/2;
inputimage = data.image;
gamma = 0.9;

% adding 2d slices aling the z direction for proper results in the the 3rd
% dimention

%%
    
cumresult = zeros(size(data.image));    
for i = 1:length(s)
    svalue = ones(1,ndims(inputimage)) * s(i);
    mshffResult(i) = mshff(inputimage,svalue,gamma);
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