function SaveResults(img, fracAps, abreriation)
    img_norm = img / (max(max(max(img))));
    img_inv  = 1 - img_norm;
    
    for j = 1:3
        fileName = ['output/results/',char(abreriation),'_3DResult_',num2str(j),'.tif'];
        imwrite(img_inv(:,:,j),fileName);
    end
end