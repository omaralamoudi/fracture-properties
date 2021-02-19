function sortedEigenValues = sortEigenValues(EigenMatrix)
    for n = 1:size(EigenMatrix,1)
        sortedEigenValues(n) = EigenMatrix(n,n);
    end
    sortedEigenValues = sort(sortedEigenValues);
end