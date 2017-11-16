/* pgm05d02 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

proc format;
   value survfmt 1="Survived"
                 0="Died";
run;

ods graphics off;

title1 'Associations with Survival';
proc freq data=york.titanic;
   tables (gender class)*survived
         / chisq expected cellchi2 nocol nopercent relrisk;
   format survived survfmt.;
run;

ods graphics on;

