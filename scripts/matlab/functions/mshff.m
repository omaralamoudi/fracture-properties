function result = mshff(img,s)
%MSHFF impelements Voorn et al. (2013) algorith for multi-scale Hessian
%fracture filtering.
%   MSHFF(image, s) computes an enhanced image by convolving different
%   hessian kernals corresponding to the scaling parameter s. s is either a
%   scalar or a vector with different scales measured in voxels. E.g.,
%   result = MSHFF(image, [1 2 6]) produces an image after enhancing
%   features that are 1, 2, and 6 voxels in scale.

% By Omar Alamoudi: omar.alamoudi@gmail.com
% Last updated:     April 6, 2021

imgdims = ndims(img);
result.s = s;
result.hessian.description = 'an image that contains a slices of one of the Hessian-component-filtered image';
result.hessian.image = zeros([size(img),imgdims.^2]);
result.As.description = 'lambda_3 - |lambada_2| - |lambda_1|';
result.As.image = zeros(size(img));
result.Bs.description = 'normalized As';
result.Bs.image = result.As.image;
result.Cs.description = 'threshold binarization';
result.Cs.image = result.As.image;
result.Cs.gamma = .9;
result.voxel.description = 'results per voxel';

    hessianKernels = getHessianKernels(s,imgdims);
    
    % apply hessian component filters
    for j = 1:hessianKernels.nslices
        if hessianKernels.dims == 2
            result.hessian.image(:,:,j) = imfilter(img,hessianKernels.slice{j},'conv');
        elseif hessianKernels.dims == 3
            result.hessian.image(:,:,:,j) = imfilter(img,hessianKernels.slice{j},'conv');
        else
            error('mshff: a problem with dimensions');
        end
    end
    
    % collecting per voxel hessian results
    if hessianKernels.dims == 2
        disp('mshff: 2d: started voxel wise operations');
        tHessian3d = tic;
        for j = 1:size(img,1)
            for i = 1:size(img,2)
                result.voxel(j,i).hessian.matrix = reshape(result.hessian.image(j,i,:),[imgdims,imgdims]);
                [result.voxel(j,i).hessian.eigvec, result.voxel(j,i).hessian.eigval] = myeig(result.voxel(j,i).hessian.matrix);
                result.As.image(j,i) = result.voxel(j,i).hessian.eigval(1) ...
                    - abs(result.voxel(j,i).hessian.eigval(2)) ...
                    - abs(result.voxel(j,i).hessian.eigval(3));
            end
        end
        t = toc(tHessian3d);
        disp(['mshff: 2d: completed voxel-wise operations in ',num2str(t),' secs']);
    elseif hessianKernels.dims == 3
        disp('mshff: 3d: started voxel wise operations');
        tHessian3d = tic;
        for k = 1:size(img,3)
            for j = 1:size(img,1)
                for i = 1:size(img,2)
                    result.voxel(j,i,k).hessian.matrix = reshape(result.hessian.image(j,i,k,:),[imgdims,imgdims]);
                    [result.voxel(j,i,k).hessian.eigvec, result.voxel(j,i,k).hessian.eigval] = myeig(result.voxel(j,i,k).hessian.matrix);
                    result.As.image(j,i,k) = result.voxel(j,i,k).hessian.eigval(1) ...
                        - abs(result.voxel(j,i,k).hessian.eigval(2)) ...
                        - abs(result.voxel(j,i,k).hessian.eigval(3));
                end
            end
        end
        t = toc(tHessian3d);
        disp(['mshff: 3d: completed voxel-wise operations in ',num2str(t),' secs']);
    else
        error('mshff: unable to determine dimentions');
    end
    result.As.image(result.As.image <= 0) = 0;
    result.Bs.image = result.As.image / max(result.As.image(:));
    result.Cs.image(result.Bs.image > 1 - result.Cs.gamma) = 1; 
    
hsize = size(hessianKernels);
hessianComponentCount = hsize(end);
end

function [eigvec, eigval] = myeig(M)
% This computes the eigen values, sorts them from largest to smallest, and
% makes them right handed. 
[tmp.eigvec, tmp.eigval] = eig(M);
% [~,indx] = sort(diag(tmp.eigval),'descend');
[~,indx] = sort(diag(tmp.eigval),'descend');
eigval = tmp.eigval(indx,indx);
eigval = diag(eigval);
eigvec = tmp.eigvec(:,indx);
% keyboard
if cross(eigvec(:,1),eigvec(:,2))' * eigvec(:,3) < 0
    eigvec(:,3) = -eigvec(:,3);
end
end
