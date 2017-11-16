/* pgm08d03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 "K-S Statistic for the Validation Data Set";
proc npar1way edf data=york.scores;
   class ins;
   var p_1;
run;

