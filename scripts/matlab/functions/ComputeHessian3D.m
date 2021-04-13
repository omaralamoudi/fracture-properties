function [hessianMatrix,ddxddx,ddxddy,ddxddz,ddyddx,ddyddy,ddyddz,ddzddx,ddzddy,ddzddz] = ComputeHessian3D(img,implementation,hsize,sigma)
    %COMPUTEHESSIAN2D Computes the hessian of each pixel within in image.
    %   if implementation == 1  : use the central difference
    %   if implementation == 2  : use convolution
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
        [ddx, ddy, ddz]                 = gradient(img);
        [ddxddx, ddyddx, ddzddx]        = gradient(ddx);
        [ddxddy, ddyddy, ddzddy]        = gradient(ddy);
        [ddxddz, ddyddz, ddzddz]        = gradient(ddz);
        
        hessianMatrix = cell(size(img));
        
        for k = 1:size(img,3)
            for j = 1:size(img,1)
                % loop along the x-direction first
                for i = 1:size(img,2)
                    hessianMatrix(j,i,k) = {[ddxddx(j,i,k),ddxddy(j,i,k),ddxddz(j,i,k);...
                                     ddyddx(j,i,k),ddyddy(j,i,k),ddyddz(j,i,k);...
                                     ddzddx(j,i,k),ddzddy(j,i,k),ddzddz(j,i,k)]};
                end
            end
        end
        
    elseif (implementation == 2)
        h = fspecial3('gaussian',hsize,sigma);
        [~,h_xx,h_xy,h_xz,h_yx,h_yy,h_yz,h_zx,h_zy,h_zz] = ComputeHessian3D(h);
        ddxddx = imfilter(img,h_xx,'replicate','conv');
        ddxddy = imfilter(img,h_xy,'replicate','conv');
        ddxddz = imfilter(img,h_xz,'replicate','conv');
        ddyddx = imfilter(img,h_yx,'replicate','conv');
        ddyddy = imfilter(img,h_yy,'replicate','conv');
        ddyddz = imfilter(img,h_yz,'replicate','conv');
        ddzddx = imfilter(img,h_zx,'replicate','conv');
        ddzddy = imfilter(img,h_zy,'replicate','conv');
        ddzddz = imfilter(img,h_zz,'replicate','conv');
        
        for k = 1:size(img,3)
            for j = 1:size(img,1)
                % loop along the x-direction first
                for i = 1:size(img,2)
                    hessianMatrix(j,i,k) = {[ddxddx(j,i,k),ddxddy(j,i,k),ddxddz(j,i,k);...
                        ddyddx(j,i,k),ddyddy(j,i,k),ddyddz(j,i,k);...
                        ddzddx(j,i,k),ddzddy(j,i,k),ddzddz(j,i,k)]};
                end
            end
        end
        
    else
        error('an implementation has to be made');
        
    end
    
end