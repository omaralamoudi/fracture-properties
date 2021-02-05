%% The shapes of the Gaussian function in different dimentions
%  Here I want to explain the potential of used different types of gaussian
%  functions in detecting the fractures in microCT images. 

x = -2:0.02:2;
amp = 1;
center = 0;
sig = 0.2;

g.oneD = @(A,x_0,x,sigma_x) A*exp( -(1/2)*((x-x_0).^2/(sigma_x.^2)) );
plot(x,g.oneD(amp,center,x,sig)); 

g.twoD = @(A,bx,cx,x,ay,by,cy,y) ...
    A*exp((1/2)*((x-bx).^2/(cx.^2)) + ((y-y_0).^2/(sigma_y.^2)));

