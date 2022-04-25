% http://blogs.mathworks.com/pick/2007/11/02/advanced-matlab-surface-plot-of-nonuniform-data/

clear all
close all
clc
%% UNCOMMENT TO OPEN ORIGINAL DATA FROM WLI AND CREATE GRIDDATA
% open the data from WLI measured by Thibo
%%data=open('Original_grit150_XYZ.mat');
% data=open('006_SEM_44_XYZ.mat');
%%define the grid
% fx=min(data.X);                                   % from X [m]
% tx=max(data.X);                                   % to X   [m]
% fy=min(data.Y);                                   % from Y [m]
% ty=max(data.Y);                                   % to Y   [m]
% sx=unique(chop(diff(unique(data.X)),12));         % find x step [m]
% if length(sx)>1; return; end                      % check that there are not different steps 
% sy=unique(chop(diff(unique(data.Y)),12));         % find y step [m]
% if length(sy)>1; return; end                      % check that there are not different steps 
% xlin=[fx:sx:tx];                                  % create the x distribution
% ylin=[fy:sy:ty];                                  % create the y distribution
% [x,y]=meshgrid(xlin,ylin);                        % create the grid x-y
% z=griddata(data.X,data.Y,data.Z,x,y,'cubic');     % calculate the z on the grid starting from the original data 
% find the plane which passes through the points
% dat=[data.X data.Y data.Z];                       % set the unknown coefficients, get the data in three columns
% sol=ones(length(data.X),1);                       % set the known column
% pln=dat\sol;                                      % calculate a,b,c coefficients: plane => ax+by+cz=1
% zpl=-pln(1)/pln(3)*x-pln(2)/pln(3)*y+1/pln(3);    % calculate the plane for the point in the grid
% z=z-zpl;                                          % offset the surface 
%%save('Original_griddata_grit150_XYZ.mat','x','y','z')     % save 
% save('006_griddata_SEM_44_XYZ.mat','x','y','z')           % save

%% UNCOMMENT TO OPEN THE DATAGRID
% data=open('Original_griddata_grit150_XYZ.mat');
data=open('006_griddata_SEM_44_XYZ.mat');
x=data.x;
y=data.y;
z=data.z;
clear data;
brd=4;                                                          % convlution dimension
cnv=ones(brd*2+1,brd*2+1);                                      % convolution matrix to smooth the data
zs0=conv2(z,cnv);                                               % smooth the data
zs1=zs0(brd+1:length(zs0(:,1))-brd,brd+1:length(zs0(1,:))-brd); % reshape the data

%% CALCULATE THE POWER SPECTRUM AND THE HURST COEFF
nx=length(x(:,1));
ny=length(y(1,:));
fy=min(x(1,:));
ty=max(x(1,:));
fx=min(y(:,1));
tx=max(y(:,1));
sx=(tx-fx)/nx;
sy=(ty-fy)/ny;

figure(1)
mesh(x,y,zs1);
shading interp

%% PLOT THE SECTIONS 
%figure(2)
% take a slice
for n=1:nx                  % plot all the sections perpendicular to x
    xsl=x(n,:);
    zsl=z(n,:);
    fftX=linspace(0,1/sy,ny);
    fftZ=fft(zsl);
    fftZ=fftZ(1:length(xsl)/2);
    fftX=fftX(1:length(xsl)/2);
    %loglog(fftX,abs(fftZ));
    %axis([fy ty -2e-5 2e-5])
    %title(['x=' num2str(sx*(n-1)*1e6) ' [um]']);
    %drawnow
    if n==1
        fftT=fftZ;
    else
        fftT=fftT+fftZ;
    end
    %pause(0.001)
end
fftT=fftT/nx;
xsl_log=log10(xsl);
zsl_log=log10(zsl);

figure(2)
plot(log10(fftX),log10(abs(fftT)));
[coeff stat]=polyfit(log10(fftX(2:end)),log10(abs(fftT(2:end))),1);
hold on
yy=polyval(coeff,log10(fftX(2:end)));
plot(log10(fftX(2:end)),yy,'k')

    
 figure(3)
 for n=1:ny                  % plot all the sections perpendicular to y
     ysl=y(:,n);
     zsl=z(:,n);
     fftX=fft(zsl);
     %plot(ysl,zsl,'r')
     loglog(abs(fftX));
     %axis([fx tx -2e-5 2e-5])
     title(['y=' num2str(sy*(n-1)*1e6) ' [um]']);
     drawnow
     pause(0.001)
end