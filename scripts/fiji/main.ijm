// author: Omar Alamoudi
// date created: Feb 22, 2021

// References
// Links on how certain aspects of this script work are below
// - scripting in general: https://imagej.net/Scripting_basics.html
// - script parameters (#@ ... ): https://imagej.net/Script_Parameters.html#Default_values
// ----------------------------------------------------------

// This is the entry point for the workflow
run("script:/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/scripts/fiji/my fiji instance preference.ijm"); 
close("*");

// load multiple files
//dirList = getFileList("/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/data/rotary/images_FL-I/");
//print(dirList[4]);
//debug(dirList);

// Choosing the directory containing input image sequece. 
useDefaultDir = true; 
if (!useDefaultDir){
	// Uncomment the line below to use scripting paramters approach
//#@ File (label="", style="directory", value="/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/data/rotary/images_FL-I") imageDir	
	imageDir = getDirectory("Choose directory with image sequence"); 
} else {
	imageDir = "/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/data/rotary/images_FL-I/0_degree";
}

// importing the image sequence
run("Image Sequence...", "open=[&imageDir] sort use");

// setting image properties
Stack.setXUnit("pixel");
Stack.setYUnit("pixel");
Stack.setZUnit("pixel");
run("Properties...", "channels=1 slices=1024 frames=1 pixel_width=1 pixel_height=1 voxel_depth=1");

// 
halfImageWidth 	= getWidth()/2;
halfIimageHeight = getHeight()/2;

// open orthogonal views
// run("Orthogonal Views");

// set the zoom of the image so I can fit other views well
// run("Set... ", "zoom=70 x=&halfImageWidth y=&halfImageWidth");

// display the middle slice
fractureSlice = 595; // determined by insection. Fractures starts showing on on slice # 580 and ends on slice # 615 of the 0_degree image set. So the average is 597.5. I chose 595. 
setSlice(fractureSlice);


