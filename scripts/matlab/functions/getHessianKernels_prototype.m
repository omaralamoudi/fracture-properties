function hessianKernels = getHessianKernels_prototype(s,dims,m,implementation)
% GETHESSIANKERNELS_PROTOTYPE input s should be a vector of length 2 or 3, e.g. [sx sy ...] where sx is
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

if implementation == 1
    %% implementation 1
    kernel_multiplier = m;
    
    % amplitude
    A = 1;
    g  = @(x,B,A) (A * exp((-1/2)*((x)'*B*(x))));
    B  = getB(s);
    
    if dims == 2 % 2d
        coord = getCoordinates(s,kernel_multiplier,dims);
        [x,y] = meshgrid(coord.X,coord.Y);
        % initilizing H
        H = initH(x,dims);
        disp(['getHessianKernals_prototype 2d for s = [',num2str(s),']', ' kernal size = ' num2str([length(coord.X) length(coord.Y)])]);
        progressBar = TextProgressBar(['getHessianKernals_prototype 2d for s = [',num2str(s),']']);
        nVoxels         = H.n;
        completedVoxel  = 0;
        for col = 1:H.nx % loop over columns (x-direction)
            for row = 1:H.ny % loop over rows (y-direction)
                x_tmp = [x(row,col) y(row,col)]' - [coord.x0 coord.y0]';
                H.matrix{row,col} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B); % g is an annonymus function
                H.values(row,col,:) = reshape(H.matrix{row,col}, [1 1 dims.^2]);
                completedVoxel = completedVoxel + 1;
                if (mod(completedVoxel/nVoxels,0.01) == 0),progressBar.update(completedVoxel/nVoxels);end
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
        nVoxels         = H.n;
        completedVoxel  = 0;
        for lay = 1:H.nz
            for col = 1:H.nx % loop over columns (x-direction)
                for row = 1:H.ny % loop over rows (y-direction)
                    x_tmp = [x(row,col,lay) y(row,col,lay) z(row,col,lay)]' - [coord.x0 coord.y0 coord.z0]';
                    H.matrix{row,col,lay} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B);
                    H.values(row,col,lay,:) = reshape(H.matrix{row,col,lay}, [1 1 dims.^2]);
                    completedVoxel = completedVoxel + 1;
                    if (mod(completedVoxel/nVoxels,0.01) == 0),progressBar.update(completedVoxel/nVoxels);end
                end
            end
        end
        progressBar.complete();
    else
        error('getHessianKernels_prototype: physical dimension undetermined');
    end
elseif implementation == 2
    %% implementation 2
    kernel_multiplier = m;
    if dims == 2 % 2d
        error('not implemented yet'); 
    elseif dims == 3 % 3d
        coord = getCoordinates(s,kernel_multiplier,dims);
        h = fspecial3('gaussian',[length(coord.Y), length(coord.X), length(coord.Z)],s);
        
        % initilizing H
        H = initH(h,dims);
        % H.matrix might be transposed, but since H is symmetric, this
        % might not be an issue
        [H.matrix,H.component{1},H.component{4},H.component{7},H.component{2},H.component{5},H.component{8},H.component{3},H.component{6},H.component{9}] = ComputeHessian3D(h);
        disp(['getHessianKernals_prototype 3d for s = [',num2str(s),']', ' kernal size = ' num2str([length(coord.X) length(coord.Y) length(coord.Z)])]);
        progressBar = TextProgressBar(['getHessianKernals_prototype 3d for s = [',num2str(s),']']);
        nVoxels         = H.n;
        completedVoxel  = 0;
        for lay = 1:H.nz
            for col = 1:H.nx % loop over columns (x-direction)
                for row = 1:H.ny % loop over rows (y-direction)
                    % transposing the matrix in the following line to match
                    % implementation 1
                    H.matrix{row,col,lay}   = H.matrix{row,col,lay}';
                    H.values(row,col,lay,:) = reshape(H.matrix{row,col,lay}, [1 1 dims.^2]);
                    completedVoxel = completedVoxel + 1;
                    if (mod(completedVoxel/nVoxels,0.01) == 0),progressBar.update(completedVoxel/nVoxels);end
                end
            end
        end
        progressBar.complete();
    else
        error('getHessianKernels_prototype: physical dimension undetermined');
    end
else
    error('getHessianKernels_prototype: implementation undefined undetermined');
end

for i = 1:H.component_count
    if H.dims == 2
        H.component{i}      = H.values(:,:,i);
        H.component_sum(i)  = sum(H.component{i}(:));
        H.component_min(i)  = min(H.component{i}(:));
        H.component_max(i)  = max(H.component{i}(:));
        H.component_norm{i} = H.component{i} / H.component_max(i);
    elseif H.dims == 3
        H.component{i}      = H.values(:,:,:,i);
        H.component_sum(i)  = sum(H.component{i}(:));
        H.component_min(i)  = min(H.component{i}(:));
        H.component_max(i)  = max(H.component{i}(:));
        H.component_norm{i} = H.component{i} / H.component_max(i);
    else
        error('getHessianKernels_prototype: issue with determining slices');
    end
end

hessianKernels = H;
end

%% helper functions
function H = initH(x,dims)
H.dims              = dims;
H.values            = zeros([size(x) dims.^2]); % dims .^2 is the number of layers to capture all hessian tensor values
H.gaussian          = zeros(size(x));           % the original gaussian used in the rest of the calculations
H.component_count   = H.dims^2;
H.component         = cell(H.component_count,1);
H.component_norm    = cell(H.component_count,1);
H.component_sum     = zeros(H.component_count,1);
H.component_min     = zeros(H.component_count,1);
H.component_max     = zeros(H.component_count,1);
if dims == 2
    H.component_order = reshape({'xx','yx','xy','yy'}, [dims.^2 1]);
    H.nx = size(x,2);
    H.ny = size(x,1);
    H.n = H.nx * H.ny;
elseif dims == 3
    H.component_order = reshape({'xx','yx','zx','xy','yy','zy','xz','yz','zz'}, [dims.^2 1]);
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