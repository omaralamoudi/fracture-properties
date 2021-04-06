function data = loadimageseq(path,extenstion)
%LOADIMAGESEQ loads multiple images files with the same extension.
%   data = LOADIMAGESEQ(path,extension) returns a structure data with
%   fields describing corresponding to the file properties associated with
%   the loaded image. To access the image use data.image
%
%   By Omar Alamoudi:   omar.alamoudi@gmail.com
%   Last updated:       April 6, 2021
%
% See also UILOADIMAGESEQ,

data.folder = path;
lst = dir(data.folder);
lst = filterDirectories(lst);
lst = filterImages(lst,extenstion);
data.filename       = {lst.name}';
data.fileext        = extenstion;
l                   = length(lst);
data.image          = zeros([size(firstImage) l]);
data.image(:,:,1)   = imread([lst(1).folder,filesep,lst(1).name]);

% progress bar vvvv
wb = waitbar(0,'Please Wait ...');
pause(.2);
% progress bar ^^^

%% reading the images
for j = 2:length(lst)
    data.image(:,:,j) = imread([lst(j).folder,filesep,lst(j).name]);
    waitbar(j/l,wb,['Loading Images (',num2str(j),' of ',num2str(length(lst)),')']); % <-- progress bar
end
waitbar(1,wb,'Done.');
% progress bar vvvv
pause(0.1);
close(wb);
% progress bar ^^^^

order   = {'folder','filename','fileext','image'};
data    = orderfields(data,order);

end

function result = filterDirectories(lst)
result = lst(~[lst.isdir]);
end

function lst = filterImages(lst,ext)
i = 1;
l = length(lst);
% while is used because the struct array size changes (l)
while( i < l+1)
    if (~endsWith(lst(i).name,ext))
        lst(i) = [];
        l = l - 1;
    end
    i = i + 1;
end
end