function blurredImg = BlurImage(img)
    kernal = (1/5)*[0,1,0;1,1,1;0,1,0];
    blurredImg = ApplyImageFitler(img,kernal);
end