% generate kernals for Hessian filtering
close all 

sx = 3;
sy = 5;
sz = 9;
s  = [sx, sy, sz];
kernel_multiplier = 9;
kernels = get_kernels(s,kernel_multiplier);

% clim = max(abs([kernels.min kernels.max]));
% clims = clim*[-1 1]*.8;
clims = [kernels.min kernels.max]*.5;
if kernels.dims == 2
    fig = figure('Name','2D example','Position',[550 1050 575 585]);
    t = tiledlayout(kernels.dims,kernels.dims);
    t.TileSpacing   = 'compact';
    t.Padding       = 'compact';
    for i = 1:kernels.dims^2
        ax(i) = nexttile;
        imagesc(kernels.values(:,:,i),clims);
        ax(i).XTick = [1:size(kernels.values(:,:,i),2)+1]-1/2;
        ax(i).XTickLabel = {};
        ax(i).YTick = [1:size(kernels.values(:,:,i),1)+1]-1/2;
        ax(i).YTickLabel = {};
        ax(i).TickDir = 'out';
        ax(i).Title.String = kernels.component_order{i};
        ax(i).Title.FontSize = 20; 
        grid on, axis equal tight
        c(i) = colorbar;
        c(i).Location = 'southoutside';
    %     ax(i).GridAlpha = 0;
    end
    linkaxes(ax)
elseif kernels.dims == 3
    fig3 = figure('Position',[605 1201 510 1186]);
    t = tiledlayout(kernels.dims,kernels.dims);
    t.TileSpacing   = 'compact';
    t.Padding       = 'compact';
    val = mean([kernels.min kernels.max])*1.25; % mean value
    for i = 1:kernels.dims^2
        ax(i) = nexttile;
        zslice = ceil(kernels.nz/3);
        imagesc(kernels.values(:,:,zslice,i),clims); hold on
        ax(i).XTick = [1:size(kernels.values(:,:,i),2)+1]-1/2;
        ax(i).XTickLabel = {};
        ax(i).YTick = [1:size(kernels.values(:,:,i),1)+1]-1/2;
        ax(i).YTickLabel = {};
        ax(i).TickDir = 'out';
        ax(i).Title.String = kernels.component_order{i};
        ax(i).Title.FontSize = 20; 
        grid on, axis equal tight
        c(i) = colorbar;
        c(i).Location = 'southoutside';
    %     ax(i).GridAlpha = 0;
    end
    linkaxes(ax);
    
    fig2 = figure('Position',[44 1201 510 1186]);
    t = tiledlayout(kernels.dims,kernels.dims);
    t.TileSpacing   = 'compact';
    t.Padding       = 'compact';
    for i = 1:kernels.dims^2
        ax(i) = nexttile;
        val = mean([kernels.min kernels.max]); % mean value
        p = patch(isosurface(kernels.values(:,:,:,i),val));
        p.FaceColor = 'blue';
        p.FaceAlpha = .3;
        p.EdgeColor = 'none';
        daspect([1 1 1])
        light 
        lighting gouraud
        hold on
        xslice = ceil(kernels.nx * [1/2]);
        yslice = ceil(kernels.ny * [1/2]);
        zslice = ceil(kernels.nz * [1/2]);
        sslice = slice(kernels.values(:,:,:,i),xslice,yslice,zslice);
        set(sslice,'FaceAlpha',1,'FaceColor','flat','EdgeAlpha',0);
        sslice(end).FaceAlpha = 1;
        xlabel('x'); ylabel('y'); zlabel('z');
        ax(i).XLim = [1 kernels.nx];
        ax(i).XTick = [1:size(kernels.values(:,:,i),2)+1]-1/2;
        ax(i).XTickLabel = {};
        ax(i).YLim = [1 kernels.ny];
        ax(i).YTick = [1:size(kernels.values(:,:,i),1)+1]-1/2;
        ax(i).YTickLabel = {};
        ax(i).TickDir = 'out';
        ax(i).Title.String = kernels.component_order{i};
        ax(i).Title.FontSize = 20;
        c(i) = colorbar;
        c(i).Location = 'southoutside';
        caxis(ax(i),clims);
%         grid on, axis equal tight
%         c(i) = colorbar;
%         c(i).Location = 'southoutside';
    %     ax(i).GridAlpha = 0;
        axis equal tight
    end
    linkprop(ax,'View');
    rotate3d on
end
function kernels = get_kernels(s,m)
% input s should be either: 1) vector of max size 3 [sx sy ...] where sx is
%                              the kernal number of voxels in the x 
%                              direction.
%                           2) and array of vectors [sx1 sx2 sx3 ...;
%                                                    sy1 sy2 sy3 ...;
%                                                    sz1 sz2 sz3 ...];
%

% defining an anonym function that I will use below
find_center_position = @(x) x(ceil(length(x)/2));


if nargin < 2, m = 9; end
kernel_multiplier = m;

% amplitude
A = 1;

if isvector(s)
    ssize = size(s);
    g  = @(x,B,A) (A * exp((-1/2)*((x)'*B*(x))));
    B  = getB(s);
    
    dims = ssize(2); % physiscal dimentions
    X = 0:1:s(1)*kernel_multiplier;
    X = insure_odd_length(X);
    x0= find_center_position(X);
    Y = 0:1:s(2)*kernel_multiplier;
    Y = insure_odd_length(Y);
    y0= find_center_position(Y);
    
    if ssize(2) == 2 % 2d
        [x,y] = meshgrid(X,Y);
        % initilizing H
        H = initH(x,dims);
        for j = 1:H.nx % loop over columns (x-direction)
            for i = 1:H.ny % loop over rows (y-direction)
                x_tmp = [x(i,j) y(i,j)]' - [x0 y0]';
                H.matrix{i,j} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B); % g is an annonymus function
                H.values(i,j,:) = reshape(H.matrix{i,j}, [1 1 dims.^2]);
            end
        end     
    elseif ssize(2) == 3 % 3d
        Z = 0:1:s(3)*kernel_multiplier;
        Z = insure_odd_length(Z);
        z0= find_center_position(Z);
        [x,y,z] = meshgrid(X,Y,Z);
        % initilizing H
        H = initH(x,dims);
        for k = 1:H.nz
            for j = 1:H.nx % loop over columns (x-direction)
                for i = 1:H.ny % loop over rows (y-direction)
                    x_tmp = [x(i,j,k) y(i,j,k) z(i,j,k)]' - [x0 y0 z0]';
                    H.matrix{i,j,k} = 2*g(x_tmp,B,A)*((2*(B*x_tmp)*(B*x_tmp)')-B);
                    H.values(i,j,k,:) = reshape(H.matrix{i,j,k}, [1 1 dims.^2]);
                end
            end
        end
    else
        error('something is wrong');
    end
    H.min = min(H.values(:));
    H.max = max(H.values(:));
    kernels = H;
else % isvector
    error('get_kernal: not impelemtend yet');
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