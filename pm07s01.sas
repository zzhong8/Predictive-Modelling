/* pgm07s01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let inputs=pep_star recent_avg_gift_amt frequency_status_97nk;

title1 'Initial Model';
proc logistic data=york.pva_train 
		plots(only)=(effect(clband x=(&inputs))
			oddsratio(type=horizontalstat)); 
 	model target_b(event='1')=&inputs / clodds=pl;
run;
