% http://blogs.mathworks.com/pick/2007/11/02/advanced-matlab-surface-plot-of-nonuniform-data/

clear all
close all
clc
%open the data from WLI measured by Thibo
%data=open('Original_grit150_XYZ.mat');
data=open('006_SEM_44_XYZ.mat');
%define the grid
nx=1000;                % x nodes
ny=1000;                % y nodes
fx=min(data.X);         % from
tx=max(data.X);
fy=min(data.Y);
ty=max(data.Y);
xlin=linspace(fx,tx,nx);
ylin=linspace(fy,ty,ny);
[x,y]=meshgrid(xlin,ylin);
z=griddata(data.X,data.Y,data.Z,x,y,'cubic');

% find the plane which passes through the point to riallianeate then to 0
dat=[data.X data.Y data.Z];
sol=ones(length(data.X),1);
pln=dat\sol;
zpl=-pln(1)/pln(3)*x-pln(2)/pln(3)*y+1/pln(3);
z=z-zpl;

figure(1)
mesh(x,y,z);
shading interp

figure(2)
% take a slice
for n=1:nx
    xsl=x(n,:);
    zsl=z(n,:);
    plot(xsl,zsl)
    axis([fx tx -2e-5 2e-5])
    drawnow
    pause(0.001)
end

for n=1:ny
    ysl=y(:,n);
    zsl=z(:,n);
    plot(ysl,zsl,'r')
    axis([fy ty -2e-5 2e-5])
    drawnow
    pause(0.001)
end