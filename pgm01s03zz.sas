/* pgm01d03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 '95% Confidence Interval for BodyTemp';
proc means data=york.normtemp maxdec=4 n mean std stderr clm alpha=0.05;
    var BodyTemp;
run;
