/* pgm03d02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics;

title1 "Simple Regression";
proc reg data=york.ameshousing;
    model SalePrice=Basement_Area;
run;

