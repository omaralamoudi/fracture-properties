%% Displaying the Eigen values and eigen vectors of the image finite difference implemntation
hessImp = 1;
k = 4;
slice = 2;
imagesc(img(k).img(:,:,slice)); colormap gray; hold on;
u1 = zeros(size(img(k).img));
u2 = zeros(size(img(k).img));
u3 = zeros(size(img(k).img));
v1 = zeros(size(img(k).img));
v2 = zeros(size(img(k).img));
v3 = zeros(size(img(k).img));
w1 = zeros(size(img(k).img));
w2 = zeros(size(img(k).img));
w3 = zeros(size(img(k).img));

% extracting the eigen vectors
for m = 1:size(img(k).img,3)
    for j = 1:size(img(k).img,1)
        for i = 1:size(img(k).img,2)
            u1(j,i,m) = img(1).hessian(hessImp).EigVec{j,i,m}(1,1);
            u2(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(2,1);
            u3(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(3,1);
            Eu(j,i,m) = img(k).hessian(hessImp).EigValMatrix{j,i,m}(1,1);
            v1(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(1,2);
            v2(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(2,2);
            v3(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(3,2);
            Ev(j,i,m) = img(k).hessian(hessImp).EigValMatrix{j,i,m}(2,2);
            w1(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(1,3);
            w2(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(2,3);
            w3(j,i,m) = img(k).hessian(hessImp).EigVec{j,i,m}(3,3);
            Ew(j,i,m) = img(k).hessian(hessImp).EigValMatrix{j,i,m}(3,3);
        end
    end
end


[x,y,z] = meshgrid(1:dx:dx*size(img(k).img,2),1:dy:dy*size(img(k).img,1),1:dz:dz*size(img(k).img,3));
slice = 2;
quiver(x(:,:,slice),y(:,:,slice),u1(:,:,slice),u2(:,:,slice),'AutoScale','off'); hold on;
quiver3(x,y,z,v1,v2,v3,'AutoScale','off');
quiver3(x,y,z,w1,w3,w3,'AutoScale','off');
axis tight
axis square
%%
figure('Position',[100 100 800 800]);
subplot(2,2,1);
imagesc(Eu);
axis tight
axis square
colormap gray
colorbar
title('Eigenvalue 1');

subplot(2,2,2);
imagesc(Ev);
axis tight
axis square
colormap gray
colorbar
title('Eigenvalue 2');

subplot(2,2,3);
imagesc(max(abs(Eu),abs(Ev)));
axis tight
axis square
colormap gray
colorbar
title('Max Eigenvalue');

subplot(2,2,4);
imagesc(min(abs(Eu),abs(Ev)));
axis tight
axis square
colormap gray
colorbar
title('Min Eigenvalue');

%% Displaying the Eigen values and eigen vectors of the image convolution
hessImp = 2;
k = 4;
imagesc(img(k).img); colormap gray; hold on;
u1 = zeros(size(img(k).img));
u2 = zeros(size(img(k).img));
v1 = zeros(size(img(k).img));
v2 = zeros(size(img(k).img));
% extracting the eigen vectors
for j = 1:size(img(k).img,1)
    for i = 1:size(img(k).img,2)
        u1(j,i) = img(1).hessian(hessImp).EigVec{j,i}(1,1);
        u2(j,i) = img(k).hessian(hessImp).EigVec{j,i}(2,1);
        Eu(j,i) = img(k).hessian(hessImp).EigValMatrix{j,i}(1,1);
        v1(j,i) = img(k).hessian(hessImp).EigVec{j,i}(1,2);
        v2(j,i) = img(k).hessian(hessImp).EigVec{j,i}(2,2);
        Ev(j,i) = img(k).hessian(hessImp).EigValMatrix{j,i}(2,2);
    end
end


[x,y] = meshgrid(1:dx:dx*size(img(k).img,2),1:dy:dy*size(img(k).img,1));
quiver(x,y,u1,u2,'AutoScale','off'); hold on;
quiver(x,y,v1,v2,'AutoScale','off');
axis tight
axis square

figure('Position',[100 100 800 800]);
subplot(2,2,1);
imagesc(Eu);
axis tight
axis square
colormap gray
colorbar
title('Eigenvalue 1');

subplot(2,2,2);
imagesc(Ev);
axis tight
axis square
colormap gray
colorbar
title('Eigenvalue 2');

subplot(2,2,3);
imagesc(max(abs(Eu),abs(Ev)));
axis tight
axis square
colormap gray
colorbar
title('Max Eigenvalue');

subplot(2,2,4);
imagesc(min(abs(Eu),abs(Ev)));
axis tight
axis square
colormap gray
colorbar
title('Min Eigenvalue');