options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pgm02s05 (Part A) */
title1 'Tukey Pairwise Differences for Ad Types on Sales';
proc glm data=york.ads1 plots(only)=diffplot(center);
    class Ad Area;
    model Sales=Ad Area;
    lsmeans Ad / pdiff=all adjust=tukey;
run;

/* pgm02s05 (Part B) */
title1 'Dunnett Pairwise Differences for Ad Types on Sales';
proc glm data=york.ads1 plots(only)=controlplot;
    class Ad Area;
    model Sales=Ad Area;
    lsmeans Ad / pdiff=control('display') adjust=dunnett;
run;
quit;

