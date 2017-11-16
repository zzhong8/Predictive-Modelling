/* pgm02d02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 "Two-Sample t-test Comparing Girls to Boys";
proc ttest data=york.testscores plots(shownull)=interval;
    class Gender;
    var SATScore;
run;
