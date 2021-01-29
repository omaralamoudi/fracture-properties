clear variables; home
InitColormaps();

if (ispc)
    cd 'C:\Users\oma385\Dropbox\GraduateSchool\PhD\CourseWork\Spring2019\3DAnalysisOfVolumetricData\Project\scripts'
    addpath(genpath('C:\Users\oma385\Dropbox\GraduateSchool\PhD\CourseWork\Spring2019\3DAnalysisOfVolumetricData\Project'));
else
    cd '/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/CourseWork/Spring2019/3DAnalysisOfVolumetricData/Project/scripts';
    addpath(genpath('/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/CourseWork/Spring2019/3DAnalysisOfVolumetricData/Project'));
end
clc
%% Loading data
img.img(:,:,1) = imread('../Data/crop_1014.tiff');
img.img(:,:,2) = imread('../Data/crop_1015.tiff');
img.img(:,:,3) = imread('../Data/crop_1016.tiff');
%%  COMPUTING TRADITIONAL DERIVATIVE OPERATIONS
% defining the pixle/voxel dimentions

dx = 1;
dy = 1;
dz = 1;
k = 1;
% computing the first and second derivative
    [img(k).ddx, img(k).ddy, img(k).ddz]            = gradient(double(img(k).img),dx,dy,dz);
    [img(k).ddxddx, img(k).ddyddx, img(k).ddzddx]   = gradient(img(k).ddx,dx,dy,dz);
    [img(k).ddxddy, img(k).ddyddy, img(k).ddzddy]   = gradient(img(k).ddy,dx,dy,dz);
    [img(k).ddxddz, img(k).ddyddz, img(k).ddzddz]   = gradient(img(k).ddz,dx,dy,dz);

%% All Hessian Operations
% The structure of the hessian shown below is as following. A 4D array was
% created as following hessian(i,j,k,l), where i, and j correspond to the
% pixel, and k, and l correspond to the hessian index.

%{

disp("Computing the Hessian using finite difference scheme ...");
tic
for k = 1:4
    % Finite difference Hessian Implementation
    img(k).hessian(1).matrix = cell(size(img(k).img));
    img(k).hessian(1).EigVec = cell(size(img(k).img));
    img(k).hessian(1).EigValMatrix = cell(size(img(k).img));
    img(k).hessian(1).EigValSorted = cell(size(img(k).img));
    for m = 1:size(img(k).img,3)
        for j = 1:size(img(k).img,1)
            % loop along the x-direction first
            for i = 1:size(img(k).img,2)
                img(k).hessian(1).matrix{j,i,m} = [img(k).ddxddx(j,i,m),img(k).ddxddy(j,i,m),img(k).ddxddz(j,i,m);...
                    img(k).ddyddx(j,i,m),img(k).ddyddy(j,i,m),img(k).ddyddz(j,i,m);...
                    img(k).ddzddx(j,i,m),img(k).ddzddy(j,i,m),img(k).ddzddz(j,i,m)];
                img(k).hessian(1).magnitude(j,i,m)  = ComputeTensorMag(img(k).hessian(1).matrix{j,i,m});
                [img(k).hessian(1).EigVec{j,i,m},img(k).hessian(1).EigValMatrix{j,i,m}] = eig(img(k).hessian(1).matrix{j,i,m});
            end
        end
    end
    disp(["Hessian computaion for Image # " + num2str(k) + " completed."]);
end
toc
disp("Computing the Hessian using finite difference scheme COMPLETED");

%}
%% Convolution Hessian implementation
fracAps = [1,2,3,4,6];      % simpler for testign code
sigma = 0.5*fracAps;
hSizeOdd = 19;
hSizeEven = (hSizeOdd-1);
tol = 0;
% directory = '../Presentation/figures/hessian_results/';
disp("Computing the Hessian using convolutional scheme ...");
tic
finalTol = 0.4 ;
figure
c = 1;
Size = size(img.img);
maxSize = Size(1)*Size(2)*Size(3);
% this loop is for all 4 synthetic images
for k = 1
    img(k).hessian.finalResult.A_s = zeros(size(img(k).img));
    % this loop is for different gaussian scallings (s);
    for  s = 1:length(sigma)
        % aplying either an odd or even node number filter
        disp(['Operation for s = ', num2str(s),' started ..']);
        if mod(fracAps(s),2) == 0
            hsize = hSizeEven;
        else
            hsize = hSizeOdd;
        end
            
            img(k).hessian.result(s).s = sigma(s);
            img(k).hessian.result(s).aperture = fracAps(s);
            img(k).hessian.result(s).hSize = hsize;

            img(k).hessian.matrix = cell(size(img(k).img));
            img(k).hessian.EigVec = cell(size(img(k).img));
            img(k).hessian.EigValMatrix = cell(size(img(k).img));
            img(k).hessian.EigValSorted = cell(size(img(k).img));
            
            [img(k).hessian.matrix,~,~,~,~] = ComputeHessian3D(img(k).img,2,hsize,sigma(s));
           
            for m = 1:size(img(k).img,3)
                for j = 1:size(img(k).img,1)
                    for i = 1:size(img(k).img,2)
                        img(k).hessian.magnitude(j,i,m)  = ComputeTensorMag(img(k).hessian.matrix{j,i,m});
                        [img(k).hessian.EigVec{j,i,m},img(k).hessian.EigValMatrix{j,i,m}] = eig(img(k).hessian.matrix{j,i,m});
                        img(k).hessian.EigValSorted{j,i,m} = sortEigenValues(img(k).hessian.EigValMatrix{j,i,m});
                        
                        img(k).hessian.result(s).A_s(j,i,m) =  real(img(k).hessian.EigValSorted{j,i,m}(3) - abs(img(k).hessian.EigValSorted{j,i,m}(2)) - abs(img(k).hessian.EigValSorted{j,i,m}(1)));
                        
                        if img(k).hessian.result(s).A_s(j,i,m) > tol
                            img(k).hessian.result(s).B_s(j,i,m) = img(k).hessian.result(s).A_s(j,i,m);
                        else
                            img(k).hessian.result(s).B_s(j,i,m) = 0;
                        end
                        
                        c = c + 1;
                        if mod(c,1000) == 0
                        disp([num2str(c),' of ', num2str(maxSize), ' voxels are done. s = ',num2str(s),' of ', num2str(length(s))]);
                        end
                    end
                end
            end
            % normalize
            img(k).hessian.result(s).C_s = img(k).hessian.result(s).B_s ./ max(max(max(img(k).hessian.result(s).B_s)));
            % logical
            img(k).hessian.result(s).D_s = double(img(k).hessian.result(s).C_s >= (max(max(max(img(k).hessian.result(s).C_s))) - finalTol));
            
            % assembling the final result
            
            img(k).hessian.finalResult.A_s = double(img(k).hessian.finalResult.A_s) + double(img(k).hessian.result(s).D_s);
%             
%             if s == length(sigma)
%                 SaveResults(img(k).hessian.finalResult.A_s, 'Data');
%             end
            %keyboard
            
            % keyboard
            % display a result of the last steps
            %{
            if k == 1
                slice = 2;
                commTitle = ['s = ',num2str(sigma(s)), ', Apr = ', num2str(sigma(s)*2),', hsize = ',num2str(hsize)];
                figure('Position',[100 100 1600 400]);
                subplot(1,3,1);
                imagesc(img(k).hessian.result(s).A_s(:,:,slice));      % real was added because I got an error showing the image ofr img(3).hessian.result(1).A_s(:,:,2)
                colormap(gray);
                colorbar
                title(['$A_s$, ',commTitle]);
                drawnow
                subplot(1,3,2);
                imagesc(img(k).hessian.result(s).B_s(:,:,slice));
                %colormap(cm_inferno);
                colorbar
                title(['$B_s$, ',commTitle]);
                drawnow
                subplot(1,3,3);
                imagesc(img(k).hessian.result(s).C_s(:,:,slice));
                %colormap(cm_inferno);
                colorbar
                title(['$\bar{B_s}$, ',commTitle]);
                drawnow
                print(strcat(directory, img(k).abreriation,', ',commTitle,'.png'),'-dpng');
                print(strcat(directory, img(k).abreriation,',hsize = ',num2str(hsize),', s = ',num2str(sigma(s)), ', Apr = ', num2str(sigma(s)*2),'.png'),'-dpng');
                keyboard
                % close(gcf);
            end
        %}
            disp(['Operation for s = ', num2str(s),' ended']);
    end
    disp(["Hessian computaion for Image # " + num2str(k) + " completed."]);
end
toc

disp("Computing the Hessian using convolutional scheme COMPLETED");

%% displaying the final results
for k = 1
   % figure 
   img(k).hessian.finalResult.A_s_norm = img(k).hessian.finalResult.A_s / (max(max(max(img(k).hessian.finalResult.A_s))));
   img(k).hessian.finalResult.A_s_norm_inv = (1 - img(k).hessian.finalResult.A_s_norm) ;
   Img(k).img = img(k).hessian.finalResult.A_s_norm_inv;
   Img(k).description = 'Result from Data';
end
% keyboard

%% export results
for i = 1:3
imwrite(Img(1).img(:,:,i),['output\results\data\Results_Data_Inverted_',num2str(i),'.tif']);
end

for i = 1:3
imwrite(img(1).hessian.finalResult.A_s(:,:,i),['output\results\data\Results_Data_',num2str(i),'.tif']);
end

for i = 1:3
imwrite(img(1).hessian.finalResult.A_s_norm(:,:,i),['output\results\data\Results_Data_Normalized',num2str(i),'.tif']);
end

%% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,[1,3]);
ShowImage3D(Img(1));


% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(Img(1).img,1);
traverseXCoor = floor(dim/2);
ShowProfile3D(Img(1),traverseXCoor); 

subplot(2,2,4);
dim = size(Img(2).img,1);
traverseXCoor = floor(dim/2);
ShowProfile3D(Img(2),traverseXCoor); 

print('..\Presentation\figures\HessianResultsSFI_N','-dpng');

% blurred images
fig2 = figure('Position',[100 100 800 800],'Name','Blured Images');
subplot(2,2,1);
ShowImage3D(Img(3));

subplot(2,2,2);
ShowImage3D(Img(4));

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(Img(3).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(Img(3),traverseXCoor); 

subplot(2,2,4);
dim = size(img(4).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(Img(4),traverseXCoor);
print('..\Presentation\figures\HessianResultsSBFI_N','-dpng');
