/* pgm01d03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 '95% Confidence Interval for SAT';
proc means data=york.testscores maxdec=4 n mean std stderr clm;
    var SATScore;
run;
