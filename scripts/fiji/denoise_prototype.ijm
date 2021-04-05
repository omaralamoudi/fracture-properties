// author: 			Omar Alamoudi
// date updated: 	March 18, 2021
// descriptoin: 	determining the proper parameters using the non-local mean denoising filter 
// state: 			complete
// link: 			https://imagej.net/Non_Local_Means_Denoise

// close all windows
//close("*"); 

// load image stack
run("Image Sequence...", "dir=[/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/data/rotary/images_FL-I/processed/1_cropped/18_degree_super-crop/] sort");

// duplicate it
run("Duplicate...", "duplicate");

// run denoise on duplicate
run("Non-local Means Denoising", "sigma=280 smoothing_factor=1 stack");

// concatenate to compare
run("Concatenate...", "all_open open");

// zoom in
for (i = 0; i < 4; i++) {
	run("In [+]");
}

// RESULT
// when the image is 16-bit, the value for sigma=280 which is equivalent to 1.09 in 8-bit