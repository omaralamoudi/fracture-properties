function hessianKernels = getHessianKernels(s,m)
% input s should be either: 1) vector of max size 3 [sx sy ...] where sx is
%                              the kernal number of voxels in the x 
%                              direction.

% defining an anonym function that find the middle point of the
find_middle_point_position = @(x) x(ceil(length(x)/2));

if (nargin < 2), m = 9; end
kernel_multiplier = m;

% amplitude
A = 1;

if isvector(s)
    sdim = length(s); % physiscal dimentions
    
    g  = @(x,B,A) (A * exp((-1/2)*((x)'*B*(x))));
    B  = getB(s);
    
    X = 0:1:s(1)*kernel_multiplier;
    X = insure_odd_length(X);
    x0= find_middle_point_position(X);
    Y = 0:1:s(2)*kernel_multiplier;
    Y = insure_odd_length(Y);
    y0= find_middle_point_position(Y);
    
    if sdim == 2 % 2d
        disp('get_hessian_kernels: 2d');
        [x,y] = meshgrid(X,Y);
        % initilizing H
        H = initH(x,sdim);
        for j = 1:H.nx % loop over columns (x-direction)
            for i = 1:H.ny % loop over rows (y-direction)
                x_tmp = [x(i,j) y(i,j)]' - [x0 y0]';
                H.matrix{i,j} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B); % g is an annonymus function
                H.values(i,j,:) = reshape(H.matrix{i,j}, [1 1 sdim.^2]);
            end
        end     
    elseif sdim == 3 % 3d
        disp('get_hessian_kernels: 3d');
        Z = 0:1:s(3)*kernel_multiplier;
        Z = insure_odd_length(Z);
        z0= find_middle_point_position(Z);
        [x,y,z] = meshgrid(X,Y,Z);
        % initilizing H
        H = initH(x,sdim);
        for k = 1:H.nz
            for j = 1:H.nx % loop over columns (x-direction)
                for i = 1:H.ny % loop over rows (y-direction)
                    x_tmp = [x(i,j,k) y(i,j,k) z(i,j,k)]' - [x0 y0 z0]';
                    H.matrix{i,j,k} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B);
                    H.values(i,j,k,:) = reshape(H.matrix{i,j,k}, [1 1 sdim.^2]);
                end
            end
        end
    else
        error('get_hessian_kernels: physical dimension undetermined');
    end
    H.min = min(H.values(:));
    H.max = max(H.values(:));
    hessianKernels = H;
else % isvector
    error('get_hessian_kernels: s must be a vector');
end % isvector(s)
    
end

function H = initH(x,dims)
H.dims = dims;
H.values = zeros([size(x) dims.^2]);
    if dims == 2 
        H.component_order = reshape({'xx','yx','xy','yy'}, [1 1 dims.^2]);
        H.nx = size(x,2);
        H.ny = size(x,1);
        H.n = H.nx * H.ny;
    elseif dims == 3
        H.component_order = reshape({'xx','yx','zx','xy','yy','zy','xz','yz','zz'}, [1 1 dims.^2]);
        H.nx = size(x,2);
        H.ny = size(x,1);
        H.nz = size(x,3);
        H.n = H.nx * H.ny * H.nz;
    else
        error('initH: something is wrong');
    end
end

function x = insure_odd_length(x)
% Insures the length of the kernal edge is odd
if mod(length(x),2) == 0
    x = [x,x(end)+1];
end
end

function B = getB(s)
if isvector(s)
    ssize = size(s);
    if (ssize(2) == 2) || (ssize(2) == 3)  % 2d and 3d
        B = diag(1./s.^2);
    else
        error('getB: something is wrong if fidning B');
    end
else
    error('getB: not impelemtend yet');
end
end