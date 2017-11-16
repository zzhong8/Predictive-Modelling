/* pgm04s02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let int_inputs=Abdomen Weight Wrist Forearm;

/* Part A */
title1 'Plots of Influential Observations';
proc reg data=york.bodyfat
         plots(only label)=
              (RSTUDENTBYPREDICTED
               COOKSD
               DFFITS
               DFBETAS);
  model PctBodyFat2=&int_inputs / r influence;
  output rstudent=rstud dffits=dfits cookd=cooksd out=stats;
  id Case;
run;
quit;

/* determine the number of parameters (ninputs+1) */
data _null_;
	call symputx('nparms',length("%cmpres(&int_inputs)")-
		length(compress("%cmpres(&int_inputs)"))+2);
run;

/* Part B */
data influential;
	set stats nobs=n;
	retain cutdffits cutcooksd;
	if _n_=1 then do;
		cutdffits=2*sqrt(&nparms/n);	/* DFFITS cutoff */
		cutcooksd=4/n;					/* COOKSD cutoff */
	end;
	observation=_n_;
	rstudent_i=(abs(rstudent) > 3);
	dffits_i=(abs(dffits) > cutdffits);
	cooksd_i=(cooksd > cutcooksd);
	sum_i=rstudent_i+dffits_i+cooksd_i;
	if sum_i > 0;
run;

title1 'Observations that Exceed the Suggested Cutoffs';
proc print data=influential;
	var observation cooksd rstudent dffits cutcooksd cutdffits cooksd_i
        rstudent_i dffits_i sum_i;
run;
