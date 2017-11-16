/* pgm07s03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let inputs=pep_star recent_avg_gift_amt frequency_status_97nk;

%let ex_pi1=0.05;

title1 'Initial Model';
proc logistic data=york.pva_train 
		plots(only)=(effect(clband x=(&inputs))
			oddsratio(type=horizontalstat)); 
 	model target_b(event='1')=&inputs / clodds=pl;
	score data=york.pva_valid priorevent=&ex_pi1 out=Scored_Pva;
run;

/* display scoring results */
title1 'Partial Listing of Predicted Values';
proc print data=Scored_Pva(obs=10);
   var p_1 p_0 pep_star recent_avg_gift_amt frequency_status_97nk;
run;

/* calculate average predicted value */
title1 'Average Predicted Value';
proc means data=Scored_Pva mean;
	var p_1;
run;
