/* pgm02d06 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 'Garlic Block Data: Multiple Comparisons';
proc glm data=sasuser.mggarlic_block 
         plots(only)=(controlplot diffplot(center));
    class Fertilizer Sector;
    model BulbWt=Fertilizer Sector;
    lsmeans Fertilizer / pdiff=all adjust=tukey;
    lsmeans Fertilizer / pdiff=control('4') adjust=dunnett;
    lsmeans Fertilizer / pdiff=all adjust=t;
run;
