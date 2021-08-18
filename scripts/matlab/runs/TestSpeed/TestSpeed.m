clear; close all; clc
a=rand(794,794,151);
b=fspecial3('gaussian',19,3);
disp('CPU');
tic
c=convn(a,b);
toc
disp('GPU');
tic
ag=gpuArray(a);
bg=gpuArray(b);
cg=convn(ag,bg);
cg=gather(cg);
toc
figure
imagesc(c(:,:,76)-cg(:,:,76));
colorbar
title('residual CPU-GPU');
saveas(gcf,['./TestSpeed.png']);