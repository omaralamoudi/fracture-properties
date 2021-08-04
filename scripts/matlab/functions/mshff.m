function results = mshff(inputimage,s)
%MSHFF impelements Voorn et al. (2013) algorith for multi-scale Hessian
%fracture filtering.
%   MSHFF(image, s) computes an enhanced image by convolving different
%   hessian kernals corresponding to the scaling parameter s. s is either a
%   scalar or a vector with different scales measured in voxels. E.g.,
%   result = MSHFF(image, [1 2 6]) produces an image after enhancing
%   features that are 1, 2, and 6 voxels in scale.

% By Omar Alamoudi: omar.alamoudi@gmail.com
% Last updated:     April 6, 2021
%
if is2d(inputimage)
    kernels = get_kernals(s,9);
elseif is3D(inputimage)
else
    error('Image is neither 2D or 3D'); 
end



end

function itis = is2d(img)
    dim  = size(size(img));
    itis = dim(2) == 2;
end

function itis = is3d(img)
    dim  = size(size(img));
    itis = dim(2) == 3;
end