/* pgm02d04 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 'Testing for Equality of Means with PROC GLM';
proc glm data=york.mggarlic plots(only)=diagnostics;
     class Fertilizer;
     model BulbWt=Fertilizer;
     means Fertilizer / hovtest;
run;

