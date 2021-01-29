clear variables; home
InitColormaps();

if (ispc)
    cd 'C:\Users\oma385\Dropbox\GraduateSchool\PhD\CourseWork\Spring2019\3DAnalysisOfVolumetricData\Project\scripts'
    addpath(genpath('C:\Users\oma385\Dropbox\GraduateSchool\PhD\CourseWork\Spring2019\3DAnalysisOfVolumetricData\Project'));
else
    cd '/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/CourseWork/Spring2019/3DAnalysisOfVolumetricData/Project/scripts';
    addpath(genpath('/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/CourseWork/Spring2019/3DAnalysisOfVolumetricData/Project'));
end

%%
generateSynthFracs3D_v2;

% clear fig1 fig2 dim filterSize fracAps imgDim SNR traverseXCoor
pause(0.1); close all;
clc
%%  COMPUTING TRADITIONAL DERIVATIVE OPERATIONS
% defining the pixle/voxel dimentions

dx = 1;
dy = 1;
dz = 1;

% computing the first and second derivative
for k = 1:4
    [img(k).ddx, img(k).ddy, img(k).ddz]            = gradient(double(img(k).img),dx,dy,dz);
    [img(k).ddxddx, img(k).ddyddx, img(k).ddzddx]   = gradient(img(k).ddx,dx,dy,dz);
    [img(k).ddxddy, img(k).ddyddy, img(k).ddzddy]   = gradient(img(k).ddy,dx,dy,dz);
    [img(k).ddxddz, img(k).ddyddz, img(k).ddzddz]   = gradient(img(k).ddz,dx,dy,dz);
end

clear k;
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
sigma = 0.5*fracAps;
hSizeOdd = 19;
hSizeEven = (hSizeOdd-1);
tol = 0;
directory = '../Presentation/figures/hessian_results/';
disp("Computing the Hessian using convolutional scheme ...");
tic
finalTol = 0.60 ;
% figure 
% this loop is for all 4 synthetic images
for k = 1:4
    img(k).hessian(2).finalResult.A_s = zeros(size(img(k).img));
    % this loop is for different gaussian scallings (s);
    for  s = 1:length(sigma)
        % aplying either an odd or even node number filter
        if mod(fracAps(s),2) == 0
            hsize = hSizeEven;
        else
            hsize = hSizeOdd;
        end
            
            img(k).hessian(2).result(s).s = sigma(s);
            img(k).hessian(2).result(s).aperture = fracAps(s);
            img(k).hessian(2).result(s).hSize = hsize;

            img(k).hessian(2).matrix = cell(size(img(k).img));
            img(k).hessian(2).EigVec = cell(size(img(k).img));
            img(k).hessian(2).EigValMatrix = cell(size(img(k).img));
            img(k).hessian(2).EigValSorted = cell(size(img(k).img));
            
            [img(k).hessian(2).matrix,~,~,~,~] = ComputeHessian3D(img(k).img,2,hsize,sigma(s));
           
            for m = 1:size(img(k).img,3)
                for j = 1:size(img(k).img,1)
                    for i = 1:size(img(k).img,2)
                        img(k).hessian(2).magnitude(j,i,m)  = ComputeTensorMag(img(k).hessian(2).matrix{j,i,m});
                        [img(k).hessian(2).EigVec{j,i,m},img(k).hessian(2).EigValMatrix{j,i,m}] = eig(img(k).hessian(2).matrix{j,i,m});
                        img(k).hessian(2).EigValSorted{j,i,m} = sortEigenValues(img(k).hessian(2).EigValMatrix{j,i,m});
                        
                        img(k).hessian(2).result(s).A_s(j,i,m) =  real(img(k).hessian(2).EigValSorted{j,i,m}(3) - abs(img(k).hessian(2).EigValSorted{j,i,m}(2)) - abs(img(k).hessian(2).EigValSorted{j,i,m}(1)));
                        
                        % modifying computing A_s
                        if img(k).hessian(2).result(s).A_s(j,i,m) <= tol
                            img(k).hessian(2).result(s).A_s(j,i,m) = 0;
                        end
                        
                    end
                end
            end
            % normalize
            img(k).hessian(2).result(s).B_s = img(k).hessian(2).result(s).A_s ./ max(max(max(img(k).hessian(2).result(s).A_s)));
            %img(k).hessian(2).result(s).C_s = img(k).hessian(2).result(s).B_s ./ max(max(max(img(k).hessian(2).result(s).B_s)));
            % logical
            img(k).hessian(2).result(s).C_s = double(img(k).hessian(2).result(s).B_s >= (max(max(max(img(k).hessian(2).result(s).B_s))) * finalTol));
            %img(k).hessian(2).result(s).D_s = double(img(k).hessian(2).result(s).C_s >= (max(max(max(img(k).hessian(2).result(s).C_s))) - finalTol));
            
            % assembling the final result
            % img(k).hessian(2).finalResult.A_s = double(img(k).hessian(2).finalResult.A_s) + double(img(k).hessian(2).result(s).D_s);
            img(k).hessian(2).finalResult.A_s = double(img(k).hessian(2).finalResult.A_s) + double(img(k).hessian(2).result(s).C_s);
%             a = img(k).hessian(2).finalResult.A_s(:,:,2)/(max(max(max(img(k).hessian(2).finalResult.A_s(:,:,2)))));
%             imagesc(a); colormap gray; colorbar;
%             if s == length(sigma)
%                 SaveResults(img(k).hessian(2).finalResult.A_s, fracAps,img(k).abreriation);
%             end
%             title(['image \# ',num2str(k), ', A = ',num2str(fracAps(s))]);
%             %keyboard
%             
            % keyboard
            % display a result of the last steps
            if k == 1 || k == 4
                slice = 2;
                commTitle = ['s = ',num2str(sigma(s)), ', Aperture = ', num2str(sigma(s)*2),', Frac (',num2str(s),' of ',num2str(length(sigma)),'), hsize = ',num2str(hsize)];
                figure('Position',[10 100 1850 450]);
                subplot(1,4,1);
                imagesc(img(k).hessian(2).result(s).A_s(:,:,slice));
                ax = gca;
                ax.XTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                colormap(gray);
                colorbar
                xlabel('$A_s$');
                
                drawnow
                subplot(1,4,2);
                imagesc(img(k).hessian(2).result(s).B_s(:,:,slice));
                ax = gca;
                ax.XTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                colorbar
                %title(commTitle,'FontSize',14);
                drawnow
                xlabel('$B_s$');
                
                subplot(1,4,3);
                imagesc(img(k).hessian(2).result(s).C_s(:,:,slice));ax = gca;
                ax.XTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                colorbar
                xlabel('$C_s$');
                drawnow
                
                subplot(1,4,4);
                imagesc(img(k).hessian(2).finalResult.A_s(:,:,slice));ax = gca;
                ax.XTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(img(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                ax.CLim = [0 length(sigma)];
                colorbar
                xlabel('Cumulative Result');
                drawnow
                
                
                fixFigure(gcf,14);
                suptitle(commTitle);
                print(strcat(directory, img(k).abreriation,', ',commTitle,'.png'),'-dpng');
                print(strcat(directory, img(k).abreriation,',hsize = ',num2str(hsize),', s = ',num2str(sigma(s)), ', Apr = ', num2str(sigma(s)*2),'.png'),'-dpng');
                % keyboard
                % close(gcf);
            end
        %}
        % keyboard
    end
    disp(["Hessian computaion for Image # " + num2str(k) + " completed."]);
end
toc

disp("Computing the Hessian using convolutional scheme COMPLETED");
keyboard
%% displaying the final results
for k = 1:4
   % figure 
   img(k).hessian(2).finalResult.A_s_norm = img(k).hessian(2).finalResult.A_s / (max(max(max(img(k).hessian(2).finalResult.A_s))));
   img(k).hessian(2).finalResult.A_s_norm_inv = (1 - img(k).hessian(2).finalResult.A_s_norm) ;
   Img(k).img = img(k).hessian(2).finalResult.A_s_norm_inv;
   Img(k).description = [char(img(k).abreriation),' Result'];
end

%% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,1);
ShowImage3D(Img(1));

subplot(2,2,2);
ShowImage3D(Img(2));

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
