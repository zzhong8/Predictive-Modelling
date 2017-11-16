/* pgm02d01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics off;

/* Part A */
title1 'Test if the Mean SAT = 1200 Using PROC UNIVARIATE';
proc univariate data=york.testscores mu0=1200;
    var SATScore;
run;

ods graphics on;

/* Part B */
title1 'Test if the Mean SAT=1200 Using PROC TTEST';
proc ttest data=york.testscores h0=1200 plots(shownull)=interval;
    var SATScore;
run;

