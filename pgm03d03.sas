/* pgm03d03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 'Minimum and Maximum Values in the Sample';
proc means data=york.ameshousing min max;
	var Basement_Area;
run;

data need_predictions;
   input Basement_Area @@;
   datalines;
0 100 222 350 500 735 987 1002 1492 1645
;
run;

proc reg data=york.ameshousing outest=betas noprint;
    PredSalePrice: model SalePrice=Basement_Area;
run;
   
title1 "OUTEST= Data Set from PROC REG";
proc print data=betas noobs;
run;

proc score data=need_predictions score=betas type=parms out=scored;
   var Basement_Area;
run;

title1 "Scored Data";
proc print data=scored;
run;
