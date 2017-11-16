/* pgm06s03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let ex_reduced=LIFETIME_CARD_PROM LIFETIME_AVG_GIFT_AMT PER_CAPITA_INCOME
		RECENT_RESPONSE_PROP M_INCOME_GROUP NURB_ CARD_PROM_12 
		PCT_OWNER_OCCUPIED PCT_VIETNAM_VETERANS LIFETIME_GIFT_RANGE M_DONOR_AGE
		M_WEALTH_RATING NURBU NURBR HOME01 DONOR_AGE PUBLISHED_PHONE 
		PCT_MALE_MILITARY NURBT MONTHS_SINCE_LAST_GIFT RECENT_STAR_STATUS 
		NSES4 NSES3 STATUS_FL STATUS_ES IN_HOUSE MOR_HIT_RATE INCOME_GROUP
        PCT_MALE_VETERANS NURBS;

/* calculate the number of variables in ex_reduced */
data _null_;
	call symputx('ex_nvar',length("%cmpres(&ex_reduced)")-
			length(compress("%cmpres(&ex_reduced)"))+1);
run;

ods html close;
ods output spearmancorr=Spearman
           hoeffdingcorr=Hoeffding;

/* generate correlations and ranks */
proc corr data=york.pva_train spearman hoeffding rank;
   var &ex_reduced;
   with target_b;
run;

ods html;

/* store the Spearman's correlations, probabilities, and ranks as macro variables */
data Spearman1(keep=variable scorr spvalue ranksp);
   length variable $ 32;
   set Spearman;
   array best(*) best1--best&ex_nvar;
   array r(*) r1--r&ex_nvar;
   array p(*) p1--p&ex_nvar;
   do i=1 to dim(best);
      variable=best(i);
      scorr=r(i);
      spvalue=p(i);
      ranksp=i;
      output;
   end;
run;

/* store the Hoeffding's correlations, probabilities, and ranks as macro variables */
data Hoeffding1(keep=variable hcorr hpvalue rankho);
   length variable $ 32;
   set Hoeffding;
   array best(*) best1--best&ex_nvar;
   array r(*) r1--r&ex_nvar;
   array p(*) p1--p&ex_nvar;
   do i=1 to dim(best);
      variable=best(i);
      hcorr=r(i);
      hpvalue=p(i);
      rankho=i;
      output;
   end;
run;

proc sort data=Spearman1;
   by variable;
run;

proc sort data=Hoeffding1;
   by variable;
run;

data Correlations;
   merge Spearman1 Hoeffding1;
   by variable;
run;

proc sort data=Correlations;
   by ranksp;
run;

title1 'Ranks of Variables Based on Spearman and Hoeffding';
proc print data=Correlations label split='*';
   var variable ranksp rankho;
   label ranksp = 'Spearman rank*of variables'
         rankho = 'Hoeffding rank*of variables';
run;

/* Find values for reference lines */
proc sql noprint;
   select min(ranksp) into :vref 
   from (select ranksp 
         from Correlations 
         having spvalue > .5);
   select min(rankho) into :href 
   from (select rankho
         from Correlations
         having hpvalue > .5);
run; 
quit;

title1 'Scatter Plot of the Ranks of Spearman vs. Hoeffding';
proc sgplot data=Correlations;
   refline &vref / axis=y;
   refline &href / axis=x;
   scatter y=ranksp x=rankho / datalabel=variable;
   yaxis label="Rank of Spearman";
   xaxis label="Rank of Hoeffding";
run;

/*
%let ex_screened=LIFETIME_CARD_PROM LIFETIME_AVG_GIFT_AMT 
	PER_CAPITA_INCOME RECENT_RESPONSE_PROP M_INCOME_GROUP NURB_ 
	CARD_PROM_12 PCT_OWNER_OCCUPIED  
	LIFETIME_GIFT_RANGE M_DONOR_AGE M_WEALTH_RATING NURBU NURBR 
	HOME01 DONOR_AGE PUBLISHED_PHONE PCT_MALE_MILITARY 	
	MONTHS_SINCE_LAST_GIFT RECENT_STAR_STATUS NSES4 NSES3 
	STATUS_FL STATUS_ES IN_HOUSE MOR_HIT_RATE INCOME_GROUP 
	PCT_MALE_VETERANS NURBS;
*/
