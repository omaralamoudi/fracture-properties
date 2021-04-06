%% loading the data by choosing the correct directory
voorndata = uiloadimageseq(1,'tif');
voorndata.img = 1-voorndata.image; 
voorndata.description = 'Voorn''s Result';

%%
fig1 = figure('Position',[100 100 400 800],'Name','Voorn''s output');

subplot(2,1,1);
ShowImage3D(voorndata,fontSize);
 
subplot(2,1,2);
dim = size(voorndata.img,1);
traverseXCoor = floor(dim/2);
ShowProfile(voorndata,traverseXCoor,fontSize);

if (saveFigures), print([figuresDirectory,'VoornsResults'],'-dpng'); end