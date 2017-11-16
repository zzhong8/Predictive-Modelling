/* pgm08d02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let pi1=0.02;	/* population proportion of one event */

/* determine the sample proportion of the one event */
proc sql noprint;
	select mean(ins) into :rho1 
	from york.develop;
quit;

/* add the decision variable and calculate profit */ 
data york.scores;
   set york.scores;
   sampwt=(&pi1/&rho1)*(INS)+((1-&pi1)/(1-&rho1))*(1-INS);
   decision=(p_1 > 0.01);
   profit=decision*INS*99-decision*(1-INS)*1;
run;

/* calculate total and average profit */
title1 "Total and Average Profit";
proc means data=york.scores sum mean;
   weight sampwt;
   var profit;
run;

/* investigate the true positive and false positive rates */
data york.roc;
   set york.roc;
   aveProf=99*tp-1*fp;
run;

title1 "Average Profit Against Depth";
proc sgplot data=york.roc;
   series y=aveProf x=depth;
   yaxis label="Average Profit";
run;

title1 "Average Profit Against Cutoff";
proc sgplot data=york.roc;
   where cutoff le 0.05;
   refline .01 / axis=x;
   series y=aveProf x=cutoff;
   yaxis label="Average Profit";
run;
