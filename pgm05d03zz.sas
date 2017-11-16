/* pgm05d03 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics off;

title1 "Exact P-Values";
proc freq data=york.exact_copy;
   tables A*B / chisq expected cellchi2 nocol nopercent;
run;

ods graphics on;

