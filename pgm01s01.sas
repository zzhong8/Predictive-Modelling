options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pm01s01 (Parts A and B) */
title1 'Selected Descriptive Statistics for Body Temp';
proc means data=york.normtemp maxdec=2 n mean std q1 q3 qrange;
    var BodyTemp;
run;

/* pm01s01 (Part C) */
title1 'Selected Descriptive Statistics for Body Temp';
proc means data=york.normtemp maxdec=2 n mean std q1 q3 qrange;
    class Gender;    
	var BodyTemp;
run;
