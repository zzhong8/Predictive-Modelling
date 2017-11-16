/* pgm02d01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics off;

/* Part A */
title1 'Test if the Mean BodyTemp = 98.6 Using PROC UNIVARIATE';
proc univariate data=york.NormTemp mu0=98.6;
    var BodyTemp;
run;

ods graphics on;

/* Part B */
title1 'Test if the BodyTemp = 98.6 Using PROC TTEST';
proc ttest data=york.NormTemp h0=98.6 plots(shownull)=interval;
    var BodyTemp;
run;

