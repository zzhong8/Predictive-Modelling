/* pgm02s02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

data results;
	set york.German;
	diff = Retain - Pre;
run;

proc print data = results;
run;

title1 "Two-Sample t-test Comparing Control Group to Treatment Group";
proc ttest data=york.German plots(shownull)=interval;
    class Group;
    *var Retain - Pre;
	var Change;
run;
