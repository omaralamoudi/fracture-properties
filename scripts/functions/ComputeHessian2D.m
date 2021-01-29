function [hessian,ddxddx,ddxddy,ddyddx,ddyddy] = ComputeHessian2D(img,implementation,hsize,sigma)
%COMPUTEHESSIAN2D Computes the hessian of each pixel within in image.
% if implementation == 1  : use the central difference
% if implementation == 2  : use convolution
% INPUTS:
% img: input image
% implementation: either 1 or 2. 1 --> centerl difference Hessian
% implementation to compute the derivatives. 2 --> Computing the
% hessian of an image by filtering the image by convolving with a
% hessian componenets with the image, i.e. img_xx = A G_xx * img, where
% A is a scaling factor, G_xx is the xx componenet of the hessian of a
% Gausian with input parameters as following
% hsize: the discrete number of pixels in the x and y direction to
% compute the 2D Gaussian.
% sigma: the 'standard deviation' of the Gaussian. SEE
% fspecial('gaussian',hsize,sigma);
img = double(img);
if nargin < 2
    implementation = 1;
end

if (implementation == 1)
    
    tic
    [ddx, ddy]            = gradient(img);
    [ddxddx, ddyddx]      = gradient(ddx);
    [ddxddy, ddyddy]      = gradient(ddy);
    
    hessian = cell(size(img));
    for j = 1:size(img,1)
        % loop along the x-direction first
        for i = 1:size(img,2)
            hessian(j,i) = {[ddxddx(j,i),ddxddy(j,i); ddyddx(j,i),ddyddy(j,i)]};
        end
    end
    toc
    
elseif (implementation == 2)
    h = fspecial('gaussian',hsize,sigma);
    [~,h_xx,h_xy,h_yx,h_yy] = ComputeHessian2D(h);
    ddxddx = imfilter(img,h_xx,'replicate','conv');
    ddxddy = imfilter(img,h_xy,'replicate','conv');
    ddyddx = imfilter(img,h_yx,'replicate','conv');
    ddyddy = imfilter(img,h_yy,'replicate','conv');
    
    for j = 1:size(img,1)
        % loop along the x-direction first
        for i = 1:size(img,2)
            hessian(j,i) = {[ddxddx(j,i),ddxddy(j,i); ddyddx(j,i),ddyddy(j,i)]};
        end
    end
    
else
    error('an implementation has to be made');
    
end

end