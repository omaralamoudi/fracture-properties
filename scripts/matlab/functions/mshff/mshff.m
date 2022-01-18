function result = mshff(img,s,gamma)
%MSHFF impelements Voorn et al. (2013) algorith for multi-scale Hessian
%fracture filtering.
%   MSHFF(image, s) computes an enhanced image by convolving different
%   hessian kernals corresponding to the scaling parameter s. s is either a
%   scalar or a vector with different scales measured in voxels. E.g.,
%   result = MSHFF(image, [1 2 6]) produces an image after enhancing
%   features that are 1, 2, and 6 voxels in scale.
%
% see also MSHFF_PROTOTYPE
%
% By Omar Alamoudi: omar.alamoudi@gmail.com
% --------------
% UPDATES:
% --------------
% Date | comment
% --------------
% Jan 17, 2021 | replaced waitbar with TextProgressBar for purformance
imgdims = ndims(img);
result.inputimage = img;
result.s = s;
result.hessian.description = 'an image that contains a slices of one of the Hessian-component-filtered image';
result.hessian.image = zeros([size(img),imgdims.^2]);
result.As.description = 'lambda_3 - |lambada_2| - |lambda_1|';
result.As.image = zeros(size(img));
result.Bs.description = 'normalized As';
result.Bs.image = result.As.image;
result.Cs.description = 'threshold binarization';
result.Cs.image = result.As.image;
result.Cs.gamma = gamma;
result.voxel.description = 'result per voxel';

hessianKernels = getHessianKernels(s,imgdims);

filteringPB = TextProgressBar('mshff image filtering','.');
% apply hessian component filters
for slice = 1:hessianKernels.nslices
    if hessianKernels.dims == 2
        result.hessian.image(:,:,slice) = imfilter(img,hessianKernels.slice{slice},'conv','replicate');
    elseif hessianKernels.dims == 3
        result.hessian.image(:,:,:,slice) = imfilter(img,hessianKernels.slice{slice},'conv','replicate');
    else
        error('mshff: a problem with dimensions');
    end
end
filteringPB.update(1);

% collecting per voxel hessian results
vox = 0;
nvox = numel(img);
if hessianKernels.dims == 2
    tpb = TextProgressBar('mshff 2d voxel operations','.');
    for row = 1:size(img,1)
        for col = 1:size(img,2)
            result.voxel(row,col).hessian.matrix = reshape(result.hessian.image(row,col,:),[imgdims,imgdims]);
            [result.voxel(row,col).hessian.eigvec, result.voxel(row,col).hessian.eigval] = myeig(result.voxel(row,col).hessian.matrix);
            result.As.image(row,col) = result.voxel(row,col).hessian.eigval(1) ...
                - abs(result.voxel(row,col).hessian.eigval(2)) ...
                - abs(result.voxel(row,col).hessian.eigval(3));
            if ( mod(vox/nvox*100,1) == 0) tpb.update(vox/nvox); end
            vox = vox + 1;
        end
    end
elseif hessianKernels.dims == 3
    tpb = TextProgressBar('mshff 3d voxel operations','.');
    for lay = 1:size(img,3) % along the z direction
        for row = 1:size(img,1) % along the y direction
            for col = 1:size(img,2) % along the x direction
                result.voxel(row,col,lay).hessian.matrix = reshape(result.hessian.image(row,col,lay,:),[imgdims,imgdims]);
                [result.voxel(row,col,lay).hessian.eigvec, result.voxel(row,col,lay).hessian.eigval] = myeig(result.voxel(row,col,lay).hessian.matrix);
                result.As.image(row,col,lay) = result.voxel(row,col,lay).hessian.eigval(1) ...
                    - abs(result.voxel(row,col,lay).hessian.eigval(2)) ...
                    - abs(result.voxel(row,col,lay).hessian.eigval(3));
                vox = vox + 1;
                if ( mod(vox/nvox,0.01) == 0)
                    tpb.update(vox/nvox);
                end
            end
        end
    end
else
    error('mshff: unable to determine dimentions');
end
result.As.image(result.As.image < 0) = 0;
result.Bs.image = result.As.image ./ max(result.As.image(:));
result.Cs.image(result.Bs.image > 1 - result.Cs.gamma) = 1;
end