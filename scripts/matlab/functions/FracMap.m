function result = FracMap(img,fracAperture,s,gamma)
hsizeOdd    = 19;
hsizeEven   = (hsizeOdd-1);
if mod(2*fracAperture,2) == 0
    hsize = hsizeEven;
else
    hsize = hsizeOdd;
end
result.s         = s;
result.aperture  = fracAperture;
result.hsize     = hsize;
result.voxel.description = 'result per voxel';
result.voxel.matrix             = cell(size(img));
result.voxel.EigVec             = cell(size(img));
result.voxel.EigValMatrix       = cell(size(img));
result.voxel.EigValSorted       = cell(size(img));
result.As.description = 'lambda_max - |lambada_mid| - |lambda_min|';
result.As.image = zeros(size(img));
result.Bs.description = 'normalized As';
result.Bs.image = result.As.image;
result.Cs.description = 'threshold binarization';
result.Cs.image = result.As.image;
result.Cs.gamma = gamma;


implementation = 2;
[result.voxel.matrix,~,~,~,~]   = ComputeHessian3D(img,implementation,hsize,s);

% looping over every voxel
for k = 1:size(img,3)
    for j = 1:size(img,1)
        for i = 1:size(img,2)
            %                         result.voxel.magnitude(j,i,m) = ComputeTensorMag(result.voxel.matrix{j,i,m}); % this quantity is not used yet
            [result.voxel.EigVec{j,i,k},result.voxel.EigValMatrix{j,i,k}] = eig(result.voxel.matrix{j,i,k});
            result.voxel.EigValSorted{j,i,k}                              = sortEigenValues(result.voxel.EigValMatrix{j,i,k});
            result.As.image(j,i,k)                             = real(result.voxel.EigValSorted{j,i,k}(3) - abs(result.voxel.EigValSorted{j,i,k}(2)) - abs(result.voxel.EigValSorted{j,i,k}(1)));
        end
    end
end
% filter elements < 0
result.As.image(result.As.image < 0) = 0;
% normalize
result.Bs.image = result.As.image ./ max(result.As.image(:));
% binarize
result.Cs.image = (result.Bs.image > (1 - result.Cs.gamma));
end