/* pgm04s01 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics / imagemap=on;

title1 'Redsidual Diagnostic Plots';
proc reg data=york.bodyfat 
         plots(only)=(QQ RESIDUALBYPREDICTED RESIDUALS);
   model PctBodyFat2=Abdomen Weight Wrist Forearm;
   id Case;
run;
quit;
