options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics off;

/* pgm03s02 (Part A) */
title1 'Regression of PctBodyFat2 on All Predictors';
proc reg data=york.bodyfat;
   model PctBodyFat2=Age Weight Height Neck Chest Abdomen Hip Thigh
         Knee Ankle Biceps Forearm Wrist;
run;
quit;

/* pgm03s02 (Part B) */
title1 'Input with Largest p-value Removed';
proc reg data=york.bodyfat;
   model PctBodyFat2=Age Weight Height Neck Chest Abdomen Hip Thigh
         Ankle Biceps Forearm Wrist;
run;
quit;

/* pgm03s02 (Part C) */
title1 'Input with Next Largest p-value Removed';
proc reg data=york.bodyfat;
   model PctBodyFat2=Age Weight Height Neck Abdomen Hip Thigh
         Ankle Biceps Forearm Wrist;
run;
quit;

ods graphics on;
