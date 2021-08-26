function result = mshff_prototype(img,s,gamma)
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
result.inputimage = img;
result.s = s;
result.hessian.description = 'an image that contains slices of one of the Hessian-component-filtered image';
result.hessian.image = zeros([size(img),imgdims.^2]);
result.As.description = 'lambda_3 - |lambada_2| - |lambda_1|';
result.As.image = zeros(size(img));
result.Bs.description = 'normalized As';
result.Bs.image = result.As.image;
result.Cs.description = 'threshold binarization';
result.Cs.image = result.As.image;
result.Cs.gamma = gamma;
result.voxel.description = 'result per voxel';
result.loxel.description = 'result per linear voxel';
t.kernels.init = tic;
disp('mshff: kernel computation started ...');
hessianKernels = getHessianKernels(s,imgdims);
t.kernels.end = toc(t.kernels.init);
disp(['mshff: kernel computation ended in ', num2str(t.kernels.end),' sec']);

disp('mshff: image filtering started ...');
t.filtering.init = tic;
% apply hessian component filters
for row = 1:hessianKernels.nslices
    if hessianKernels.dims == 2
        result.hessian.image(:,:,row) = imfilter(img,hessianKernels.slice{row},'conv','replicate');
    elseif hessianKernels.dims == 3
        result.hessian.image(:,:,:,row) = imfilter(img,hessianKernels.slice{row},'conv','replicate');
    else
        error('mshff: a problem with dimensions');
    end
end
t.filtering.end = toc(t.filtering.init);
disp(['mshff: image filtering ended in ', num2str(t.filtering.end),' sec']);

% collecting per voxel hessian results
% progress bar vvvv
wb = waitbar(0,'Please Wait ...');
pause(.1);
vox = 0;
nvox = numel(img);
% progress bar ^^^
if hessianKernels.dims == 2
    disp('mshff: 2d: started voxel wise operations');
    t.hessian.init = tic;
    for row = 1:size(img,1)
        for col = 1:size(img,2)
            result.voxel(row,col).hessian.matrix = reshape(result.hessian.image(row,col,:),[imgdims,imgdims]);
            [result.voxel(row,col).hessian.eigvec, result.voxel(row,col).hessian.eigval] = myeig(result.voxel(row,col).hessian.matrix);
            result.As.image(row,col) = result.voxel(row,col).hessian.eigval(1) ...
                - abs(result.voxel(row,col).hessian.eigval(2)) ...
                - abs(result.voxel(row,col).hessian.eigval(3));
            waitbar(vox/nvox,wb,['Collecting info from voxel (',num2str(vox),' of ',num2str(nvox),') completed']);
            vox = vox + 1;
        end
    end
    t.hessian.end = toc(t.hessian.init);
    disp(['mshff: 2d: completed voxel-wise operations in ',num2str(t.hessian.end),' sec']);
elseif hessianKernels.dims == 3
    disp('mshff: 3d: started voxel wise operations');
    t.hessian.init = tic;
    t.linindex.init = tic;
    % linear indexing
    for i = 1:numel(img)
        [row,col,lay] = ind2sub(size(img),i);
        result.loxel(i).hessian.matrix = reshape(result.hessian.image(row,col,lay,:),[imgdims,imgdims]);
        [result.loxel(i).hessian.eigvec, result.loxel(i).hessian.eigval] = myeig(result.loxel(i).hessian.matrix);
        result.As.image(i) = result.loxel(i).hessian.eigval(1) ...
            - abs(result.loxel(i).hessian.eigval(2)) ...
            - abs(result.loxel(i).hessian.eigval(3));
        if mod(vox,10) == 0, waitbar(vox/nvox,wb,{'Linear indexing',['Collecting info from voxel (',num2str(vox),' of ',num2str(nvox),') completed']});end
        vox = vox + 1;
    end
    vox = 0; % reset for wait bar
    t.linindex.end = toc(t.linindex.init);
    disp(['mshff: 3d: completed voxel-wise operations (linear indexing) in ',num2str(t.linindex.end),' secs']);
    % subscript indexing
    t.subindex.init = tic;
    for lay = 1:size(img,3) % along the z direction
        for row = 1:size(img,1) % along the y direction
            for col = 1:size(img,2) % along the x direction
                result.voxel(row,col,lay).hessian.matrix = reshape(result.hessian.image(row,col,lay,:),[imgdims,imgdims]);
                [result.voxel(row,col,lay).hessian.eigvec, result.voxel(row,col,lay).hessian.eigval] = myeig(result.voxel(row,col,lay).hessian.matrix);
                result.As.image(row,col,lay) = result.voxel(row,col,lay).hessian.eigval(1) ...
                    - abs(result.voxel(row,col,lay).hessian.eigval(2)) ...
                    - abs(result.voxel(row,col,lay).hessian.eigval(3));
                if mod(vox,10) == 0, waitbar(vox/nvox,wb,{'Subscript indexing',['Collecting info from voxel (',num2str(vox),' of ',num2str(nvox),') completed']});end
                vox = vox + 1;
            end
        end
    end
    t.subindex.end = toc(t.subindex.init);
    disp(['mshff: 3d: completed voxel-wise operations (subscript indexing) in ',num2str(t.subindex.end),' secs']);
    t.hessian.end = toc(t.hessian.init);
    disp(['mshff: 3d: completed voxel-wise operations in ',num2str(t.hessian.end),' secs']);
else
    error('mshff: unable to determine dimentions');
end
close(wb);
result.As.image(result.As.image < 0) = 0;
result.Bs.image = result.As.image / max(result.As.image(:));
result.Cs.image(result.Bs.image > 1 - result.Cs.gamma) = 1;
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
if det(eigvec) < 0
    % Right handedness: https://math.stackexchange.com/questions/537090/eigenvectors-for-the-equation-of-the-second-degree-and-right-hand-rule
    eigvec(:,end) = -eigvec(:,end);
end
end