function calcHurst
% http://blogs.mathworks.com/pick/2007/11/02/advanced-matlab-surface-plot-of-nonuniform-data/
% http://www.mathworks.ch/products/matlab/demos.html?file=/products/demos/shipping/matlab/fftdemo.html
% 
clear all
close all
clc
figure(1)
set(gcf,'position',[100,100,1000,500])
set(gca,'FontName','Times New Roman','FontSize',16)
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

%% OPEN THE DATAGRID
data=open('Original_griddata_grit150_XYZ.mat');
[x,y,z,zs1,nx,ny,fy,ty,fx,tx,sx,sy]=prepareData(data);
subplot(221)
h=mesh(x(10:end-10,10:end-10),y(10:end-10,10:end-10),zs1(10:end-10,10:end-10));
title('Original surface sample 006 (grit 150), 2x2 mm')
set(gca,'position',[0 0.55 0.45,0.4]);
set(gca,'FontName','Times New Roman','FontSize',16)
shading interp
axis equal
axis off
h=colorbar;
set(get(h,'title'),'String','m');

[H1]=plotSect(nx,x,z,sx,sy,ny,0,[2,4],fy,ty,'-b');
[H2]=plotSect(ny,y,z,sy,sx,nx,1,[2,4],fx,tx,'-c');

data=open('006_griddata_SEM_44_XYZ.mat');
[x,y,z,zs1,nx,ny,fy,ty,fx,tx,sx,sy]=prepareData(data);
subplot(223)
h=mesh(x(10:end-10,10:end-10),y(10:end-10,10:end-10),zs1(10:end-10,10:end-10));
title('Sheared surface sample 006, 2.5x1 mm')
set(gca,'position',[0 0.05 0.45,0.4]);
set(gca,'FontName','Times New Roman','FontSize',16)
shading interp
axis equal
axis off
h=colorbar;
set(get(h,'title'),'String','m');

[H3]=plotSect(nx,x,z,sx,sy,ny,0,[2,4],fy,ty,'-m');
[H4]=plotSect(ny,y,z,sy,sx,nx,1,[2,4],fx,tx,'-r');

legend('Original surface (150 grit)',['H: ' num2str(H1)],'Original surface (150 grit)',['H: ' num2str(H2)],'Parallel slip direction',['H: ' num2str(H3)],'Perpendicular slip direction',['H: ' num2str(H4)])
xlabel('log10(k) (m^- ^1)');
ylabel('log10(P(k)) (m^3)');
set(gcf,'PaperPositionMode','auto')
print('-dpng','006_H.png','-r600')
end

function [H]=plotSect(N,XY,Z,S,S_opp,N_opp,opp,figN,axisf,axist,col)
% N is nx or ny
% X is x(n,:) or y(:,n)
% Z is z(n,:)
% S_opp if N is nx it is sy and viceversa
% N_opp if N is nx it is ny and viceversa
% if opp=0 analyses XY(n,:) and zsl(n,:), if opp=1 analyses XY(:,n) and
% zsl(:,n)
% figN number of figure 
%% PLOT THE SECTIONS
%figure(figN)
% take a slice
cont=1;
for n=1:N                  % plot all the sections perpendicular to x
    if opp==0 
        xsl=XY(n,:);
        zsl=Z(n,:);
    else
        xsl=XY(:,n);
        zsl=Z(:,n);
    end
    fftX=linspace(0,1/S_opp,N_opp);
    len=length(fftX);
    fftZ=fft(zsl,len);
    fftZ=fftZ.*conj(fftZ)/len;
    if opp==1
        fftZ=fftZ';
    end    
    fftZ=fftZ(1:length(xsl)/2);
    fftX=fftX(1:length(xsl)/2);
    if ~isnan(fftZ)
        %figure(2)
        %loglog(fftX,abs(fftZ));
        %axis([axisf axist -2e-5 2e-5])
        %title(['x=' num2str(S*(n-1)*1e6) ' [um]']);
        %drawnow
        if cont==1
            fftT=fftZ;
        else
            fftT=fftT+fftZ;
        end
        cont=cont+1;
    end
end
fftT=fftT/cont;
xsl_log=log10(xsl);
zsl_log=log10(zsl);
figure(1)
subplot(2,2,figN)
plot(log10(fftX),log10(fftT),col);
[coeff stat]=polyfit(log10(fftX(2:end)),log10(fftT(2:end)),1);
hold on
yy=polyval(coeff,log10(fftX(2:end)));
%H=coeff(1)+2;
H=-(coeff(1)+1)/2;
plot(log10(fftX(2:end)),yy,strcat('-',col),'linewidth',2);
hold on
set(gca,'FontName','Times New Roman','FontSize',16)
drawnow
end

function [x,y,z,zs1,nx,ny,fy,ty,fx,tx,sx,sy]=prepareData(data)
x=data.x;
y=data.y;
z=data.z/100;
clear data;
brd=4;                                                          % convlution dimension
cnv=ones(brd*2+1,brd*2+1);                                      % convolution matrix to smooth the plot data
zs0=conv2(z,cnv);                                               % smooth the plot data
zs1=zs0(brd+1:length(zs0(:,1))-brd,brd+1:length(zs0(1,:))-brd); % reshape the data
zs1=zs1-min(min(zs1));
nx=length(x(:,1));
ny=length(y(1,:));
fy=min(x(1,:));
ty=max(x(1,:));
fx=min(y(:,1));
tx=max(y(:,1));
sx=(tx-fx)/nx;
sy=(ty-fy)/ny;
end