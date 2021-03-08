% LOADIMAGE load either a single tif image or a sequence of files into a
% matlab variable. 
%
% data = LOADIMAGE(1,'.tif')


function data = loadImage(isStack,imageExtension)
order = {'folder','filename','fileext','isStack','image'};
    if (not(isStack)) % for individual image files
        [data.filename, data.folder] = uigetfile(['*.',imageExtension]);
        data.fileext = imageExtension;
        data.isStack = isStack;
        data.image   = imread([data.folder,filesep,data.filename]);
        data         = orderfields(data,order);
    else % for directories that containt a stack of images (slices)
        data.folder = uigetdir(".","Image directory");
%         data.filename ... ;
        lst = dir(data.folder);
        lst = filterDirectories(lst);
        lst = filterImages(lst,imageExtension);
        data.filename = {lst.name}';
        data.fileext  = imageExtension;
        data.isStack  = isStack; 
        firstImage = imread([lst(1).folder,filesep,lst(1).name]);
        data.image = zeros([size(firstImage) length(lst)]);
        data.image(:,:,1) = firstImage;
        % progress bar vvvv
        f = uifigure;
        d = uiprogressdlg(f,'Title','Please Wait',...
        'Message','Loading Images ...');
        pause(.5);
        % progress bar ^^^
        for j = 2:length(lst)
            data.image(:,:,j) = imread([lst(j).folder,filesep,lst(j).name]);
            % progress bar vvvv
            d.Value = j/length(lst);
            d.Message = ["Loading Images ("+j+" of "+length(lst)+")"];
            % progress bar ^^^^
        end
        % progress bar vvvv
        % uialert(f,"Images loaded","Images loaded","Icon","success");
        pause(0.5);
        close(f);
        % progress bar ^^^^
    end
    data = orderfields(data,order);
    
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
end