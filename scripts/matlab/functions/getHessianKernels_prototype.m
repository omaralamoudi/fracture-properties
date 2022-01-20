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

% amplitude
A = 1;

g  = @(x,B,A) (A * exp((-1/2)*((x)'*B*(x))));
B  = getB(s);

X = 0:1:s(1)*kernel_multiplier;
% X = 0:1:2*ceil(2*s(1))+1; % similar to using fspecial3('gaussian',[],sigma)
% X = 1:1:19; % the original not adaptive way of doing 
X = insure_odd_length(X);
x0= find_middle_point_position(X);
Y = 0:1:s(2)*kernel_multiplier;
% Y = 0:1:2*ceil(2*s(2))+1; % similar to using fspecial3('gaussian',[],sigma)
% Y = 1:1:19;
Y = insure_odd_length(Y);
y0= find_middle_point_position(Y);

if dims == 2 % 2d
    [x,y] = meshgrid(X,Y);
    % initilizing H
    H = initH(x,dims);
    disp(['getHessianKernals_prototype 2d for s = [',num2str(s),']', ' kernal size = ' num2str([length(X) length(Y)])]);
    progressBar = TextProgressBar(['getHessianKernals_prototype 2d for s = [',num2str(s),']']);
    total = H.n;
    counter  = 0;
    for j = 1:H.nx % loop over columns (x-direction)
        for i = 1:H.ny % loop over rows (y-direction)
            x_tmp = [x(i,j) y(i,j)]' - [x0 y0]';
            H.matrix{i,j} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B); % g is an annonymus function
            H.values(i,j,:) = reshape(H.matrix{i,j}, [1 1 dims.^2]);
            counter = counter + 1;
            if (mod(counter/total,0.01) == 0),progressBar.update(counter/total);end
        end
    end
    progressBar.complete();
elseif dims == 3 % 3d
    Z = 0:1:s(3)*kernel_multiplier;
%     Z = 0:1:2*ceil(2*s(3))+1; % similar to using fspecial3('gaussian',[],sigma)
%     Z = 1:1:19;
    Z = insure_odd_length(Z);
    z0= find_middle_point_position(Z);
    [x,y,z] = meshgrid(X,Y,Z);
    % initilizing H
    H = initH(x,dims);
    disp(['getHessianKernals_prototype 3d for s = [',num2str(s),']', ' kernal size = ' num2str([length(X) length(Y) length(Z)])]);
    progressBar = TextProgressBar(['getHessianKernals_prototype 3d for s = [',num2str(s),']']);
    total       = H.n;
    counter     = 0;
    for k = 1:H.nz
        for j = 1:H.nx % loop over columns (x-direction)
            for i = 1:H.ny % loop over rows (y-direction)
                x_tmp = [x(i,j,k) y(i,j,k) z(i,j,k)]' - [x0 y0 z0]';
                H.matrix{i,j,k} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B);
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
H.nslices = H.dims^2;
H.slice = cell(H.nslices,1);
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

function H = initH(x,dims)
H.dims = dims;
H.values = zeros([size(x) dims.^2]); % dims .^2 is the number of layers to capture all hessian tensor values
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