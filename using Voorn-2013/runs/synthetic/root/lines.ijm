//Automatically generated file for control lines for multiscale Hessian analysis
arguments=getArgument();
avgmat=substring(arguments,0,5);
fracthresh=substring(arguments,5,10);
//____________________________________
makeRectangle( 0 , 88 , 100 , 12 );
run("Set...", "value=avgmat");
makeRectangle( 6 , 92 , 2 , 10 );
run("Set...", "value=fracthresh");
makeRectangle( 14 , 92 , 4 , 20 );
run("Set...", "value=fracthresh");
makeRectangle( 26 , 92 , 6 , 30 );
run("Set...", "value=fracthresh");
makeRectangle( 0 , 88 , 100 , 12 );		//Repetition required to pass box to main code
