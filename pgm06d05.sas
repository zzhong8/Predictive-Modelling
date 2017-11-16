/* pgm06d05 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics on;

%macro greenacre(dsn=,variable=,target=);

	/* calculate class proportions */
	proc means data=&dsn nway;
		class &variable;
		var &target;
		output mean=prop out=level;
	run;

	ods listing close;
	ods output clusterhistory=cluster;

	/* cluster classes using proportions */
	proc cluster data=level method=ward outtree=fortree;
		freq _freq_;
		var prop;
		id &variable;
	run;

	ods listing;

	/* calculate chisq (on full table) */
	proc freq data=&dsn noprint;
		table &variable*&target/chisq;
		output chisq out=chi(keep=_pchi_);
	run;

	/* calculate log p-value */
	data cutoff;
		if _n_=1 then set chi;
		set cluster;
		if numberofclusters > 1 then do;
			chisquare=_pchi_*rsquared;
			degfree=numberofclusters-1;
			logpvalue=logsdf('CHISQ',chisquare,degfree);
		end;
	run;

	/* select minimim log p-value */
	proc sql;
   		select NumberOfClusters into :ncl
   		from cutoff
   		having logpvalue=min(logpvalue);
	quit;

	/* display solution dendrogram */
	proc tree data=fortree nclusters=&ncl height=rsq out=results; 
		id &variable;
	run;

	proc sort data=results;
   		by clusname;
	run;

	/* display the clusters */
	title 'Results';
	proc print data=results;
   		by clusname;
   		id clusname;
	run;
%mend greenacre;

%greenacre(dsn=york.train,variable=branch,target=ins)

data york.train(drop=branch);
	set york.train;
	brclus1=(branch='B14');
	brclus2=(branch in ('B17','B6','B10','B19','B3','B8',
			'B18','B5','B9','B12','B13','B1','B4'));
	brclus3=(branch in ('B15','B16'));
run;

data york.valid(drop=branch);
	set york.valid;
	brclus1=(branch='B14');
	brclus2=(branch in ('B17','B6','B10','B19','B3','B8',
			'B18','B5','B9','B12','B13','B1','B4'));
	brclus3=(branch in ('B15','B16'));
run;

/*
%let collapsed=M_CC Teller MM Income ILS LOC POSAmt NSFAmt CD 
		CCPurc ATMAmt InvBal Dep CashBk IRA M_AcctAge 
		IRABal M_CRScore CRScore MTGBal AcctAge B_SavBal B_DDABal SDB 
		InArea Sav Phone CCBal Inv MTG DepAmt DirDep ATM Age
		brclus1 brclus2 brclus3;
*/
