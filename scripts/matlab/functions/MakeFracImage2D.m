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
    %   May 1, 2019: added the capability of adding fractures with
    %   apertures < 1 by assigning the aperture as the pixel value.
    
    if nargin < 3 ; noisy = false; SNR = 1; end
    nFracs      = length(apertures);
    totalFracAp = sum(ceil(apertures));
    img         = ones(dim);
    
    % vertical spacing
    vSpacing    = floor((dim - totalFracAp)/(nFracs+1));
    l           = floor(dim/4);     % left edge
    r           = ceil(dim*3/4);    % right edge
    
    
    % the first fractures
    t = vSpacing;                   % top edge
    b = t + ceil(apertures(1)) - 1;     % bottom edge
    % If the fracture aperture is < 1, assign the aperture itself as the
    % pixel value.
    if (apertures(1) < 1)
        img(t:b,l:r) = 1 - apertures(1);
    else
        img(t:b,l:r) = 0;
    end
    % the rest of the fracutres
    for i = 2:nFracs
        t = t + vSpacing+ceil(apertures(i-1));
        b = t + ceil(apertures(i))-1;
        if (apertures(i) < 1)
            img(t:b,l:r) = 1 - apertures(i);
        else
            img(t:b,l:r) = 0;
        end
    end
    
    if (noisy)
        img = AddNoise(img,SNR);
    end
    
end