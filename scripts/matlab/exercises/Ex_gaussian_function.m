clear variables; clc
doSaveFigures = 0;
cm = InitColormaps;
% The Gaussian function is f(x) = a exp{-(x-b).^2/(2c^2)}
% cm = cm_viridis;
dcm = 10;

s = [0.1:0.4:.9,1:1:3];
% a = 0.5*s;
a = ones(size(s));
b = 0;
dx = .01;
%x = -20:dx:20;
x = linspace(-10,10,4001);
figure('Position',[100 100 1000 900]);
for i=1:length(s)
y = a(i)*exp(-(x-b).^2/(2*s(i).^2));
y_xx = gradient(gradient(y,dx),dx);
% y_xx_norm = (y_xx/(max(y_xx) - min(y_xx))*2);
normFactor = 1.445;
y_xx_norm = (y_xx/(max(y_xx) - min(y_xx))*(normFactor));
y_xx_norm_trans = y_xx_norm + 1 - max(y_xx_norm);
x0 = [b + s(i)*sqrt(2*log(2)), b - s(i)*sqrt(2*log(2)), 2*  s*sqrt(2*log(2))]; 
ax1 = subplot(2,1,1);
p(i) = plot(ax1,x,y,'DisplayName',['s = ',num2str(s(i))],'Color',cm(i*dcm,:)); hold on; grid on;
ax3 = subplot(2,1,2);
p3(i) = plot(ax3,x,y_xx_norm,'DisplayName',['s = ',num2str(s(i))],'Color',cm(i*dcm,:));hold on; grid on;
end
% ax1.Color = 0.*[1 1 1];
title(ax1, 'Gaussian Function $G(x,s) =  1 \times e^{-\frac{1}{2} (\frac{x-0}{s})^2}$, varying s','Interpreter','latex');
legend(ax1,p);
title(ax3, '$G_{xx}(x,s)$ Normalized, varying s','Interpreter','latex');
legend(ax3,p3);
fixFigure(gcf, 18);
directory = '..\Presentation\figures\';
if doSaveFigures, saveas(gcf,[directory,'gaussian_continuous.png']);end
%% Discrete domain

dx = 1;
x = -10:dx:10;
% x = linspace(-20,20,15);
figure('Position',[100 100 1000 900]);
for i=1:length(s)
y = a(i)*exp(-(x-b).^2/(2*s(i).^2));
y_xx = gradient(gradient(y,dx),dx);
% y_xx_norm = (y_xx/(max(y_xx) - min(y_xx))*2);
normFactor = 1.445;
y_xx_norm = (y_xx/(max(y_xx) - min(y_xx))*(normFactor));
y_xx_norm_trans = y_xx_norm + 1 - max(y_xx_norm);
x0 = [b + s(i)*sqrt(2*log(2)), b - s(i)*sqrt(2*log(2)), 2*  s*sqrt(2*log(2))]; 
ax1 = subplot(2,1,1);
p(i) = plot(ax1,x,y,'DisplayName',['s = ',num2str(s(i))],'Color',cm(i*dcm,:)); hold on; grid on; grid minor;
ax3 = subplot(2,1,2);
p3(i) = plot(ax3,x,y_xx_norm,'DisplayName',['s = ',num2str(s(i))],'Color',cm(i*dcm,:));hold on; grid on;
end

title(ax1, 'Gaussian Function $G(x,s) =  1 \times e^{-\frac{1}{2} (\frac{x-0}{s})^2}$, varying s','Interpreter','latex');
legend(ax1,p);
title(ax3, '$G_{xx}(x,s)$ Normalized, varying s','Interpreter','latex');
legend(ax3,p3);
fixFigure(gcf, 18);
if doSaveFigures, saveas(gcf,[directory,'gaussian_discrete.png']);end

%% hsize demonstration 