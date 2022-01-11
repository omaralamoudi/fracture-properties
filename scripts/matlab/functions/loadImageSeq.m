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

% progress bar vvvv
wb = waitbar(0,'Please Wait ...');
pause(.2);
% progress bar ^^^

%% reading the images
for j = 2:length(lst)
    data.image(:,:,j) = imread([lst(j).folder,filesep,lst(j).name]);
    waitbar(j/nimages,wb,['Loading Images (',num2str(j),' of ',num2str(length(lst)),')']); % <-- progress bar
end
waitbar(1,wb,'Done.');
% progress bar vvvv
pause(0.1);
close(wb);
% progress bar ^^^^

order   = {'folder','filename','fileext','image'};
data    = orderfields(data,order);
disp(['loadImageSeq: loading image sequence completed']);
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