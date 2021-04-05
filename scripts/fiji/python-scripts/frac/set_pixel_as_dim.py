def set_props(img):
    img.getCalibration().setXUnit("pixel");
    img.getCalibration().setYUnit("pixel");
    img.getCalibration().setZUnit("pixel");
    IJ.run(img, "Properties...", "channels=1 slices="+str(img.getStackSize())+" frames=1 pixel_width=1 pixel_height=1 voxel_depth=1 global");