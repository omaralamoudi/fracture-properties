%%  COMPUTING TRADITIONAL DERIVATIVE OPERATIONS
% defining the pixle/voxel dimentions

dx = 1;
dy = 1;

% computing the first and second derivative
for k = 1:4 % k is the index for the image type
    [data(k).ddx, data(k).ddy]            = gradient(double(data(k).img),dx,dy);
    [data(k).ddxddx, data(k).ddyddx]      = gradient(data(k).ddx,dx,dy);
    [data(k).ddxddy, data(k).ddyddy]      = gradient(data(k).ddy,dx,dy);
end

clear k;
%% All Hessian Operations
% The structure of the hessian shown below is as following. A 4D array was
% created as following hessian(i,j,k,l), where i, and j correspond to the
% pixel, and k, and l correspond to the hessian index.



for k = 1:4
    
    % Finite difference Hessian Implementation
    tic
    % create a cell array the same size as the image for the Hessian matrix
    % , the eigenvectors and eigenvalues
    data(k).hessian(1).matrix = cell(size(data(k).img));
    data(k).hessian(1).EigVec = cell(size(data(k).img));
    data(k).hessian(1).EigVal = cell(size(data(k).img));
    for j = 1:size(data(k).img,1)
        % loop along the x-direction first
        for i = 1:size(data(k).img,2)
            data(k).hessian(1).matrix{j,i} = [data(k).ddxddx(j,i),data(k).ddxddy(j,i);...
                data(k).ddyddx(j,i),data(k).ddyddy(j,i)];
            data(k).hessian(1).magnitude(j,i)  = ComputeTensorMag(data(k).hessian(1).matrix{j,i});
            [data(k).hessian(1).EigVec{j,i},data(k).hessian(1).EigValMatrix{j,i}] = eig(data(k).hessian(1).matrix{j,i});
        end
    end
    toc
    
    % Convolution Hessian implementation
    sigma = 1;
    hsize = 5;
    [data(k).hessian(2).matrix,~,~,~,~] = ComputeHessian2D(data(k).img,2,hsize,sigma);
    for j = 1:size(data(k).img,1)
        for i = 1:size(data(k).img,2)
            data(k).hessian(2).magnitude(j,i)  = ComputeTensorMag(data(k).hessian(2).matrix{j,i});
            [data(k).hessian(2).EigVec{j,i},data(k).hessian(2).EigValMatrix{j,i}] = eig(data(k).hessian(2).matrix{j,i});
        end
    end
    
    % I still need to add the magnitude eigen vectors and eigen values
end

%% Displaying the Eigen values and eigen vectors of the image finite difference implemntation
hessImp = 1;
k = 4;
figure;
imagesc(data(k).img); colormap gray; hold on;
u1 = zeros(size(data(k).img)); % the fist componenet of the first vector
u2 = zeros(size(data(k).img)); % the second componenet of the first vector
v2 = zeros(size(data(k).img)); % the fist componenet of the second vector
v2 = zeros(size(data(k).img)); % the second componenet of the second vector
% extracting the eigen vectors
for j = 1:size(data(k).img,1)
    for i = 1:size(data(k).img,2)
        u1(j,i) = data(1).hessian(hessImp).EigVec{j,i}(1,1);
        u2(j,i) = data(k).hessian(hessImp).EigVec{j,i}(2,1);
        Eu(j,i) = data(k).hessian(hessImp).EigValMatrix{j,i}(1,1);
        v2(j,i) = data(k).hessian(hessImp).EigVec{j,i}(1,2);
        v2(j,i) = data(k).hessian(hessImp).EigVec{j,i}(2,2);
        Ev(j,i) = data(k).hessian(hessImp).EigValMatrix{j,i}(2,2);
    end
end


[x,y] = meshgrid(1:dx:dx*size(data(k).img,2),1:dy:dy*size(data(k).img,1));
quiver(x,y,u1,u2,'AutoScale','off'); hold on;
quiver(x,y,v2,v2,'AutoScale','off');
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

%% Displaying the Eigen values and eigen vectors of the image finite difference implemntation
hessImp = 2;
k = 4;
figure;
imagesc(data(k).img); colormap gray; hold on;
u1 = zeros(size(data(k).img));
u2 = zeros(size(data(k).img));
v2 = zeros(size(data(k).img));
v2 = zeros(size(data(k).img));
% extracting the eigen vectors
for j = 1:size(data(k).img,1)
    for i = 1:size(data(k).img,2)
        u1(j,i) = data(1).hessian(hessImp).EigVec{j,i}(1,1);
        u2(j,i) = data(k).hessian(hessImp).EigVec{j,i}(2,1);
        Eu(j,i) = data(k).hessian(hessImp).EigValMatrix{j,i}(1,1);
        v2(j,i) = data(k).hessian(hessImp).EigVec{j,i}(1,2);
        v2(j,i) = data(k).hessian(hessImp).EigVec{j,i}(2,2);
        Ev(j,i) = data(k).hessian(hessImp).EigValMatrix{j,i}(2,2);
    end
end


[x,y] = meshgrid(1:dx:dx*size(data(k).img,2),1:dy:dy*size(data(k).img,1));
quiver(x,y,u1,u2,'AutoScale','off'); hold on;
quiver(x,y,v2,v2,'AutoScale','off');
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