/* pgm05s01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics off;

title1 "Safety Data Frequencies";
proc freq data=york.safety;
    tables unsafe type region size;
run;

ods graphics on;
