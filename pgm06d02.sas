/* pgm06d02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* get variable list */
proc contents data=york.train(drop=ins) 
	out=temp(keep=name type) noprint;
run;

/* setup macro of interval variables */
proc sql noprint;
	select name into: interval separated by " "
	from temp
	where type=1;
quit;

/* save the cluster summary and rsquare tables */
ods output clusterquality=summary
           rsquare(match_all)=clusters;

title1 'Variable Clustering of Training Data Set';
proc varclus data=york.Train maxeigen=0.7 hi short;
	var &interval;
run;

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
%let reduced=M_CC M_HMVal Teller MM Income ILS LOC POSAmt NSFAmt CD 
	LORes CCPurc ATMAmt Inv Dep CashBk Moved IRA M_AcctAge IRABal 
	M_CRScore CRScore MTGBal AcctAge SavBal DDABal SDB InArea Sav 
	Phone CCBal InvBal MTG HMOwn DepAmt DirDep ATM Age;
*/
