/* pgm03d09 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 'Score the Selected Model';
proc plm restore=york.amesstore;
    score data=york.ameshousing3 out=scored;
    code file="c:\workshop\winsas\mban5110\scoring.sas";
run;

title1 'Scored Data (Partial Listing)';
proc print data=scored (obs=15);
	var pid Predicted;
run;

data scored2;
    set york.ameshousing3;
    %include "c:\workshop\winsas\mban5110\scoring.sas";
run;

title1 'Compare the Scored Models';
proc compare base=scored compare=scored2 criterion=0.0001;
    var Predicted;
    with P_SalePrice;
run;
