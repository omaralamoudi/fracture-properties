%% Analysis regarding the range of apertures possible for each filter size
clear variables; clc;

cm = InitColormaps();
% cm = cm_viridis;
dcm = 8;

dx = 1;
dy = 1;

hSizeRange = 3:2:25;
sRange = 0.01:0.01:5;
testParam = zeros(length(hSizeRange)*length(sRange),6); 
i = 1;

tol = 1e-4; 
for hSize = hSizeRange
    count = 0;
    for s = sRange
        testParam(i,1) = hSize;
        testParam(i,2) = s;
        % s = 0.22;
        x = linspace(1,hSize*dx,hSize);
        y = linspace(1,hSize*dy,hSize);
        
        h = fspecial('gaussian',hSize,s);
        maxAmp = max(max(h));
        testParam(i,3) = maxAmp;
        %h = h/(dx*dy);
        VolumeUnderSurface = trapz(y,trapz(x,h,2));
        testParam(i,4) = VolumeUnderSurface;
        
        cond1(i) = (abs(VolumeUnderSurface) >= 1 - tol ) && (abs(VolumeUnderSurface) <= 1 + tol );
        cond2(i) = (maxAmp < 1 );
        cond(i) =  cond1(i) && cond2(i); % the condition is that the volume has to be around 1, and the max value of the Gaussian is just below 1. 
        testParam(i,5) = cond(i);
        
        % The sequential count of possible aperture measurements 
        if(cond(i)); count = count + cond(i); else count = 0; end
        testParam(i,6) = count;
        
        %{
        figure
        %m = surf(h/max(max(h)));
        m = surf(h);
        xticks([1:hSizeTest]);
        yticks([1:hSizeTest]);
        m.FaceColor = 'none';
        m.Marker = 'o';
        m.MarkerSize = 4;
        m.MarkerFaceColor = 'flat';
        colormap(cm);
        axis tight;
        axis equal;
        c = colorbar;
        ax = gca;
        %}
        i = i + 1; 
    end
end
result = testParam(logical(testParam(:,5)),:);
%
close all;

c = 1;
for hSize = hSizeRange
    condd = result(:,1) == hSize;
    plot(result(condd,2),result(condd,1),'Color',cm(c*dcm,:)); hold on;
    c = c + 1;
end

% axis tight;
ax = gca;
ax.YTick = hSizeRange;
ylim([min(hSizeRange)-1 max(hSizeRange)+1]);
ylabel('h size');
xlabel('s range'); 
% axis tight;
grid on; 

%% plotting the optimized dataset (Another way to visialize the above)
figure('Position',[100 0 800 1000]);
subplot(4,1,1);
plot(result(:,1));
yticks(hSizeRange);
grid on;
axis tight;
title('N nodes on each edge (h)'); 


subplot(4,1,2);
plot(result(:,2))
title('$\sigma$'); 
subplot(4,1,3); 
plot(result(:,3));
title('Max hight'); 
subplot(4,1,4);
plot(result(:,4));
ylim([1-tol 1]);
title('Volume Under Surface'); 

%%
c = 1;
cm = cm_viridis;
directory = 'C:\Users\oma385\Dropbox\GraduateSchool\PhD\CourseWork\Spring2019\3DAnalysisOfVolumetricData\Project\Presentation\figures\';
hSizeRange = 3:2:25;
sRange = [0.1:0.2:0.9,1:5];
for hSize = hSizeRange
    X = 1:hSize;
    Y = 1:hSize;
    [x,y] = meshgrid(X,Y);
    for s = 5
        h = fspecial('gaussian',hSize,s);
        [~,h_xx,~,~,~] = ComputeHessian2D(h);
        % normFactor = max(max(h));
        normFactor = 1;
        figure('Position',[100 100 1200 800]);
        subplot(2,2,1);
        h_norm = h/(max(max(h)));
        %z1 = h;
        z1 = h_norm;
        m = surf(x,y,z1); hold on
        ax = gca;
        xlabel('X-direction');
        ylabel('Y-direction');
        title('2D Gassian Filter $g(x,y)$');
        xticks([1:hSize]);
        ax.XTickLabel = -floor(hSize/2):floor(hSize/2);
        yticks([1:hSize]);
        ax.YTickLabel = ax.XTickLabel;
        m.FaceColor = 'none';
        m.Marker = 'o';
        m.MarkerSize = 4;
        m.MarkerFaceColor = 'flat';
        colormap(cm);
        axis tight;
        axis equal;
        colorbar;
        
        subplot(2,2,2);
        h_xx_norm = h_xx/(max(max(h_xx)) - min(min(h_xx)));
        %z2 = h_xx;
        z2 = h_xx_norm;
        n = surf(x,y,z2); hold on;
        ax = gca;
        title('2D $g_{xx}(x,y)$');
        xlabel('X-direction');
        ylabel('Y-direction');
        xticks([1:hSize]);
        ax.XTickLabel = -floor(hSize/2):floor(hSize/2);
        yticks([1:hSize]);
        ax.YTickLabel = ax.XTickLabel;
        n.FaceColor = 'none';
        n.Marker = 'o';
        n.MarkerSize = 4;
        n.MarkerFaceColor = 'flat';
        colormap(cm);
        axis tight;
        axis equal;
        colorbar;
        
        subplot(2,2,3);
        y = z1(ceil(hSize/2),:);
        plot(y,'DisplayName',['$\sigma$ = ', num2str(s)],...
            'Color',cm(c,:)); hold on; grid on;
        ax = gca;
        axis tight;
        xticks(1:hSize);
        ax.XTickLabel = -floor(hSize/2):floor(hSize/2);
        xlabel('X-direction');
        ylabel('Amplitude');
        c = mod(c + 5,size(cm,1)); % color counter
        
        subplot(2,2,4);
        plot(z2(ceil(hSize/2),:),'DisplayName',['$\sigma$ = ', num2str(s)],...
            'Color',cm(c,:)); hold on; grid on;
        ax = gca;
        axis tight;
        xticks(1:hSize);
        ax.XTickLabel = -floor(hSize/2):floor(hSize/2);
        xlabel('X-direction');
        ylabel('Amplitude');
        
        suptitle(["hSize = "+num2str(hSize)+ ", s = "+ s]);
        saveas(gcf,[directory+"gaussian_filters\"+"s = "+s+ ", hSize = "+ num2str(hSize)+"_normalized.png"]);
        saveas(gcf,[directory+"gaussian_filters\"+"hSize = "+num2str(hSize)+ ", s = "+s+"_normalized.png"]);
        %saveas(gcf,[directory+"gaussian_filters\"+"s = "+s+ ", hSize = "+ num2str(hSize)+".png"]);
        %saveas(gcf,[directory+"gaussian_filters\"+"hSize = "+num2str(hSize)+ ", s = "+s+".png"]);
    end
    clear x y X Y
end

close all