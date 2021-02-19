// This file contains how I prefer different settings to be when wofking with Fiji 

// Setting 3 appearance properties: 1. open images at 100%; 2. 16-bit range; 3. GUI scale
run("Appearance...", "open 16-bit=Automatic gui=1");

// Setting ROI manager preferences
setROIManager();













// FUNCTIONS
function setROIManager() { 
	roiManager("Show All with labels");
	roiManager("Associate", "true");
	roiManager("Centered", "false");
	roiManager("UseNames", "true");
	roiManager("Show All");
	selectWindow("ROI Manager");
	wait(200);
	run("Close")
}

