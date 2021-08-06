% UILOADIMAGE loads a single image into a matlab variable. 
%
% data = UILOADIMAGE('.tif')

function data = uiLoadImage(imageExtension)
[data.filename, data.folder] = uigetfile(['*.',imageExtension]);
        data.fileext = imageExtension;
        data.isStack = false;
        data.image   = imread([data.folder,filesep,data.filename]);
        data         = orderfields(data,order);
end