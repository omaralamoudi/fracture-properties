% This file contains what I would like the final script to look like


data = loadimageseq('/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/Fracture Detection and Property Measurements/data/calibration images/synth images/synthetic2','tif');
s = [1,3,5,7]; % this is the 
result = mshff(data.image,s);