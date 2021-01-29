function ShowProfile(img,traverseXCoor)
    % This function to plot values of a grayscale image along a specified
    % line that traverses an image.
    %
    % This function was written for my class project. 
    %
    % Written by: Omar Alamoudi
    % Date: April 28, 2019
    
    dim = size(img.img,1); 
    plot(1:dim,img(1).img(:,traverseXCoor),'r','LineWidth',1.5);
    ylim([-.5 2]);
    xlim([1 dim]);
    xticks([1 dim]);
    xlabel("Distance Along Traverse [pixel]"); 
    ylabel("Image Intensity");
    axis square
end