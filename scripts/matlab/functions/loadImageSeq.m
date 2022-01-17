function data = loadImageSeq(path,extenstion)
%LOADIMAGESEQ loads multiple images files with the same extension.
%   data = LOADIMAGESEQ(path,extension) returns a structure data with
%   fields describing corresponding to the file properties associated with
%   the loaded image. To access the image use data.image
%
%   By Omar Alamoudi:   omar.alamoudi@gmail.com
%   Last updated:       August 24, 2021
%
% See also UILOADIMAGESEQ,
tmp = what(path);
data.folder = tmp.path;
ext = formatExt(extenstion);
disp(['loadImageSeq: loading image sequence from: ',path]);
lst = dir(data.folder);
lst = filterDirectories(lst);
lst = filterImages(lst,ext);
data.filename       = {lst.name}';
data.fileext        = ext;
nimages             = length(lst);
firstimage          = imread([lst(1).folder,filesep,lst(1).name]);
data.image          = zeros([size(firstimage) nimages]);
data.image(:,:,1)   = firstimage;

progressBar = TextProgressBar('loadImageSeq');

%% reading the images
for j = 2:length(lst)
    data.image(:,:,j) = imread([lst(j).folder,filesep,lst(j).name]);
    progressBar.update(j/nimages);
end
progressBar.complete();

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

function ext = formatExt(extension)
if extension(1) == '.'
    ext = extension(2:end); 
else 
    disp(['loadImageSeq: file extension are properly formatted as ', extension]);
    ext = extension;
end
end