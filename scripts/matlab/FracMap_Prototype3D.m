%%  COMPUTING TRADITIONAL DERIVATIVE OPERATIONS
% defining the pixle/voxel dimentions

clear k;
%% All Hessian Operations
% The structure of the hessian shown below is as following. A 4D array was
% created as following hessian(i,j,k,l), where i, and j correspond to the
% pixel, and k, and l correspond to the hessian index.

%% Convolution Hessian implementation
sigma       = 0.5*fracAps;
hsizeOdd    = 19;
hsizeEven   = (hsizeOdd-1);
outputFigureDirectory = [figuresDirectory,'hessian_results/'];
if (not(exist(outputFigureDirectory,'dir'))), mkdir(outputFigureDirectory);end

disp("Computing the Hessian using convolutional scheme ...");

tic
result.Cs.gamma    = 0.70 ; 
implementation = 2; % 1: finite diff. 2: convolution
showIntermeidateResults = true;

% this loop is for all 4 synthetic images
for k = 1:4
    inputimage  = data(k).img;
    data(k).hessian(2).finalResult.A_s = zeros(size(inputimage));
    % this loop is for different gaussian scallings (s);
    for  s = 1:length(sigma)
        % aplying either an odd or even node number filter
        if mod(2*fracAps(s),2) == 0
            hsize = hsizeEven;
        else
            hsize = hsizeOdd;
        end
%             hsize = 2*ceil(2*sigma(s))+1;
            data(k).hessian(2).result(s).s           = sigma(s);
            data(k).hessian(2).result(s).aperture    = fracAps(s);
            data(k).hessian(2).result(s).hSize       = hsize;

            data(k).hessian(2).matrix       = cell(size(inputimage));
            data(k).hessian(2).EigVec       = cell(size(inputimage));
            data(k).hessian(2).EigValMatrix = cell(size(inputimage));
            data(k).hessian(2).EigValSorted = cell(size(inputimage));
            
            [data(k).hessian(2).matrix,~,~,~,~] = ComputeHessian3D(inputimage,implementation,hsize,sigma(s));
            
            % looping over every voxel
            for m = 1:size(inputimage,3)
                for j = 1:size(inputimage,1)
                    for i = 1:size(inputimage,2)
%                         data(k).hessian(2).magnitude(j,i,m)
%                         =
%                         ComputeTensorMag(data(k).hessian(2).matrix{j,i,m}); % this quantity is not used yet 
                        [data(k).hessian(2).EigVec{j,i,m},data(k).hessian(2).EigValMatrix{j,i,m}] = eig(data(k).hessian(2).matrix{j,i,m});
                        data(k).hessian(2).EigValSorted{j,i,m}                                   = sortEigenValues(data(k).hessian(2).EigValMatrix{j,i,m});                       
                        data(k).hessian(2).result(s).A_s(j,i,m)                                  = real(data(k).hessian(2).EigValSorted{j,i,m}(3) - abs(data(k).hessian(2).EigValSorted{j,i,m}(2)) - abs(data(k).hessian(2).EigValSorted{j,i,m}(1)));
                        
                        % modifying computing A_s
                        if data(k).hessian(2).result(s).A_s(j,i,m) <= 0
                            data(k).hessian(2).result(s).A_s(j,i,m) = 0;
                        end
                        
                    end
                end
            end
            % normalize
            data(k).hessian(2).result(s).B_s = data(k).hessian(2).result(s).A_s ./ max(data(k).hessian(2).result(s).A_s(:));
            
            % logical
%             data(k).hessian(2).result(s).C_s = (data(k).hessian(2).result(s).B_s > (max(data(k).hessian(2).result(s).B_s(:)) * finalTol));
            data(k).hessian(2).result(s).C_s = (data(k).hessian(2).result(s).B_s > (1 - result.Cs.gamma));
            
            % assembling the final result
            % data(k).hessian(2).finalResult.A_s = double(data(k).hessian(2).finalResult.A_s) + double(data(k).hessian(2).result(s).D_s);
            data(k).hessian(2).finalResult.A_s = double(data(k).hessian(2).finalResult.A_s) + double(data(k).hessian(2).result(s).C_s);
%             a = data(k).hessian(2).finalResult.A_s(:,:,2)/(max(max(max(data(k).hessian(2).finalResult.A_s(:,:,2)))));
%             imagesc(a); colormap gray; colorbar;
%             if s == length(sigma)
%                 SaveResults(data(k).hessian(2).finalResult.A_s, fracAps,data(k).abreviation);
%             end
%             title(['image \# ',num2str(k), ', A = ',num2str(fracAps(s))]);
%             %keyboard
%             
            % display a result of the last steps
            if k == 1 || k == 4 && showIntermeidateResults
                slice = 2;
                commTitle = [data(k).abreviation,': ', 's = ',num2str(sigma(s)), ', Aperture = ', num2str(sigma(s)*2),', Frac (',num2str(s),' of ',num2str(length(sigma)),'), hsize = ',num2str(hsize)];
                figure('Position',[10 100 1850 450]);
                subplot(1,4,1);
                imagesc(data(k).hessian(2).result(s).A_s(:,:,slice));
                ax = gca;
                ax.XTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                colormap(gray);
                colorbar
                xlabel('A_s');
                
                drawnow
                subplot(1,4,2);
                imagesc(data(k).hessian(2).result(s).B_s(:,:,slice));
                ax = gca;
                ax.XTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                colorbar
                %title(commTitle,'FontSize',14);
                drawnow
                xlabel('B_s');
                
                subplot(1,4,3);
                imagesc(data(k).hessian(2).result(s).C_s(:,:,slice));ax = gca;
                ax.XTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                colorbar
                xlabel('C_s');
                drawnow
                
                subplot(1,4,4);
                imagesc(data(k).hessian(2).finalResult.A_s(:,:,slice));ax = gca;
                ax.XTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),2)];
                ax.YTick = [1 size(data(k).hessian(2).result(s).A_s(:,:,slice),1)];
                axis equal; axis tight;
                ax.CLim = [0 length(sigma)];
                colorbar
                xlabel('Cumulative Result');
                drawnow
                
                
                fixFigure(gcf,fontSize);
                suptitle(commTitle);
                if saveFigures
                    print(strcat(outputFigureDirectory, data(k).abreviation,', ',commTitle,'.png'),'-dpng');
                    print(strcat(outputFigureDirectory, data(k).abreviation,',hsize = ',num2str(hsize),', s = ',num2str(sigma(s)), ', Apr = ', num2str(sigma(s)*2),'.png'),'-dpng');
                end
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

%% displaying the final results
for k = 1:4
   % figure 
   data(k).hessian(2).finalResult.A_s_norm = data(k).hessian(2).finalResult.A_s / (max(max(max(data(k).hessian(2).finalResult.A_s))));
   data(k).hessian(2).finalResult.A_s_norm_inv = (1 - data(k).hessian(2).finalResult.A_s_norm) ;
   Img(k).img = data(k).hessian(2).finalResult.A_s_norm_inv;
   Img(k).description = [char(data(k).abreviation),' Result'];
end

%% Displaying produced images
% Crisp images
fig1 = figure('Position',[100 100 800 800],'Name','Crisp Images');
subplot(2,2,1);
ShowImage3D(Img(1),fontSize);

subplot(2,2,2);
ShowImage3D(Img(2),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(Img(1).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(Img(1),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(Img(2).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(Img(2),traverseXCoor,fontSize); 

print([figuresDirectory,'HessianResultsSFI_N'],'-dpng');

% blurred images
fig2 = figure('Position',[100 100 800 800],'Name','Blured Images');
subplot(2,2,1);
ShowImage3D(Img(3),fontSize);

subplot(2,2,2);
ShowImage3D(Img(4),fontSize);

% plotting image profiles along the specifield traverse
subplot(2,2,3);
dim = size(Img(3).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(Img(3),traverseXCoor,fontSize); 

subplot(2,2,4);
dim = size(data(4).img,1);
traverseXCoor = floor(dim/2);
ShowProfile(Img(4),traverseXCoor,fontSize);
if saveFigures, print([figuresDirectory,'HessianResultsSBFI_N'],'-dpng');end
