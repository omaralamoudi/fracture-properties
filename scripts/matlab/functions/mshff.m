function results = mshff(img,s)
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
results.hessianFilteredComponents.description = 'an image that contains as slices the Hessian component filtered image';
results.hessianFilteredComponents.image = zeros([size(img),imgdims.^2]);
results.As.description = 'lambda_3 - |lambada_2| - |lambda_1|';
results.As.image = zeros(size(img));
results.Bs.description = 'normalized As';
results.Bs.image = results.As.image;
results.Cs.description = 'threshold binarization';
results.Cs.image = results.As.image;
results.Cs.gamma = .7;
results.voxel.description = 'results per voxel';

    hessianKernels = getHessianKernels(s,imgdims);
    
    % apply hessian component filters
    for j = 1:hessianKernels.nslices
        if hessianKernels.dims == 2
            results.hessianFilteredComponents.image(:,:,j) = imfilter(img,hessianKernels.slice{j});
        elseif hessianKernels.dims == 3
            results.hessianFilteredComponents.image(:,:,:,j) = imfilter(img,hessianKernels.slice{j});
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
                results.voxel(j,i).hessian.matrix = reshape(results.hessianFilteredComponents.image(j,i,:),[imgdims,imgdims]);
                [results.voxel(j,i).hessian.eigvec, results.voxel(j,i).hessian.eigval] = myeig(results.voxel(j,i).hessian.matrix);
                results.As.image(j,i) = results.voxel(j,i).hessian.eigval(1) ...
                    - abs(results.voxel(j,i).hessian.eigval(2)) ...
                    - abs(results.voxel(j,i).hessian.eigval(3));
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
                    results.voxel(j,i,k).hessian.matrix = reshape(results.hessianFilteredComponents.image(j,i,k,:),[imgdims,imgdims]);
                    [results.voxel(j,i,k).hessian.eigvec, results.voxel(j,i,k).hessian.eigval] = myeig(results.voxel(j,i,k).hessian.matrix);
                    results.As.image(j,i,k) = results.voxel(j,i,k).hessian.eigval(1) ...
                        - abs(results.voxel(j,i,k).hessian.eigval(2)) ...
                        - abs(results.voxel(j,i,k).hessian.eigval(3));
                end
            end
        end
        t = toc(tHessian3d);
        disp(['mshff: 3d: completed voxel-wise operations in ',num2str(t),' secs']);
    else
        error('mshff: unable to determine dimentions');
    end
    results.As.image(results.As.image <= 0) = 0;
    results.Bs.image = results.As.image / max(results.As.image(:));
    results.Cs.image(results.Bs.image > 1 - results.Cs.gamma) = 1; 
    
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
