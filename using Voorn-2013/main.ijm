// This script is to automate the work I need to perfurm using Voor 2013 workflow
// It is the entry point to the entire project

// Loading the data/images
run("Image Sequence...", "open=[/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/using Voorn-2013/input] sort use");

// Adjust the image viewing window
run("Original Scale");
run("View 100%");

// Setting the data set units
run("Properties...", "pixel_width=1 pixel_height=1 voxel_depth=1");

// Setting the conservative threshold
run("Threshold...");