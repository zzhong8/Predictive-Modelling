/* pgm04s03 */

ods graphics off;

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* Part A */
title1 'Collinearity Detection - Full Model';
proc reg data=york.bodyfat;
  model PctBodyFat2=
           Age Weight Height Neck Chest Abdomen Hip Thigh
           Knee Ankle Biceps Forearm Wrist
          / vif collin collinoint;
run;

/* Part B */
title1 'Collinearity Detection -- No Weight';
proc reg data=york.bodyfat;
    NOWT: model PctBodyFat2 =
           Age Height Neck Chest Abdomen Hip Thigh
           Knee Ankle Biceps Forearm Wrist / vif;
run;
quit;

ods graphics on;
