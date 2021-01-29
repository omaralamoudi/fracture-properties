function mag = ComputeTensorMag(A)
if size(A,1) ~= size(A,2); error("The tensor has be square in dimentios"); end
mag = 0;
for i = 1:size(A,1)
    for j = 1:size(A,2)
        mag = mag + A(i,j).*A(i,j);
    end
end
mag = sqrt(mag);
end