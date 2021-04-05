// The workflow used by Zhao is as following
// 1. Z crop
// 1.2 convert to 8-bit
// 2. denoise
// 3. sample crop (tighter crop)
// 4. threshold
// 5. Morphological dilation

close("*");
// load image sequence
//imageDirectories = newArray("0_degree","6_degree","12_degree","18_degree","24_degree","30_degree");
//currentDir = imageDirectories[0];

// allows for showing messages to abort the workflow midway
showAbortMessage = true;


imageName = "0_degree"; // this must be modified in the following line. 
run("Image Sequence...", "dir=[/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/data/rotary/images_FL-I/original/18_degree/] sort");

originalImageName = getInfo("image.title");
checkAbortability(showAbortMessage,originalImageName+" loaded. ");


// set the units to pixels
Stack.setXUnit("pixel");
run("Properties...", "pixel_width=1 pixel_height=1 voxel_depth=1");
// flip z
run("Flip Z");
// convert 8-bit to speed up operatoins
// run("8-bit");
// crop to sample
// run("TransformJ Crop", "x-range=168,677 y-range=131,640 z-range=172,791"); // this is the tight fit that I originally decided to use
run("TransformJ Crop", "x-range=128,717 y-range=91,680 z-range=172,791");

saveoutput(originalImageName,"_cropped2");
// denoise
//if (bitDepth() == 8){
//	run("Non-local Means Denoising", "sigma=1.09 smoothing_factor=1 stack");	
//} else {
//	run("Non-local Means Denoising", "sigma=280 smoothing_factor=1 stack");
//}

//saveoutput(originalImageName+"_cropped","_denoised");


// threshold: fracture and background is black=0 and rock is white=255 (1 in 8-bit)
//applyThreshold(bitDepth(),imageName);


//saveoutput(originalImageName+"_cropped"+"_denoised","_threshold");
// morphological pore-filling


// this function is used to prompt the user to save the output of the intermediate steps
function saveoutput(name,suffix){
	//selectWindow(name);
	Dialog.create("Saving output");
	Dialog.addCheckbox("Save stack in folder name:"+name+"_"+suffix+"?", false);
	Dialog.addMessage("If box yes, choose parent directory.");
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

function checkAbortability(showAbortMessage,message){
	if (showAbortMessage)
	showMessageWithCancel("Aborting point",message+"Press 'ok' to continue, or 'cancel' to stop here.");
}

function applyThreshold(bit,imageName){
	if (imageName == "0_degree"){
		index = 0;
	} else if (imageName == "6_degree"){
		index = 1;
	} else if (imageName == "12_degree"){
		index = 2;
	} else if (imageName == "18_degree"){
		index = 3;
	} else if (imageName == "24_degree"){
		index = 4;
	} else if (imageName == "30_degree"){
		index = 5; 
	} else {
		exit("Image name is not recognized");
	}
	// using the published threshold values
	thresholdMin16bit = newArray(18685,17700,17755,17600,19578,16058);
	thresholdMax16bit = newArray(21200,20300,20449,20560,22453,19077);
	thresholdMin08bit = newArray(thresholdMin16bit.length);
	thresholdMax08bit = newArray(thresholdMax16bit.length);
	
	if (bit == 8) {
		thresholdMin = round(Math.pow(2, 8)/Math.pow(2, 16)*thresholdMin16bit[index]);
		thresholdMax = round(Math.pow(2, 8)/Math.pow(2, 16)*thresholdMax16bit[index]);
	} else {
		thresholdMin = thresholdMin16bit[index];
		thresholdMax = thresholdMax16bit[index];
	}
	setAutoThreshold("Default no-rest stack"); // this line might not be needed
	setThreshold(thresholdMin, thresholdMax);
	waitForUser;
	run("Convert to Mask", "method=Default background=Dark calculate black"); // read more here https://imagej.net/docs/guide/146-29.html#toc-Subsection-29.8
}
