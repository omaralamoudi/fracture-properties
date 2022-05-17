% clearvars;
% navigate to the correct directory 
if exist('goto','file')
    goto(3); % this is my way of going to the project file
end

doExport = false;

sevenAFracturedImageFileName = 'sevenA_fractured_image.mat';
sevenAFracturedImageFilePath = fullfile('prototyping','7A_fractured',sevenAFracturedImageFileName);

% loading the data
dataWasNotSaved = false; % this assumes data was already saved previously
if dataWasNotSaved
    data = loadImageSeq(fullfile('..','..','data','Bland','7A_fractured','8bitJPG'),'jpg');
    save(sevenAFracturedImageFilePath,'data','-v7.3','-mat');
else
    disp('loading from variable directly ...');
    load(sevenAFracturedImageFilePath);
    disp('loading completed');
end

tic
zoffset = 30;
fig = figure('Position',[2 32 515 965]); 
xslices = [floor(size(data.image,2)/2) size(data.image,2)];
yslices = [floor(size(data.image,1)/2) size(data.image,1)];
% zslices = [1 floor(linspace(zoffset, size(data.image,3)-zoffset,10)), size(data.image,3)];
zslices = [floor(linspace(zoffset, size(data.image,3)-zoffset,10))]; % removes the top an bottom of the sample
s = slice(data.image,xslices,yslices,zslices);

shading flat; axis image; colormap gray;

xlabel('x (column)');
ylabel('y (row)');
zlabel('z (slice)'); 

ax = gca;
ax.ZAxis.Direction = 'reverse';
ax.CLim = [5 65];

ax.XTick = [1 xslices];
ax.YTick = [1 yslices];
ax.ZTick = zslices;

ax.View = [-7.6353 -90];

toc 
% elapsed time was 260 secs
pause(1);
if doExport
    exportgraphics(gcf,'figures/7A_fractured_slices.png','Resolution',300);
    savefig('figures/7A_fractured_slices.fig');
end