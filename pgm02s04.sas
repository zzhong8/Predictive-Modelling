options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pgm02s04 */
title1 'ANOVA for Randomized Block Design';
proc glm data=york.ads1 plots(only)=diagnostics;
    class Ad Area;
    model Sales=Ad Area;
run;

