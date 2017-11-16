options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pgm02s02 */
title1 "German Grammar Training, Comparing Treatment to Control";
proc ttest data=york.german plots(shownull)=interval;
    class Group;
    var Change;
run;
