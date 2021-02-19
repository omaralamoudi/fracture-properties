%% The shapes of the Gaussian function in different dimentions
%  Here I want to explain the potential of used different types of gaussian
%  functions in detecting the fractures in microCT images. 

x = -2:0.02:2;
amp = 1;
x_0 = 0;
y_0 = 0;
z_0 = 0; 

sig_x = 0.2;
sig_y = 0.4;
sig_z = 0.8;


figure
g.oneD = @(A,x,x_0,sigma_x) A*exp( -(1/2) * ( (x-x_0).^2/(sigma_x.^2) ) );
plot(x,g.oneD(amp,x_0,x,sig_x)); 


g.twoD = @(A,x,x_0,sig_x,y,y_0,sig_y) ...
    A*exp( -(1/2) * ( ((x-x_0).^2/(sig_x.^2)) + ((y-y_0).^2/(sig_y.^2)) ) );

