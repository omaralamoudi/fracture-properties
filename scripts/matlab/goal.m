% This file contains what I would like the final script to look like


data = loadImageSeq('/Users/omaralamoudi/Dropbox/GraduateSchool/PhD/Projects/fracture properties/data/calibration images/synth images/synthetic2','tif');
s = [1,3,5,7]; % this is the 
result = mshff(data.image,s);