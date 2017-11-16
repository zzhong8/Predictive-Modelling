/* pgm06s04 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

proc means data=york.pva_train noprint nway;
	class cluster_code;
	var target_b;
	output out=level mean=prop;
run;

ods output clusterhistory=cluster;

proc cluster data=level method=ward outtree=fortree
		plots=(dendrogram(horizontal height=rsq));
	freq _freq_;
	var prop;
	id cluster_code;
run;

proc freq data=york.pva_train noprint;
	tables cluster_code*target_b / chisq;
	output out=chi(keep=_pchi_) chisq;
run;

data cutoff;
	if _n_ = 1 then set chi;
	set cluster;
	if numberofclusters > 1 then do;
		chisquare=_pchi_*rsquared;
		degfree=numberofclusters-1;
		logpvalue=logsdf('CHISQ',chisquare,degfree);
	end;
run;

title1 'Determine the Number of Clusters with the Minimum P-Value';
proc sql;
	select NumberOfClusters into :ncl
		from cutoff
		having logpvalue=min(logpvalue);
quit;

proc tree data=fortree nclusters=&ncl out=clus noprint;
	id cluster_code;
run;

proc sort data=clus;
	by clusname;
run;

title1 "Cluster Assignments";
proc print data=clus;
	by clusname;
	id clusname;
run;

/* uses cluster 6 as the reference group */
data york.pva_train(drop=cluster_code); 
	set york.pva_train;
	ClusCdGrp1=cluster_code in("29","34","15","45","23","30","16",
			"19","31","08","24","43");
	ClusCdGrp2=cluster_code in("25","47","07","44","32","50","06",
			"33","09","05","37","39","51","41","21","10","52");
	ClusCdGrp3=cluster_code in(" .","04","13","28","11","40","20","35");
run;

data york.pva_valid(drop=cluster_code); 
	set york.pva_valid;
	ClusCdGrp1=cluster_code in("29","34","15","45","23","30","16",
			"19","31","08","24","43");
	ClusCdGrp2=cluster_code in("25","47","07","44","32","50","06",
			"33","09","05","37","39","51","41","21","10","52");
	ClusCdGrp3=cluster_code in(" .","04","13","28","11","40","20","35");
run;

/*
%let ex_collapsed=LIFETIME_CARD_PROM LIFETIME_AVG_GIFT_AMT 
	PER_CAPITA_INCOME RECENT_RESPONSE_PROP M_INCOME_GROUP NURB_ 
	CARD_PROM_12 PCT_OWNER_OCCUPIED  
	LIFETIME_GIFT_RANGE M_DONOR_AGE M_WEALTH_RATING NURBU NURBR 
	HOME01 DONOR_AGE PUBLISHED_PHONE PCT_MALE_MILITARY 	
	MONTHS_SINCE_LAST_GIFT RECENT_STAR_STATUS NSES4 NSES3 
	STATUS_FL STATUS_ES IN_HOUSE MOR_HIT_RATE INCOME_GROUP 
	PCT_MALE_VETERANS NURBS ClusCdGrp1 ClusCdGrp2 ClusCdGrp3;
*/
