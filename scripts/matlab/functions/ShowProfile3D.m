function ShowProfile3D(img,traverseXCoor)
    % This function to plot values of a grayscale image along a specified
    % line that traverses an image.
    %
    % This function was written for my class project. 
    %
    % Written by: Omar Alamoudi
    % Date: April 28, 2019
    slice = 2;
    dim = size(img.img(:,:,slice),1); 
    plot(1:dim,img(1).img(:,traverseXCoor,slice),'r','LineWidth',1.5);
    ylim([-.5 2]);
    yticks([-0.5:0.25:2]);
    xlim([1 dim]);
    xticks([1 dim]);
    xlabel("Distance Along Traverse [pixel]"); 
    ylabel("Image Intensity");
    axis square
end