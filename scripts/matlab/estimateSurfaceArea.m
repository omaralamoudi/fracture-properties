% considering the crisp image
nSlices = 3;
k = 1;
img(k).stack = img(1).img;
for i = 1:nSlices
    img(k).stack = cat(3,img(k).stack,img(1).img);
end

figure
is = patch(isosurface(img(k).stack,.99));