/* pgm01d01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* Part A */
title1 'Partial Listing of the SAT Data Set';
proc print data=york.testscores(obs=10);
run;

/* Part B */
title1 'Descriptive Statistics Using PROC MEANS';
proc means data=york.testscores;
    var SATScore;
run;

/* Part C */    
title1 'Selected Descriptive Statistics for SAT Scores';
proc means data=york.testscores maxdec=4 n mean median std q1 q3 qrange;
    var SATScore;
run;
