// loading the image sequence 
run("Image Sequence...", "dir=[C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/data/Bland/7A_fractured/8bitJPG/] sort");

// enhancing the appearance
setSlice(820);
run("Enhance Contrast", "saturated=0.35");
line_1FilePaht = "20220301/line_1.roi";

roiManager("open", line_1FilePaht);
//makeLine(380, 330, 416, 321);
run("Plot Profile");
//selectWindow("8bitJPG");
//selectWindow("Plot of 8bitJPG");
//selectWindow("8bitJPG");
//makeLine(351, 332, 416, 321);
//makeLine(351, 332, 442, 308);
//selectWindow("Plot of 8bitJPG");
//close();
//selectWindow("8bitJPG");
//run("Plot Profile");
//Plot.setStyle(1, "blue,#a0a0ff,2.0,Line");
//saveAs("Text", "C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/scripts/fiji/runs/7A_fractured/20220301/gaussian fit slice 820 line 1.txt");
//selectWindow("8bitJPG");
//run("ROI Manager...");
//roiManager("Add");
//roiManager("Select", 0);
//roiManager("Save", "C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/scripts/fiji/runs/7A_fractured/20220301/line 1.roi");
//roiManager("Deselect");
//roiManager("Delete");
//makeLine(378, 326, 378, 328);
//roiManager("Add");
//roiManager("Select", 0);
//roiManager("Deselect");
//roiManager("Delete");
//roiManager("Open", "C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/scripts/fiji/runs/7A_fractured/20220301/line 1.roi");
//roiManager("Select", 0);
//run("Close");
