function [eigvec, eigval] = myeig(M)
% This computes the eigen values, sorts them from largest to smallest, and
% makes them right handed.
[tmp.eigvec, tmp.eigval] = eig(M);
% [~,indx] = sort(diag(tmp.eigval),'descend');
[~,indx] = sort(diag(tmp.eigval),'descend');
eigval = tmp.eigval(indx,indx);
eigval = diag(eigval);
eigvec = tmp.eigvec(:,indx);
if det(eigvec) < 0
    % Right handedness: https://math.stackexchange.com/questions/537090/eigenvectors-for-the-equation-of-the-second-degree-and-right-hand-rule
    eigvec(:,end) = -eigvec(:,end);
end
end