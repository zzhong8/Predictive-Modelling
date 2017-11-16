/* pgm05s02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110'; 

proc format; 
   value safefmt 0='Average or Above'
                 1='Below Average';
run;

title1 "Association between Unsafe and Region";
proc freq data=york.safety;
    tables region*unsafe / expected chisq relrisk;
    format unsafe safefmt.;
run;
