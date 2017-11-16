options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pm01s02.sas (Part A) */
title1 'Descriptive Statistics Using PROC UNIVARIATE';
proc univariate data=york.normtemp noprint;
    var BodyTemp;
    histogram BodyTemp / normal(mu=est sigma=est noprint) kernel;
    inset mean min max std skewness kurtosis/ position=ne;
    probplot BodyTemp / normal(mu=est sigma=est);
    inset mean min max std skewness kurtosis;
run;

/* pm01s02.sas (Part B) */
title1 "Box and Whisker Plots of Body Temp";
proc sgplot data=york.normtemp;
    vbox BodyTemp / datalabel=ID;
    format ID 3.;
    refline 98.6 / label axis=y;
run;
