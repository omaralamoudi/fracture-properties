x = 1:100;
y1 = cos(x);
y2 = zeros(size(x));
y2(floor(length(y1)/2):end) = 1;

y3 = conv(y1,y2,'same'); 

plot(x,y1,x,y2,x,y3); 