// author:			omar alamoudi
// latest update: 	march 18, 2021
// description: 	clearing data outside of a single roi, i.e. apply to all slices
// state: 			complete

// clear roi manager
roiManager("reset"); 

// choose rois file
#@ File (label="Choose rois file:") roisFile
roiManager("open", roisFile);

nrois = RoiManager.size;
roiManager("select",0);
roiManager("remove slice info");
for (i = 0; i < 98; i++){
	setSlice(i+1);
	run("Clear Outside", "slice");
}

resultPath = getNewPath(getInfo("image.title"),"_roi-specified","tif");
save(resultPath);

function getNewPath(oldname,suffix,ext){
	targetDirector 	= getDirectory("Choose where you want to save new image");
	newImagePath 	= targetDirector+oldname+suffix;
	if (newImagePath.contains("\.")){
		finalImagePath = replace(newImagePath,"\.","-");
	}
	return finalImagePath+"."+ext;
}