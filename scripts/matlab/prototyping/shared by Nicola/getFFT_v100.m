clear; close all; clc
A=[1 0];
fA=[0.002 1];
B=[0 0];
fB=[0.002 2];
pad=2048;
sx=1920;
sy=1080;
dxy=1;

xA=[0:dxy:(sx-1).*dxy];
nx=length(xA);
yA=[0:dxy:(sy-1).*dxy];
ny=length(yA);
[X,Y]=meshgrid(xA,yA);
Z=A(1).*sin(2.*pi.*fA(1).*X+Y/62.8)+B(1).*sin(2.*pi.*fB(1).*Y);

ZFFT=fft2(Z,pad,pad);

data=abs(ZFFT/(sx*sy));
dc=data(1,1);
data=2*data;
data(1,1)=dc;

xA=data(1:pad,1);
yA=data(1,1:pad);

xf=[0:1/dxy:(pad-1)/dxy]/pad;
yf=[0:1/dxy:(pad-1)/dxy]/pad;

xA=xA(1:end/2);
yA=yA(1:end/2);
xf=xf(1:end/2);
yf=yf(1:end/2);

[a ID]=max(xA);
b=xf(ID);
c=1e-9;
low=[a b c]*0.8;
up=[a b Inf]*1.2;

[cf, gof] = fitGauss(xf, xA,low,up)
xfit=cf.a.*exp(-(xf-cf.b).^2./cf.c);

figure
pcolor(X,Y,Z(1:ny,1:nx));
shading flat
colorbar

figure
subplot(2,1,1);
contour(log10(abs(ZFFT)));
shading flat
subplot(2,1,2);
pcolor(angle(ZFFT));
shading flat

figure;
semilogx(xf,xA,'-r'); hold on
semilogx(xf,xfit,'.r');
semilogx(yf,yA);
