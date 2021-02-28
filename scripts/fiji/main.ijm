// author: Omar Alamoudi
// date created: Feb 22, 2021

// References
// Links on how certain aspects of this script work are below
// - scripting in general: https://imagej.net/Scripting_basics.html
// - script parameters (#@ ... ): https://imagej.net/Script_Parameters.html#Default_values
// ----------------------------------------------------------

// This is the entry point for the workflow

close("*");
runMacro("/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/scripts/fiji/my fiji instance preferences.ijm");

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
run("Image Sequence...", "open=[&imageDir] sort");

// setting image properties
Stack.setXUnit("pixel");
Stack.setYUnit("pixel");
Stack.setZUnit("pixel");
run("Properties...", "channels=1 slices=1024 frames=1 pixel_width=1 pixel_height=1 voxel_depth=1 global");

// Zooming 
//halfImageWidth 	= getWidth()/2;
//halfIimageHeight = getHeight()/2;

// open orthogonal views
// run("Orthogonal Views");

// set the zoom of the image so I can fit other views well
// run("Set... ", "zoom=70 x=&halfImageWidth y=&halfImageWidth");


// Flip the image in the Z direction
run("Flip Z");

// Display the fracture slice
fractureSlice = 430; // determined by insection. Fractures starts showing on on slice # 412 and ends on slice # 448 of the 0_degree image set. So the average is 430. 
setSlice(fractureSlice);

totalNSlices = 620;  // based on the published work

// Cropping. Determining the subvolume used

// approximate published dimentions
distanceFromFractureToTopSlice = 6.46; // [mm]
distanceFromFractureToBottomSlice = 9.06; // [mm]

topSlice 	= fractureSlice - Math.floor(distanceFromFractureToTopSlice*1000/25);
bottomSlice = fractureSlice + Math.floor(distanceFromFractureToBottomSlice*1000/25); 
//print("top slice = ", topSlice);
print("Top slice = "+topSlice);
print("Frac slice = "+fractureSlice);
print("Bottom slice = "+bottomSlice);
print("n slices = "+(bottomSlice-topSlice));

// Defining the ROI
setSlice(bottomSlice);
makeOval(168, 655, 700, 700);
selection


// 3D cropping documentation: https://www.longair.net/edinburgh/imagej/three-pane-crop/