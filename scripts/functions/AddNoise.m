function [noisyImage] = AddNoise(img,SNR)
    noise = rand(size(img))/SNR;
    noisyImage = img + noise - mean(noise(:));
end