% This script plots 1D  gaussians with different scaling factors s 
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

s   = 1:5;
x0  = 0;
psi = 4;    % filter size = 2 x psi
smul= psi+1;
x   = -smul*max(s):.1:smul*max(s);
A   = 1;
e   = .5*A;

figure
subplot(3,1,1);
plotf(x,gauss,A,x0,s,psi);

subplot(3,1,2);
plotf(x,gauss_x,A,x0,s,psi);

subplot(3,1,3);
plotf(x,gauss_xx,A,x0,s,psi);

function plotf(x,anonfunc,A,x0,s,psi)
    for i = 1:length(s)
        y = anonfunc(A,x,x0,s(i));
%         y = y - min(y(:));
%         y = y/max(y(:));
        p = plot(x, y, 'DisplayName',['s = ',num2str(s(i))]);
%         oastairs(x,func(A,x,x0,s(i)));
        hold on;
        ax = gca;
%         ax.YLim = [-1 1];
        l = plot(x0-psi*s(i)*[1 1] ,ax.YLim,'Color',p.Color);
        l.Annotation.LegendInformation.IconDisplayStyle = 'off'; % <-- turn off legend
        l = plot(x0+psi*s(i)*[1 1] ,ax.YLim,'Color',p.Color);
        l.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
     
    legend
end