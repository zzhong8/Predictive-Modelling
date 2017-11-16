/* pgm06s02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

proc contents data=york.pva_train(drop=target_b target_d) 
		out=temp(keep=name type) noprint;
run;

proc sql noprint;
	select name into: ex_inputs separated by " "
	from temp
	where type=1;
quit;

%put &ex_inputs;

/* save the cluster summary and rsquare tables */
ods graphics off;
ods output clusterquality=summary
           rsquare(match_all)=clusters;

title1 'Variable Clustering of PVA Training Data';
proc varclus data=york.pva_train short hi maxeigen=0.70;
	var &ex_inputs M_donor_age M_income_group M_wealth_rating;
run;

ods graphics on;

/* determine the number of clusters */
data _null_;
   set summary end=eof;
   if eof then call symputx('ncl',trim(left(numberofclusters-2)));
run;

/* augment data to facilitate the sort */
data temp;
  set clusters&ncl;
  retain cluster_number 1;
  if controlvar='-' then cluster_number+1;
run;

/* sort variables in each cluster by (ascending) 1-R**2 value */
proc sort data=temp;
  by cluster_number RSquareRatio;
run;

/* select each cluster's smallest 1-R**2 value */
data results;
	set temp;
	by cluster_number;
	if first.cluster_number then output;
run;

/* display results */
title1 'Selected Variables';
proc print data=results label noobs;
	label cluster_number='Cluster';
	var cluster_number Variable RSquareRatio;
run;

/*
 %let ex_reduced=LIFETIME_CARD_PROM LIFETIME_AVG_GIFT_AMT PER_CAPITA_INCOME
		RECENT_RESPONSE_PROP M_INCOME_GROUP NURB_ CARD_PROM_12 
		PCT_OWNER_OCCUPIED PCT_VIETNAM_VETERANS LIFETIME_GIFT_RANGE M_DONOR_AGE
		M_WEALTH_RATING NURBU NURBR HOME01 DONOR_AGE PUBLISHED_PHONE 
		PCT_MALE_MILITARY NURBT MONTHS_SINCE_LAST_GIFT RECENT_STAR_STATUS 
		NSES4 NSES3 STATUS_FL STATUS_ES IN_HOUSE MOR_HIT_RATE INCOME_GROUP
        PCT_MALE_VETERANS NURBS;
*/
