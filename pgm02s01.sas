options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pm02s01.sas (part A) */
title1 'Testing If the Mean Temperature=98.6 Using PROC UNIVARIATE';
proc univariate data=york.normtemp mu0=98.6;
    var BodyTemp; 
run;

/* pm02s01.sas (Part B) */
title1 'Testing If the Mean Temperature=98.6 Using PROC TTEST';
proc ttest data=york.normtemp h0=98.6 plots(shownull)=interval;
    var BodyTemp;
run;


