function hessianKernels = getHessianKernels_prototype(s,dims,m,implementation)
% GEThESSIANKERNELS_PROTOTYPE input s should be a vector of length 2 or 3, e.g. [sx sy ...] where sx is
% the kernal number of voxels in the x
%                              direction, sy is the kernel number of voxels
%                              in the y direction ets.

if nargin < 2
    if isvector(s)
        if length(s) > 1 && length(s) < 4
            dims = length(s);  % physiscal dimentions
        else
            error('getHessianKernels_prototype: length of s must be either 2 or 3');
            return;
        end
    else
        error('getHessianKernels_prototype: dims must be specified');
        return;
    end
    m = 9;
    implementation = 1;
elseif nargin < 3
    if isscalar(s)
        s = ones(dims,1)*s;
    end
    m = 9;
    implementation = 1;
elseif nargin < 4
    implementation = 1;
end

kernel_multiplier = m;

g  = @(x,B) (exp((-1/2)*((x)'*B*(x))));
B  = getB(s);

if dims == 2 % 2d
    coord = getCoordinates(s,kernel_multiplier,dims);
    [x,y] = meshgrid(coord.X,coord.Y);
    % initilizing H
    H = initH(x,dims);
    disp(['getHessianKernals_prototype 2d for s = [',num2str(s),']', ' kernal size = ' num2str([length(coord.X) length(coord.Y)])]);
    progressBar = TextProgressBar(['getHessianKernals_prototype 2d for s = [',num2str(s),']']);
    total = H.n;
    counter  = 0;
    for j = 1:H.nx % loop over columns (x-direction)
        for i = 1:H.ny % loop over rows (y-direction)
            x_tmp = [x(i,j) y(i,j)]' - [coord.x0 coord.y0]';
            H.matrix{i,j} = 2*g(x_tmp,B)*((2*(B*x_tmp)*(B*x_tmp)')-B); % g is an annonymus function
            H.values(i,j,:) = reshape(H.matrix{i,j}, [1 1 dims.^2]);
            counter = counter + 1;
            if (mod(counter/total,0.01) == 0),progressBar.update(counter/total);end
        end
    end
    progressBar.complete();
elseif dims == 3 % 3d
    coord = getCoordinates(s,kernel_multiplier,dims);
    [x,y,z] = meshgrid(coord.X,coord.Y,coord.Z);
    % initilizing H
    H = initH(x,dims);
    disp(['getHessianKernals_prototype 3d for s = [',num2str(s),']', ' kernal size = ' num2str([length(coord.X) length(coord.Y) length(coord.Z)])]);
    progressBar = TextProgressBar(['getHessianKernals_prototype 3d for s = [',num2str(s),']']);
    total       = H.n;
    counter     = 0;
    for k = 1:H.nz
        for j = 1:H.nx % loop over columns (x-direction)
            for i = 1:H.ny % loop over rows (y-direction)
                x_tmp = [x(i,j,k) y(i,j,k) z(i,j,k)]' - [coord.x0 coord.y0 coord.z0]';
                H.matrix{i,j,k} = 2*g(x_tmp,B)*((2*(B*x_tmp)*(B*x_tmp)')-B);
                H.values(i,j,k,:) = reshape(H.matrix{i,j,k}, [1 1 dims.^2]);
                counter = counter + 1;
                if (mod(counter/total,0.01) == 0),progressBar.update(counter/total);end
            end
        end
    end
    progressBar.complete();
else
    error('getHessianKernels_prototype: physical dimension undetermined');
end

for i = 1:H.nslices
    if H.dims == 2
        H.slice{i} = H.values(:,:,i);
    elseif H.dims == 3
        H.slice{i} = H.values(:,:,:,i);
    else
        error('getHessianKernels_prototype: issue with determining slices');
    end
end
H.min = min(H.values(:));
H.max = max(H.values(:));
hessianKernels = H;
end

%% helper functions
function H = initH(x,dims)
H.dims      = dims;
H.values    = zeros([size(x) dims.^2]); % dims .^2 is the number of layers to capture all hessian tensor values
H.nslices   = H.dims^2;
H.slice     = cell(H.nslices,1);
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
    error('getHessianKernels_prototype::initH: number of physical dimentions is undetermined');
end
end

function x = insure_odd_length(x)
% Insures the length of the kernal edge is odd
if mod(length(x),2) == 0
    x = [x,x(end)+1];
end
end

function B = getB(s)
sdim = length(s);
if (sdim == 2) || (sdim == 3)  % 2d and 3d
    B = diag(1./s.^2);
else
    error('getHessianKernels_prototype::getB: something is wrong in fidning B');
end
end

function coord = getCoordinates(s,m,dims)
% This function provides the coordinates used in calculating the Hessian
% kernels
% defining an anonym function that find the middle point of the
find_middle_point_position = @(x) x(ceil(length(x)/2));
X = 0:1:s(1)*m;
% coord.X = 0:1:2*ceil(2*s(1))+1; % similar to using fspecial3('gaussian',[],sigma)
% coord.X = 1:1:19; % the original not adaptive way of doing
coord.X = insure_odd_length(X);
coord.x0= find_middle_point_position(coord.X);
Y = 0:1:s(2)*m;
% coord.Y = 0:1:2*ceil(2*s(2))+1; % similar to using fspecial3('gaussian',[],sigma)
% coord.Y = 1:1:19;
coord.Y = insure_odd_length(Y);
coord.y0= find_middle_point_position(coord.Y);
if dims == 3
    Z = 0:1:s(3)*m;
    %     Z = 0:1:2*ceil(2*s(3))+1; % similar to using fspecial3('gaussian',[],sigma)
    %     Z = 1:1:19;
    coord.Z = insure_odd_length(Z);
    coord.z0= find_middle_point_position(coord.Z);
else
end
end