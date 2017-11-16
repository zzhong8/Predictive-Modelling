options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pm02s03 (Part A) */
title1 'Descriptive Statistics of Sales by Ad Type';
proc means data=york.ads printalltypes n mean std skewness kurtosis;
    class Ad;    
	var Sales;
run;

title1 "Box and Whisker Plots of Sales by Ad Type";
proc sgplot data=york.ads;
    vbox Sales / category=Ad datalabel=Sales;
run;

/* pm02s03 (Part B) */
title1 'Testing for Equality of Ad Type on Sales';
proc glm data=york.ads plots=diagnostics;
    class Ad;
    model Sales=Ad;
    means Ad / hovtest;
run;

