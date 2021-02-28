close("*");
// choose directory that contains the 4 synthetic slices
#@ File (label="Choose directory containing image slices", style="directory") imageDirectory

imageName = File.getNameWithoutExtension(imageDirectory);

// import image sequence
run("Image Sequence...", "open=[&imageDirectory] sort");
// invert image
run("Invert", "stack");
// convert to binary image
run("Make Binary", "method=Huang background=Dark calculate black");
duplicateImageName = "dilated"; 
run("Duplicate...", "duplicate title=&duplicateImageName");

// dilate the duplicate
selectWindow(duplicateImageName);
run("Dilate", "stack");

imageCalculator("Subtract create stack", duplicateImageName,imageName);
run("Set Measurements...", "area mean min integrated display scientific redirect=None decimal=3");
run("Measure");
nMeasurementResults = getValue("results.count");
// using integrated density as a proxy for the uint8 value store for each pixel came from here: http://imagej.1557.x6.nabble.com/sum-of-pixels-values-td3701300.html

print("Surface area = " + (getResult("IntDen", (nMeasurementResults-1))/255) );