/* pgm01d02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* Part A */
title1 'Descriptive Statistics Using PROC UNIVARIATE';
proc univariate data=york.testscores;
    var SATScore;
    histogram SATScore / normal(mu=est sigma=est) kernel;
    inset skewness kurtosis / position=ne;
    probplot SATScore / normal(mu=est sigma=est);
    inset skewness kurtosis;
run;

/* Part B */
title1 "Box-and-Whisker Plots of SAT Scores";
proc sgplot data=york.testscores;
    vbox SATScore / datalabel=IDNumber;
    format IDNumber 8.;
    refline 1200 / axis=y label;
run;
