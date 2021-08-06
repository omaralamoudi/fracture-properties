function data = uiloadimageseq(imageExtension)
%UILOADIMAGESEQ loads image sequence of files into a matlab variable.
%   data = LOADIMAGESEQ('.tif')
%
%   By Omar Alamoudi:   omar.alamoudi@gmail.com
%   Last updated:       April 6, 2021

%   See also LOADIMAGESEQ, UILOADIMAGE, LOADIMAGE

data.folder = uigetdir(".","Image sequence directory");
data        = loadimageseq(data.folder,imageExtension);
end