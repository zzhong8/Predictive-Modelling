/* pgm06d03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let reduced=M_CC M_HMVal Teller MM Income ILS LOC POSAmt NSFAmt CD 
	LORes CCPurc ATMAmt Inv Dep CashBk Moved IRA M_AcctAge IRABal 
	M_CRScore CRScore MTGBal AcctAge SavBal DDABal SDB InArea Sav 
	Phone CCBal InvBal MTG HMOwn DepAmt DirDep ATM Age;

/* determine the number of input variables */
data _null_;
	call symputx('nvar',length("%cmpres(&reduced)")-
			length(compress("%cmpres(&reduced)"))+1);
run;

ods graphics on;
ods html close;
ods output spearmancorr=spearman
           hoeffdingcorr=hoeffding;

proc corr data=york.train spearman hoeffding rank;
   var &reduced;
   with ins;
run;

ods html;

data spearman1(keep=variable scorr spvalue ranksp);
   length variable $ 8;
   set spearman;
   array best(*) best1--best&nvar;
   array r(*) r1--r&nvar;
   array p(*) p1--p&nvar;
   do i=1 to dim(best);
      variable=best(i);
      scorr=r(i);
      spvalue=p(i);
      ranksp=i;
      output;
   end;
run;

data hoeffding1(keep=variable hcorr hpvalue rankho);
   length variable $ 8;
   set hoeffding;
   array best(*) best1--best&nvar;
   array r(*) r1--r&nvar;
   array p(*) p1--p&nvar;
   do i=1 to dim(best);
      variable=best(i);
      hcorr=r(i);
      hpvalue=p(i);
      rankho=i;
      output;
   end;
run;

proc sort data=spearman1;
   by variable;
run;

proc sort data=hoeffding1;
   by variable;
run;

data correlations;
   merge spearman1 hoeffding1;
   by variable;
run;

proc sort data=correlations;
   by ranksp;
run;

title1 "Rank of the Spearman and Hoeffding Correlations";
proc print data=correlations label split='*';
   var variable ranksp rankho scorr spvalue hcorr hpvalue;
   label ranksp = 'Spearman rank*of variables'
         scorr = 'Spearman Correlation'
         spvalue = 'Spearman p-value'
         rankho = 'Hoeffding rank*of variables'
         hcorr = 'Hoeffding Correlation'
         hpvalue = 'Hoeffding p-value';

run;

/* Find values for reference lines */
proc sql noprint;
   select min(ranksp) into :vref 
   from (select ranksp 
         from correlations 
         having spvalue > 0.5);
   select min(rankho) into :href 
   from (select rankho
         from correlations
         having hpvalue > 0.5);
quit;

/* Plot variable names, Hoeffding and Spearman ranks */
title1 "Scatter Plot of the Ranks of Spearman vs. Hoeffding";
proc sgplot data=correlations;
   refline &vref / axis=y;
   refline &href / axis=x;
   scatter y=ranksp x=rankho / datalabel=variable;
   yaxis label="Rank of Spearman";
   xaxis label="Rank of Hoeffding";
run;

/*
%let screened=M_CC Teller MM Income ILS LOC POSAmt NSFAmt CD 
		CCPurc ATMAmt InvBal Dep CashBk IRA M_AcctAge 
		IRABal M_CRScore CRScore MTGBal AcctAge SavBal DDABal SDB 
		InArea Sav Phone CCBal Inv MTG DepAmt DirDep ATM Age;
*/
