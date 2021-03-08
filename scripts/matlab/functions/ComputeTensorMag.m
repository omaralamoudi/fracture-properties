function mag = ComputeTensorMag(A)
if size(A,1) ~= size(A,2); error("The tensor has be square in dimentios"); end
tmp = A .* A;
mag = sqrt(tmp);
end