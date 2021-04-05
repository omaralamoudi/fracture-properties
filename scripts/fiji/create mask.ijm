
run("8-bit");
// Finding connected regions. I need to read more about this
// run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");

for(i = 1; i < nSlices()+1; i++){
	setSlice(i);
	floodFill(30, 550);
}

run("Dilate", "stack");
run("Erode", "stack");