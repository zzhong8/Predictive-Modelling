/* pgm05d01 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics on;

proc format;
   value survfmt 1="Survived"
                 0="Died";
run;

title1 'Description of Categorical variables';
proc freq data=york.titanic;
   tables survived gender class
          gender*survived class*survived /
          plots(only)=freqplot(scale=percent);
   format survived survfmt.;
run;

title1 'Description of Continuous Variables';
proc univariate data=york.titanic noprint;
   class survived;
   var age;
   histogram age;
   inset mean std median min max / format=5.2 position=ne;
   format survived survfmt.;
run;
