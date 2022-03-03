% I'm using this script to prototype a better way of generating synthetic
% fracture images 2d and 3d
clearvars; close all; 
% input axes and center point

x0 = 0;
y0 = 0;
eaxes       = [100 10]; % ellipse/ellipsoid axes in the order [x y z]
radiuses    = eaxes /2;
maxradius   = max(radiuses);
m = 1.25;
X = -m*maxradius:m*maxradius; 
Y = -m*maxradius:m*maxradius;
[x, y] = meshgrid(X,Y);

I = abs((x-x0)/(radiuses(1))).^2 + ((y-y0)./(radiuses(2))).^2 < 1;
    
figure
imagesc(X,Y,I);
colormap('gray');
axis equal;
% a different way to generate the same image using quadratic form is

xx = [x(:)'-x0; y(:)'-y0];
B = diag((1./radiuses).^2);
theta = pi/4;
Q = [cos(theta), -sin(theta);
     sin(theta),  cos(theta)];

II = dot(xx,Q'*B*Q*xx) < 1; 
II = reshape(II,size(x));

figure
imshow(II); colormap('gray');
axis equal; hold on;

IIsk = bwskel(II);
imshow(labeloverlay(single(II),IIsk,'Transparency',0))

