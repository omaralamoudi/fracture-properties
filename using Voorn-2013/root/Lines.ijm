//Automatically generated file for control lines for multiscale Hessian analysis
arguments=getArgument();
avgmat=substring(arguments,0,5);
fracthresh=substring(arguments,5,10);
//____________________________________
makeRectangle( 0 , 0 , 184 , 179 );
run("Set...", "value=avgmat");
makeRectangle( 6 , 4 , 2 , 10 );
run("Set...", "value=fracthresh");
makeRectangle( 18 , 4 , 6 , 30 );
run("Set...", "value=fracthresh");
makeRectangle( 38 , 4 , 10 , 50 );
run("Set...", "value=fracthresh");
makeRectangle( 66 , 4 , 14 , 70 );
run("Set...", "value=fracthresh");
makeRectangle( 0 , 0 , 184 , 179 );		//Repetition required to pass box to main code
