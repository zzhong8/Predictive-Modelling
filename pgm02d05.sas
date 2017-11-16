/* pgm02d05 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 'ANOVA for Randomized Block Design';
proc glm data=york.mggarlic_block plots(only)=diagnostics;
     class Fertilizer Sector;
     model BulbWt=Fertilizer Sector;
run;

