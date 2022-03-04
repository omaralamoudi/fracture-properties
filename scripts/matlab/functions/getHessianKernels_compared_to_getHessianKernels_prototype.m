%% Comparing getHessianKernal and its prototype to test features.
% Here, we display and compare the results of using two different versions
% of getHessianKernals. The reason is to observe the difference in results
% when using these two versions in order to decide to change the original
% implementation or not. 
% I would like to note that mshff_prototype as of right now, uses the
% getHessianKernal_prototype. Othe 
% - [x] removed the  
close all; clearvars;

sx = 3;
sy = 5;
sz = 9;
% s  = [sx, sy, sz];
% s = [3 3 3];
s  = [sx, sy];
kernel_multiplier = 9;
k = getHessianKernels(s);
kp = getHessianKernels_prototype(s);

linkedAxes3dO = plotKernels(k,'original');
linkedAxes3dP = plotKernels(kp,'protytpe');

function linkedAxes3d = plotKernels(kernels,supertitle)
if nargin < 2
    supertitle = '';
end
screenSize = get(0,'ScreenSize');
clims = [min(kernels.values(:)) max(kernels.values(:))]*.5;
if kernels.dims == 2
    fig = figure('Name','2D example','Position',[screenSize(3)*.05 screenSize(4)*.05 screenSize(3)*.50 screenSize(4)*.85]); %#ok<NASGU>
    t = tiledlayout(kernels.dims,kernels.dims);
    t.TileSpacing   = 'compact';
    t.Padding       = 'compact';
    ax = gobjects(kernels.dims^2,1); % initializing graphics object
    c  = gobjects(kernels.dims^2,1); % initializing graphics object
    for i = 1:kernels.dims^2
        ax(i) = nexttile;
%         clims = [kernels(i).min kernels.max]*.5; % this is incorrect
        imagesc(kernels.values(:,:,i),clims);
        ax(i).XTick = (1:size(kernels.values(:,:,i),2)+1)-1/2;
        ax(i).XTickLabel = {};
        ax(i).YTick = (1:size(kernels.values(:,:,i),1)+1)-1/2;
        ax(i).YTickLabel = {};
        ax(i).TickDir = 'out';
        ax(i).Title.String = kernels.component_order{i};
        ax(i).Title.FontSize = 20;
        grid on, axis equal tight
        c(i) = colorbar;
        c(i).Location = 'southoutside';
    end
    linkaxes(ax);
    linkedAxes3d = gobjects();
    if ~strcmp(supertitle,'') 
        txt = sgtitle(supertitle);
        txt.Interpreter = 'latex';
    end
elseif kernels.dims == 3
    % 2D slice
    fig3 = figure('Position',[screenSize(3)*.05 screenSize(4)*.05 screenSize(3)*.50 screenSize(4)*.85]); %#ok<NASGU>
    t = tiledlayout(kernels.dims,kernels.dims);
    t.TileSpacing   = 'compact';
    t.Padding       = 'compact';
    axSlices = gobjects(kernels.dims^2,1); % initializing graphics object
    c  = gobjects(kernels.dims^2,1); % initializing graphics object
    for i = 1:kernels.dims^2
        axSlices(i) = nexttile;
        zslice = ceil(kernels.nz/3);
        imagesc(kernels.values(:,:,zslice,i),clims); hold on
        axSlices(i).XTick = (1:size(kernels.values(:,:,i),2)+1)-1/2;
        axSlices(i).XTickLabel = {};
        axSlices(i).YTick = (1:size(kernels.values(:,:,i),1)+1)-1/2;
        axSlices(i).YTickLabel = {};
        axSlices(i).TickDir = 'out';
        axSlices(i).Title.String = kernels.component_order{i};
        axSlices(i).Title.FontSize = 20;
        grid on, axis equal tight
        c(i) = colorbar;
        c(i).Location = 'southoutside';
    end
    linkaxes(axSlices);
    if ~strcmp(supertitle,'') 
        txt = sgtitle(supertitle);
        txt.Interpreter = 'latex';
    end
    % 3d shapes
    fig2 = figure('Position',[screenSize(3)*.05 screenSize(4)*.05 screenSize(3)*.50 screenSize(4)*.85]); %#ok<NASGU>
    t = tiledlayout(kernels.dims,kernels.dims);
    t.TileSpacing   = 'compact';
    t.Padding       = 'compact';
    ax3d = gobjects(kernels.dims^2,1); % initializing graphics object
    val = mean([min(kernels.values(:)) max(kernels.values(:))])*1.25; % mean value
    for i = 1:kernels.dims^2
        ax3d(i) = nexttile;
%         val = mean([kernels.min kernels.max]); % mean value
        p = patch(isosurface(kernels.values(:,:,:,i),val));
        p.FaceColor = 'blue';
        p.FaceAlpha = .3;
        p.EdgeColor = 'none';
        daspect([1 1 1])
        light
        lighting gouraud
        hold on
        xslice = ceil(kernels.nx * (1/2));
        yslice = ceil(kernels.ny * (1/2));
        zslice = ceil(kernels.nz * (1/2));
        sslice = slice(kernels.values(:,:,:,i),xslice,yslice,zslice);
        set(sslice,'FaceAlpha',1,'FaceColor','flat','EdgeAlpha',0);
        sslice(end).FaceAlpha = 1;
        xlabel('x'); ylabel('y'); zlabel('z');
        ax3d(i).XLim = [1 kernels.nx];
        ax3d(i).XTick = (1:size(kernels.values(:,:,i),2)+1)-1/2;
        ax3d(i).XTickLabel = {};
        ax3d(i).YLim = [1 kernels.ny];
        ax3d(i).YTick = (1:size(kernels.values(:,:,i),1)+1)-1/2;
        ax3d(i).YTickLabel = {};
        ax3d(i).TickDir = 'out';
        ax3d(i).Title.String = kernels.component_order{i};
        ax3d(i).Title.FontSize = 20;
        c(i) = colorbar;
        c(i).Location = 'southoutside';
        caxis(ax3d(i),clims);
        %         grid on, axis equal tight
        %         c(i) = colorbar;
        %         c(i).Location = 'southoutside';
        %     ax(i).GridAlpha = 0;
        axis equal tight
    end
    linkedAxes3d = linkprop(ax3d,'View'); % I need the handle to the linked properties for this to work as expected. See: https://www.mathworks.com/matlabcentral/answers/408254-linkprop-not-persisting-after-changing-scope
    if ~strcmp(supertitle,'') 
        txt = sgtitle(supertitle);
        txt.Interpreter = 'latex';
    end
    rotate3d on
end
end