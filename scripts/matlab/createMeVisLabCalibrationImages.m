function createMeVisLabCalibrationImages()
    targetDir = uigetdir;
    a2d = zeros(3,3,'uint8'); 
    a2d(2,2) = intmax('uint8');

    imwrite(a2d,[targetDir,filesep,'clibrationimage2d.tif']);
    
    a3d = zeros(3,3,3,'uint8');
    a3d(2,2,2) = intmax('uint8');
    for i = 1:3
        imwrite(a3d(:,:,i),[targetDir,filesep,'/3d/clibrationimage3d_',num2str(i),'.tif']);
    end
    

    
end