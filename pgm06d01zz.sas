/* pgm06d01 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

proc contents data=york.develop(drop=ins) out=temp(keep=name type) noprint;
run;

proc sql noprint;
	select name into: interval separated by " "
	from temp
	where type=1;
quit;

%put &interval;
/* -------- create missing value indicators -------- */

%macro setup_indicators(dsn=,inputs=);
	title1 "%upcase(&dsn) Data Set";
	title2 'Pre-Imputation';
	proc means data=&dsn n nmiss mean min max;
		var &inputs;
		output nmiss= out=temp(drop=_type_ _freq_);
	run;
	proc transpose data=temp out=temp;
	run;
	proc sql noprint;
		select _name_ into: missing separated by " "
		from temp
		where col1 > 0;
	quit;
	data _null_;
		call symputx('nmissing',length("%cmpres(&missing)")-
			length(compress("%cmpres(&missing)"))+1);
	run;
	data &dsn;
		set &dsn;
		%do i=1 %to &nmissing;
			%let variable=%scan(&missing,&i);
			M_&variable=(&variable=.);
		%end;
	run;
%mend setup_indicators;

%setup_indicators(dsn=york.develop,inputs=&interval)

/* ---------- data splitting ---------- */

title1 'Original Target Proportions';
proc freq data=york.develop;
	tables ins;
run;

proc sort data=york.develop out=develop; 
	by ins;
run;

proc surveyselect data=develop ranuni samprate=0.6667 seed=44444 
	outall noprint out=develop(drop=samplingweight selectionprob);
	strata ins;
run;

data york.train(drop=selected) york.valid(drop=selected); /* drop variable after splitting */
	set develop;
	/* Do the splitting */
	if selected then output york.train;
	else output york.valid;
run;

title1 'Training Target Proportions';
proc freq data=york.train;
	tables ins;
run;

title1 'Validation Target Proportions';
proc freq data=york.valid;
	tables ins;
run;

/* ------- perform median imputation ------------ */

proc stdize data=york.train reponly method=median /* reponly means to only replace missing values */
		outstat=medians out=york.train;
	var &interval;
run;

title1 'Training Data Set';
title2 'Post-Imputation';
proc means data=york.train n nmiss mean min max;
	var &interval;
run;

title2 'Partial Listing';
proc print data=york.train(obs=12);
	var ccbal m_ccbal ccpurc m_ccpurc income m_income hmown m_hmown;
run; 

proc stdize data=york.valid reponly method=in(medians)out=york.valid;
	var &interval;
run;

title1 'Validation Data Set';
title2 'Post-Imputation';
proc means data=york.valid n nmiss mean min max;
	var &interval;
run;
