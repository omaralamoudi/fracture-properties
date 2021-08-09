
data2 = loadImageSeq('output/3D/synth images/blurred+noisy','.tif');
%%
tt = tic;
s = fracAps/2;
cumresult = zeros(size(data2.image));
for i = 1:length(s)
    svalue = ones(1,3) * s(i);
    results = mshff(data2.image,svalue);
    cumresult = cumresult + results.Cs.image; 
end
cumresult_norm = cumresult / max(cumresult(:));
TT = toc(tt);
%%
subplot(1,2,1);
imagesc(data2.image(:,:,2));
colorbar
subplot(1,2,2);
imagesc(1-cumresult_norm(:,:,2));
colormap gray
colorbar