/* pgm02s03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* Part A */
title1 'Partial Listing of Ads Data';
proc print data=york.Ads (obs=10);
run;

title1 'Descriptive Statistics of Ad Sales';
proc means data=york.Ads printalltypes maxdec=3;
	class Ad;    
	var Sales;
run;

title1 "Box and Whisker Plots of Ad Sales";
proc sgplot data=york.Ads;
    vbox Sales / category=Ad;
run;

/* Part B */
title1 'Testing for Equality of Means in Ad Sales with PROC GLM';
proc glm data=york.Ads plots(only)=diagnostics; * Show diagnostics ONLY
     class Ad;
     model Sales=Ad;
     means Ad / hovtest;
run;
