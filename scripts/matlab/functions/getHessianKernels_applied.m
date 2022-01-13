% generate kernals for Hessian filtering
close all 

sx = 3;
sy = 5;
sz = 9;
s  = [sx, sy, sz];
s = [3 3 3];
% s  = [sx, sy];
kernel_multiplier = 9;
kernels = getHessianKernels(s);

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
    linkaxes(ax);
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