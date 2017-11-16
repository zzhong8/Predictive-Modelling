/* pgm04d02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics on / labelmax=300;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

title1 'Backward Elimination Model Selection';
proc reg data=york.ameshousing
	plots(only label)=(RSTUDENTBYPREDICTED COOKSD DFFITS DFBETAS);
	model SalePrice=&int_inputs / 
		selection=backward slstay=0.05 r influence;
	output rstudent=rstudent dffits=dffits cookd=cooksd out=stats;
run;

/* determine the number of parameters (ninputs+1) */
data _null_;
	call symputx('nparms',length("%cmpres(&int_inputs)")-
		length(compress("%cmpres(&int_inputs)"))+2);
run;

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
