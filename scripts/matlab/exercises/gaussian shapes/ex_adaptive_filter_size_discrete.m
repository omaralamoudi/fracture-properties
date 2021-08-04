% This script plots 1D discrete gaussians with different scaling factors s 
% sigma, their gradient, and the second derivative.
%
% Purpose:
% Determine the needed kenral size to capture the peak-trough-peak
% character that is critical to the Multi-Scale Hessian Fracture Filtering
% MSHFF.

close all;

gauss   = @(A,x,x0,sx) A * (exp(-(1/2)*((x-x0).^2/(sx.^2))));
gauss_x = @(A,x,x0,sx) A * (exp(-(1/2)*((x-x0).^2/(sx.^2))) .* (-1*(x-x0)./(sx.^2)));
gauss_xx= @(A,x,x0,sx) A * (exp(-(1/2)*((x-x0).^2/(sx.^2))) .* (-1*(x-x0)./(sx.^2)) .* (-(x-x0)./sx.^2) + (exp(-(1/2)*((x-x0).^2/(sx.^2)))) .* (-1./(sx.^2)));

s   = [1,2,3,5];
x0  = 0;
smultiplier = 9;
slimitfactor_oneside = smultiplier/2;    % filter size = 2 x psi
dx  = 1;
a   = 5; % arbitrary multiplier for the range of x 
x   = x0:dx:a*slimitfactor_oneside*max(s);
tmp = x0-dx:-dx:-max(x);
x   = [tmp(end:-1:1),x];
A   = 1;
e   = .5*A;

figure
subplot(3,1,1);
plotf(x,gauss,A,x0,s,'$G(x)$');

subplot(3,1,2);
plotf(x,gauss_x,A,x0,s,'$G,_x$');

subplot(3,1,3);
plotf(x,gauss_xx,A,x0,s,'$G,_{xx}$');

function plotf(x,anonfunc,A,x0,s,title)
    s = sort(s,'ascend');
    for i = 1:length(s)
        y = anonfunc(A,x,x0,s(i));
        p = stairs_centered(x,y);
        p.DisplayName = ['s = ',num2str(s(i))];
        hold on;
        q = plot(x,y,'*','Color',p.Color);
        q.Annotation.LegendInformation.IconDisplayStyle = 'off';
        ax = gca;
        slimitfactor = determintslimitfactor(s(i));
        % plot the left side limiter
        l = plot(x0-slimitfactor*s(i)*[1 1] ,ax.YLim,'--','LineWidth',2,'Color',p.Color);
        l.Annotation.LegendInformation.IconDisplayStyle = 'off'; % <-- turn off legend\
        % plot the right side limiter
        l = plot(x0+slimitfactor*s(i)*[1 1] ,ax.YLim,'--','LineWidth',2,'Color',p.Color);
        l.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    ax.XLim = 1.1*(x0-4.5*max(s)*[1 -1]);
    ax.Title.String = title;
    legend
    fixFigure(gcf,16);
end

function slf = determintslimitfactor(s)
    slf = (1-mod(s,2)) * 4.5 + mod(s,2) * 4.5;
    %     \_____even s_____/   \___odd s____/
end
