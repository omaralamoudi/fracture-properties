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
    
    hessianMatrix = cell(size(img));
    
    if (implementation == 1)
        [ddx, ddy, ddz]                 = gradient(img);
        [ddxddx, ddyddx, ddzddx]        = gradient(ddx);
        [ddxddy, ddyddy, ddzddy]        = gradient(ddy);
        [ddxddz, ddyddz, ddzddz]        = gradient(ddz); 
    elseif (implementation == 2)
        h = fspecial3('gaussian',hsize,sigma);
        [~,h_xx,h_xy,h_xz,h_yx,h_yy,h_yz,h_zx,h_zy,h_zz] = ComputeHessian3D(h);
        ddxddx = imfilter(img,h_xx,'conv','replicate');
        ddxddy = imfilter(img,h_xy,'conv','replicate');
        ddxddz = imfilter(img,h_xz,'conv','replicate');
        ddyddx = imfilter(img,h_yx,'conv','replicate');
        ddyddy = imfilter(img,h_yy,'conv','replicate');
        ddyddz = imfilter(img,h_yz,'conv','replicate');
        ddzddx = imfilter(img,h_zx,'conv','replicate');
        ddzddy = imfilter(img,h_zy,'conv','replicate');
        ddzddz = imfilter(img,h_zz,'conv','replicate');
    else
        error('an implementation has to be made');
        
    end
    % collecting the voxel wise valuse into a matrix
    for lay = 1:size(img,3)
            for row = 1:size(img,1)
                % loop along the x-direction first
                for col = 1:size(img,2)
                    hessianMatrix(row,col,lay) = {[ddxddx(row,col,lay),ddxddy(row,col,lay),ddxddz(row,col,lay);...
                                             ddyddx(row,col,lay),ddyddy(row,col,lay),ddyddz(row,col,lay);...
                                             ddzddx(row,col,lay),ddzddy(row,col,lay),ddzddz(row,col,lay)]};
                end
            end
    end
end