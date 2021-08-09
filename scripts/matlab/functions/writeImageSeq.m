%WRITEIMAGES helper function that writes images slices from a 3D array.
function writeImageSeq(image,directory,imagename,extention)
% create the target directory
if not(exist(directory,'dir')), mkdir(directory); end
addpath(genpath(directory));

    for i = 1:size(image,3)
        imwrite(image(:,:,i),[directory,filesep,imagename,'_',num2str(i),extention]); 
    end
end