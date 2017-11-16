/* pgm06s01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

proc contents data=york.pva(drop=target_b target_d months_since_last_prom_resp) 
		out=temp(keep=name type) noprint;
run;

proc sql noprint;
	select name into: ex_inputs separated by " "
	from temp
	where type=1;
quit;

%put &ex_inputs;

title1 'PVA Data';
proc means data=york.pva n nmiss mean min max;
	var &ex_inputs;
run;

/* create missing value indicators for PVA data */
data pva(drop=i);
   set york.pva;
   array x{*} donor_age income_group wealth_rating;
   array mi{*} M_DONOR_AGE M_INCOME_GROUP M_WEALTH_RATING;
   do i=1 to dim(mi);
      mi{i}=(x{i}=.);
   end;
run;

/* sort the sample on the strata variable */
proc sort data=pva;
	by target_b;
run;

/* set-up an indicator observations to training or validation */
proc surveyselect data=pva samprate=0.5 seed=27513 outall 
		 noprint out=temp(drop=samplingweight selectionprob);
	strata target_b;
run;

/* perform the split */
data york.pva_train(drop=selected) york.pva_valid(drop=selected);
	set temp(drop=months_since_last_prom_resp);
	if selected then output york.pva_train;
	else output york.pva_valid;
run;

/*
title1 'Original Target Proportions';
proc freq data=york.pva;
	tables target_b;
run;

title1 'Training Target Proportions';
proc freq data=york.pva_train;
	tables target_b;
run;

title1 'Validation Target Proportions';
proc freq data=york.pva_valid;
	tables target_b;
run;
*/

title1 'Training Data';
title2 'Pre-Imputation';
proc means data=york.pva_train n nmiss mean min max;
	var donor_age income_group wealth_rating;
run;

title2 'Partial Listing';
proc print data=york.pva_train(obs=10);
	var donor_age M_donor_age income_group M_income_group
		wealth_rating M_wealth_rating;
run;

%let nclusters=9;

/* perform cluster imputation on the training data */
proc fastclus data=york.pva_train maxc=&nclusters impute outiter outseed=seeds 
		out=york.pva_train(drop=cluster distance _impute_) noprint;
	var &ex_inputs; 
run;

title2 'Post-Imputation';
proc means data=york.pva_train n nmiss mean min max;
	var donor_age income_group wealth_rating;
run;

title2 'Partial Listing';
proc print data=york.pva_train(obs=10);
	var donor_age M_donor_age income_group M_income_group
		wealth_rating M_wealth_rating;
run;

title1 'Validation Data';
title2 'Pre-Imputation ';
proc means data=york.pva_valid n nmiss mean min max;
	var donor_age income_group wealth_rating;
run;

title2 'Partial Listing';
proc print data=york.pva_valid(obs=10);
	var donor_age M_donor_age income_group M_income_group
		wealth_rating M_wealth_rating;
run;

/* perform cluster imputation on the validation data */
proc fastclus data=york.pva_valid maxc=&nclusters impute replace=none
		maxiter=0 seed=seeds(where=(_iter_=1)) 
		out=york.pva_valid(drop=cluster distance _impute_) noprint;
	var &ex_inputs; 
run;

title2 'Post-Imputation';
proc means data=york.pva_valid n nmiss mean min max;
	var donor_age income_group wealth_rating;
run;

title2 'Partial Listing';
proc print data=york.pva_valid(obs=10);
	var donor_age M_donor_age income_group M_income_group
		wealth_rating M_wealth_rating;
run;
