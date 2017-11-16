options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pgm02s06 (Part A) */
title1 'Selected Descriptive Statistics for Concrete Data';
proc means data=york.concrete mean var std nway;
    class Brand Additive;
    var Strength;
    output mean=Strength_Mean out=means;
run;

title1 'Plot of Stratified Means in Concrete Data';
proc sgplot data=means;
    series x=Additive y=Strength_Mean / group=Brand markers;
    xaxis integer;
run;

/* pgm02s06 (Part B) */
title1 'Analyze the Effects of Additive and Brand';
title2 'on Concrete Stength';
proc glm data=york.concrete;
    class Additive Brand;
    model Strength=Additive Brand Additive*Brand;
run;
quit;

/* pgm02s06 (Part C) */
ods graphics off;    

title1 'Analyze the Effects of Additive and Brand';
title2 'on Concrete Stength without Interaction';
proc glm data=york.concrete;
    class Additive Brand;
    model Strength=Additive Brand;
    lsmeans Additive;
run;
quit;

ods graphics on;
