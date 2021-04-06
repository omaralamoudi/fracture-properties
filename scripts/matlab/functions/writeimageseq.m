%WRITEIMAGES helper function that writes iages  
function writeimageseq(image,directory,imagename,extention)
    for i = 1:size(image,3)
        imwrite(image(:,:,i),[directory,filesep,imagename,'_',num2str(i),extention]); 
    end
end