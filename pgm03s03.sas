options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics / imagemap=on;

/* pgm03s03 (Part A) */
title1 "Using Mallows Cp for Model Selection";
proc reg data=york.bodyfat plots(only)=(cp);
   model PctBodyFat2=Age Weight Height Neck Chest Abdomen Hip Thigh
         Knee Ankle Biceps Forearm Wrist
         / selection=cp adjrsq best=60;
run;
quit;

/* pgm03s03 (Part B) */
title1 "Using Stepwise Methods for Model Selection";
proc reg data=york.bodyfat plots(only)=adjrsq;
   FORWARD:  model PctBodyFat2=Age Weight Height Neck Chest 
			Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist
            / selection=forward;
   BACKWARD: model PctBodyFat2=Age Weight Height Neck Chest 
			Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist
            / selection=backward;
   STEPWISE: model PctBodyFat2=Age Weight Height Neck Chest 
			Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist
            / selection=stepwise;
run;
quit;
