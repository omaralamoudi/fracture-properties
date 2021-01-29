function img = MakeFracImage2D(dim,apertures,noisy,SNR)
    %MAKEFRACIMAGE2D Synthetic 2D image of fractures
    %
    %   MAKEFRACIMAGE2D(dim,apertures) generates a 2D array with
    %   dimentions dim x dim, and horizontally oriented fractures with
    %   widths that snap the middle two quartars of the image.
    %
    %   MAKEFRACIMAGE2D(dim,apertures, noisy, SNR) adds a noise to the
    %   image with the specified SNR (Signal to Noise Ratio)
    %
    %
    %   Author: Omar Alamoudi
    %   Date:   April 4, 2019
    %
    %   Updates ----------------
    %   April 28, 2019: Noise addition through the function AddNoise
    
    if nargin < 3 ; noisy = false; SNR = 1; end
    nFracs      = length(apertures);
    totalFracAp = sum(apertures);
    img         = ones(dim);
    
    % vertical spacing
    vSpacing    = floor((dim - totalFracAp)/(nFracs+1));
    l           = floor(dim/4);
    r           = ceil(dim*3/4);
    % the first fractures
    t = vSpacing;
    b = t + apertures(1);
    img(t:b,l:r) = 0;
    % the rest of the fracutres
    for i = 2:nFracs
        t = t + vSpacing+apertures(i-1);
        b = t + apertures(i);
        img(t:b,l:r) = 0;
    end
    
    if (noisy)
        img = AddNoise(img,SNR);
    end
    
end