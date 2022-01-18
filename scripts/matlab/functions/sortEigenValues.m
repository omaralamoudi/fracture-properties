function sortedEigenValues = sortEigenValues(EigenMatrix)
% extract diagonal elements into a row vector/array
sortedEigenValues = diag(EigenMatrix);
% sort array elements from smallest to largest
sortedEigenValues = sort(sortedEigenValues);
end