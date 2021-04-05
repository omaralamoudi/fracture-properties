//Automatically generated file for control lines for multiscale Hessian analysis
arguments=getArgument();
avgmat=substring(arguments,0,5);
fracthresh=substring(arguments,5,10);
//____________________________________
makeRectangle( 441 , 0 , 149 , 54 );
run("Set...", "value=avgmat");
makeRectangle( 447 , 4 , 2 , 10 );
run("Set...", "value=fracthresh");
makeRectangle( 459 , 4 , 6 , 30 );
run("Set...", "value=fracthresh");
makeRectangle( 479 , 4 , 10 , 50 );
run("Set...", "value=fracthresh");
makeRectangle( 507 , 4 , 14 , 70 );
run("Set...", "value=fracthresh");
makeRectangle( 543 , 4 , 18 , 90 );
run("Set...", "value=fracthresh");
makeRectangle( 441 , 0 , 149 , 54 );		//Repetition required to pass box to main code
