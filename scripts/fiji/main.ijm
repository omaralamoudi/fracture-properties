// author: Omar Alamoudi
// date created: Feb 22, 2021

// References
// Links on how certain aspects of this script work are below
// - scripting in general: https://imagej.net/Scripting_basics.html
// - script parameters (#@ ... ): https://imagej.net/Script_Parameters.html#Default_values
// ----------------------------------------------------------

// This is the entry point for the workflow

close('*');

askUserForWorkflowDirecotory = false;

if (askUserForWorkflowDirecotory) {
	workflowDirectory = getDirectory("Choose workflow directory:");
} else {
	workflowDirectory = "/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/scripts/fiji/";
}

runMacro(workflowDirectory+"my fiji instance preferences.ijm");
runMacro(workflowDirectory+"testing runMacro.ijm",workflowDirectory+" "+askUserForWorkflowDirecotory);
// load multiple files
askUser 			= false;
imageDirectory 		= chooseImageDirectory();

load(imageDirectory);
originalImageName 	= getInfo("image.title");

 // create a workflow picker
moduleLabels 	= newArray("Flip Z","convert 8-bit","crop","supercrop","denoise","threshold");
defaults     	= newArray( true,    false,          true,  false,      false,    false );
pefromWorkflow 	= newArray(moduleLabels.length);
pefromWorkflow 	= chooseModules(moduleLabels,defaults);


if(pefromWorkflow[0])
	flipZ(useDefaults);	

if(pefromWorkflow[1])
	convert8bit(originalImageName);
	
if(pefromWorkflow[2])
	crop(originalImageName);
	
if(pefromWorkflow[3])
	supercrop(originalImageName);
	
if(pefromWorkflow[4])
	denoise(originalImageName+"_super-cropped");
	
if(pefromWorkflow[5])
	applyThreshold(nameOfInputImage)

//enhanceImage();
//displayFractureImage();


// Defining the ROI





// functions
function chooseModules(moduleLabels,defaults){
	Dialog.create("Choose workflows:");
	Dialog.addMessage("Choose module to perform:");
	defaults = newArray(true,false,true,false,false,false);
	Dialog.addCheckboxGroup(6, 1, moduleLabels, defaults);
	Dialog.show();
	len = moduleLabels.length;
	performWorkflow = newArray(len);
	for (i = 0; i++; i < len){
		performWorkflow[i] = Dialog.getCheckbox();
	}
	return performWorkflow;
}

function chooseImageDirectory(){
	// Choosing the directory containing input image sequece. 
	imageDir = getDirectory("Choose directory with image sequence"); 
//	imageDir = "/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/data/rotary/images_FL-I/0_degree";
	return imageDir;
}

function load(dir){
	// importing the image sequence and convert it to 8-bit
	//showMessage("Allow some time for the image sequence to be loaded. Press ok to proceed.");
	setOption("ScaleConversions", true);
	run("Image Sequence...", "dir=[&dir] sort");
	// setting image properties
	Stack.setXUnit("pixel");
	Stack.setYUnit("pixel");
	Stack.setZUnit("pixel");
	run("Properties...", "channels=1 slices=1024 frames=1 pixel_width=1 pixel_height=1 voxel_depth=1 global");
}

function flipZ(askUser){
	if(askUser){
		flip = false;
		Dialog.createNonBlocking("Flipping along the z-axis");
		Dialog.addMessage("Inspect the image set (sequence) for the need to flip the image along the z-axis");
		Dialog.addCheckbox("Flip Z?", flip);
		Dialog.show();
		needsFlipping = Dialog.getCheckbox();	
	} else {
		needsFlipping = true; 
	}
	
	if (needsFlipping){
		// Flip the image in the Z direction
		run("Flip Z");	
	}
}

function enhanceImage(){
	run("Enhance Contrast", "saturated=0.25");
}

// 3D cropping documentation: https://www.longair.net/edinburgh/imagej/three-pane-crop/
function crop(nameOfInputImage){
	run("TransformJ Crop", "x-range=168,677 y-range=131,640 z-range=172,791");
	saveoutput(nameOfInputImage,"_cropped");
}


function supercrop(nameOfInputImage){
	run("TransformJ Crop", "x-range=127,382 y-range=60,315 z-range=280,505");
	saveoutput(nameOfInputImage,"_super-cropped");
}

function convert8bit(nameOfInputImage){
	doConvert 	= true;
	doSave 		= false;
	Dialog.create("Convert to 8-bit");
	Dialog.addCheckbox("Convert to 8-bit", doConvert);
	Dialog.addCheckbox("Save output", doSave);
	Dialog.show();
	if (Dialog.getCheckbox()){
		run("8-bit");
	}
	if(Dialog.getCheckbox()){
		suffix = "_8-bit"
		saveoutput(nameOfInputImage,suffix);	
	}
		
}


// This function performs the denoising 
function denoise(nameOfInputImage){
	if (bitDepth() == 8)
		run("Non-local Means Denoising", "sigma=1.09 smoothing_factor=1 stack");
	else {
		run("Non-local Means Denoising", "sigma=280 smoothing_factor=1 stack");
	}
	suffix = "_denoised";
	saveoutput(nameOfInputImage,suffix);
}

function applyThreshold(nameOfInputImage){
	// using the published threshold values
	thresholdMin16bit = newArray(18685,17700,17755,17600,19578,16058);
	thresholdMax16bit = newArray(21200,20300,20449,20560,22453,19077);
	thresholdMin08bit = newArray(thresholdMin16bit.length);
	thresholdMax08bit = newArray(thresholdMax16bit.length);
	for (i = 0; i < thresholdMin16bit.length; i++) {
		thresholdMin08bit[i] = round(Math.pow(2, 8)/Math.pow(2, 16)*thresholdMin16bit[i]);
		thresholdMax08bit[i] = round(Math.pow(2, 8)/Math.pow(2, 16)*thresholdMax16bit[i]);
	}

	setAutoThreshold("Default stack"); // this line might not be needed
	setThreshold(18685, 21200);
	run("Convert to Mask", "method=Default background=Dark calculate black");

	
	suffix = "_threshold";
	saveoutput(nameOfInputImage,suffix);
}

function displayFractureImage(){
	// Display the fracture slice
	fractureSlice = 430; // determined by insection. Fractures starts showing on on slice # 412 and ends on slice # 448 of the 0_degree image set. So the average is 430. 
	setSlice(fractureSlice);
	
	totalNSlices = 620;  // based on the published work
	
	// Cropping. Determining the subvolume used
	
	// approximate published dimentions
	distanceFromFractureToTopSlice 		= 6.46; // [mm]
	distanceFromFractureToBottomSlice 	= 9.06; // [mm]
	
	topSlice 	= fractureSlice - Math.floor(distanceFromFractureToTopSlice*1000/25);
	bottomSlice = fractureSlice + Math.floor(distanceFromFractureToBottomSlice*1000/25); 
	
	print("Top slice = "+topSlice);
	print("Frac slice = "+fractureSlice);
	print("Bottom slice = "+bottomSlice);
	print("# slices = "+(bottomSlice-topSlice));
}

// this function is used to prompt the user to save the output of the intermediate steps
function saveoutput(name,suffix){
	//selectWindow(name);
	Dialog.create("Saving output");
	Dialog.addCheckbox("Save stack in folder name:"+name+"_"+suffix+"?", false);
	Dialog.addMessage("If box yes, choose parent directory. Otherwise, field below.");
	Dialog.addDirectory("Choose parent directory: ",getInfo("image.directory"));
	Dialog.addString("Choose suffix for saved directory "+name,suffix);
	Dialog.show();
	doSave 		= Dialog.getCheckbox();
	parentdir 	= Dialog.getString();
	suffix 		= Dialog.getString();
	
	if (doSave){
		newdir    	= name+suffix;
		newdirpath = parentdir+File.separator+newdir;
		File.makeDirectory(newdirpath);
		filenames = newdir+"_";
		run("Image Sequence... ", "format=TIFF name=&filenames digits=3 save=[&newdirpath]");	
	}
}
