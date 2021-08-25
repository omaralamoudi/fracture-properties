
data2 = loadImageSeq('output/3D/synth images/blurred+noisy','.tif');
%%
tt = tic;
s = fracAps/2;
cumresult = zeros(size(data2.image));
gamma = 0.7;
for i = 1:length(s)
    svalue = ones(1,3) * s(i);
    mshffResult(i) = mshff(data2.image,svalue,gamma);
    cumresult = cumresult + mshffResult(i).Cs.image; 
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