options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* pgm03s01 (Part A) */
title1 "Correlation of Input Subset with Body Fat %";
proc corr data=york.bodyfat rank
		plots(only)=scatter(nvar=all ellipse=none);
   var Age Weight Height Neck Chest Abdomen Hip Thigh
       Knee Biceps Forearm;
   with PctBodyFat2;
run;

/* pgm03s01 (Part B) */
title1 "Correlations of Input Subset with Each Other";
proc corr data=york.bodyfat nosimple;
    var Age Weight Height Neck Chest Abdomen Hip Thigh
       Knee Biceps Forearm;
run;

ods graphics off;

/* pgm03s01 (Part C) */
title1 "Regression of % Body Fat on Weight";
proc reg data=york.bodyfat;
    model PctBodyFat2=Weight;
run;
quit;

/* pgm03s01 (Part D) */
data ToScore;
    input Weight @@;
    datalines;
125 150 175 200 225
;
run;

title1 "Regression of % Body Fat on Weight";
proc reg data=york.bodyFat outest=Betas;
    PredBodyFat: model PctBodyFat2=Weight;
run;
quit;

proc score data=ToScore score=Betas type=parms out=Scored;
    var Weight;
run;

title1 "Predicted % Body Fat from Weight 125 150 175 200 225";
proc print data=Scored;
run;

ods graphics on;

