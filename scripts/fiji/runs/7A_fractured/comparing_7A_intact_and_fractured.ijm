close("*");
// loading the image sequence 
run("Image Sequence...", "dir=[C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/data/Bland/7A_fractured/8bitJPG/] sort");
rename("fractured");
setSlice(600);

makeLine(718, 325, 20, 431);


run("Image Sequence...", "dir=[C:/Users/oma385/Dropbox/GraduateSchool/PhD/Projects/fracture properties/data/Bland/7A/8bitJPG/] sort");
rename("intact");
setSlice(583);
makeLine(718, 325, 20, 431);


selectWindow("intact");
run("Rotate... ", "angle=174.7 grid=1 interpolation=Bilinear");
run("Translate...", "x=-3.2 y=-1.1 interpolation=None stack");