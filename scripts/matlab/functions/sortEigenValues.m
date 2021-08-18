function sortedEigenValues = sortEigenValues(EigenMatrix)
sortedEigenValues = diag(EigenMatrix)';
sortedEigenValues = sort(sortedEigenValues);
end