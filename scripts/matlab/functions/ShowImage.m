function ShowImage(img,fontSize)
    % this function just to show the image I would like to show with a few
    % additional parameters that I would like to keep consistent.
    %
    % This function was written for my class project.
    %
    % Written by: Omar Alamoudi
    % Date: April 28, 2019
    
    imshow(img.img); hold on;
    ax = gca;
    
    ax.FontSize = fontSize; 
    title(img.description);
    axis('on','image');
    xLength = size(img.img,2);
    yLength = size(img.img,1); 
    xticks([1, xLength]);
    yticks([1, yLength]);
    c = colorbar;
    c.Location = 'east';
    c.Ticks = [0 1];
    
    plot([floor(xLength/2) floor(xLength/2)],[1 yLength],'r','LineWidth',1.5,...
        'DisplayName','Traverse');
    lgd = legend;
    lgd.Location = 'northwest';
end