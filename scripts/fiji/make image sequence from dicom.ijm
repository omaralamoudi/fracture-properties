// author: 		Omar Alamoudi
// updated on: 	March 18, 2021
// description: export dicom slices into tiff slices
// state: 		not complete.

resultPath = getNewPath(getInfo("image.title"),"_roi-specified","tif");

function getNewPath(oldname,suffix,ext){
	targetDirector 	= getDirectory("Choose where you want to save new image");
	newImagePath 	= targetDirector+oldname+suffix;
	if (newImagePath.contains("\.")){
		finalImagePath = replace(newImagePath,"\.","-");
	}
	return finalImagePath+"."+ext;
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