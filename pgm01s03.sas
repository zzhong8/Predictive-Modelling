options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pgm01s03.sas */
title1 '95% Confidence Interval for Body Temp';
proc means data=york.normtemp maxdec=4 n mean std stderr clm;
    var BodyTemp;
run;
