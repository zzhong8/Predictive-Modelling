/* pgm07d04b */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let collapsed=M_CC Teller MM Income ILS LOC POSAmt NSFAmt CD 
		CCPurc ATMAmt InvBal Dep CashBk IRA M_AcctAge 
		IRABal M_CRScore CRScore MTGBal AcctAge B_SavBal B_DDABal SDB 
		InArea Sav Phone CCBal Inv MTG DepAmt DirDep ATM Age;

/* set population proportion of event */
%let pi1=0.02;

/* determine sample proportion of event */
proc SQL noprint;
	select mean(INS) into :rho1 
	from york.develop;
quit;

/* calculate offset and dummy codes */
data train;
	set york.train;
	resr=(res='R');
	resu=(res='U');
	off=log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1)));
run;
	
%macro all_possible(dsn=,inputs=,target=);

	/* generate all possible models */
	ods output bestsubsets=best;
	title1 'Models Selected by All Subsets Selection';
	proc logistic data=&dsn;
   		model &target(event='1')=&inputs/offset=off  
			selection=score best=1;
	run;

	/* store variables and number of variable in each model */
	proc sql noprint;
 		select variablesinmodel into :inputs1-:inputs999 
  			from best;
  		select NumberOfVariables into :ic1-:ic999 
  			from best;
	quit;

	/* generate fit statistics for each model */
	%let lastindx=&SQLOBS;
	%do m=1 %to &lastindx;
		%let vars=&&inputs&m;
		%let nvars=&&ic&m;
		ods output scorefitstat=stats&nvars;
		proc logistic data=&dsn namelen=32;
  			model &target(event='1')=&vars;
  			score data=&dsn priorevent=&pi1 fitstat out=scored;
		run;
	%end;

	/* combine fit into a single data set */
	data modelfit;
		set stats1-stats&lastindx;
		model=_n_;
	run;

	/* order models by BIC value */
	proc sort data=modelfit;
		by bic;
	run;
	
	/* display fit data */
	title1 "Fit Statistics of Models selected from Best-Subsets";
	proc print data=modelfit;
		var model auc aic bic misclass adjrsquare brierscore;
	run;

	/* get model number of winning model */
	data _null_;
		set modelfit(obs=1);
		call symputx("winner",model);
	run;

	/* get variables in winning model */
	proc sql;
   		select VariablesInModel into :selected
   		from best
   		where numberofvariables=&winner;
	quit;

	%put &selected;

	/* build selected model using OFFSET= option */
	proc logistic data=&dsn namelen=32;
 		model &target(event='1')=&selected / offset=off stb clodds=pl;
	run;
%mend all_possible;

%all_possible(dsn=train,inputs=&collapsed resr resu,target=ins)

/*
%let selected=Teller MM ILS LOC NSFAmt CD ATMAmt Dep IRA M_AcctAge MTGBal AcctAge 
	B_SavBal B_DDABal Sav CCBal Inv MTG DirDep ATM brclus1 brclus3;
*/
