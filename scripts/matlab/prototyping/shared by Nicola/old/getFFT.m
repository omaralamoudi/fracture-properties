clear; close all; clc
A=[1 1];
fA=[0.002 1];
B=[1 1];
fB=[0.005 2];
pad=4096;
sx=1920;
sy=1080;
dxy=1;

x=[0:dxy:(sx-1).*dxy];
nx=length(x);
y=[0:dxy:(sy-1).*dxy];
ny=length(y);
[X,Y]=meshgrid(x,y);
Z=A(1).*sin(2.*pi.*fA(1).*X)+B(1).*sin(2.*pi.*fB(1).*Y);

ZFFT=fft2(Z,pad,pad);

data=abs(ZFFT);
data=data(1:pad/2,1:pad/2);
data2 = data';
[pks1, locs1, w1, p1] = findpeaks(double(data(:)),'Threshold',std(data(:))); % peaks along x
[pks2, locs2, w2, p2] = findpeaks(double(data2(:)),'Threshold',std(data(:))); % peaks along y

data_size = size(data); % Gets matrix dimensions
[col2, row2] = ind2sub(data_size, locs2); % Converts back to 2D indices
locs2 = sub2ind(data_size, row2, col2); % Swaps rows and columns and translates back to 1D indices

ind = intersect(locs1, locs2); % Finds common peak position
[row, col] = ind2sub(data_size, ind); % to 2D indices

ampl=data(row,col);
ampl=ampl(:,1);

figure
pcolor(X,Y,Z(1:ny,1:nx));
shading flat
colorbar

figure
subplot(2,1,1);
pcolor(abs(ZFFT));
shading flat
subplot(2,1,2);
pcolor(angle(ZFFT));
shading flat

