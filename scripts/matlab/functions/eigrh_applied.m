%% myeig applied
% This script is used to debug myeig function.

b = magic(3);
b = [b(:,2),b(:,3),b(:,1)] 
[vec val] = myeig(b)

[vvec vval] = eig(b);
bb = sortEigenValues(vval)