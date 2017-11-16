/* pgm08d01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let selected=Teller MM ILS LOC NSFAmt CD ATMAmt Dep IRA M_AcctAge MTGBal AcctAge 
	B_SavBal B_DDABal Sav CCBal Inv MTG DirDep ATM;

%let pi1=0.02;

ods select roccurve scorefitstat;

title1 'Score Validation Data';
proc logistic data=york.train;
   model ins(event='1')=&selected;
   score data=york.valid priorevent=&pi1 
         fitstat outroc=york.roc out=york.scores;
run;

title1 'Partial Listing of Predicted Values';
proc print data=york.roc(obs=10);
   var _prob_ _sensit_ _1mspec_;
run;

/* adjust oversampled confusion matrix */
data york.roc;
	set york.roc;
 	cutoff=_PROB_;
	specif=1-_1MSPEC_;
	tp=&pi1*_SENSIT_;
	fn=&pi1*(1-_SENSIT_);
	tn=(1-&pi1)*specif;
	fp=(1-&pi1)*_1MSPEC_;
	depth=tp+fp;
	pospv=tp/depth;
	if depth ne 1 then negpv=tn/(1-depth);
	acc=tp+tn;
	lift=pospv/&pi1;
	keep cutoff tn fp fn tp _SENSIT_ _1MSPEC_ specif 
        depth pospv negpv acc lift;
run;

/* create a lift chart */
title1 "Lift Chart for Validation Data";
proc sgplot data=york.roc;
   where 0.005 <= depth <= 0.50;
   series y=lift x=depth;
   refline 1.0 / axis=y;
   yaxis values=(0 to 8 by 1);
run; 
quit;
