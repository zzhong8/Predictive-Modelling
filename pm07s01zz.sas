/* pg07s01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let inputs=pep_star recent_avg_gift_amt frequency_status_97nk;

title1 'Initial Model';
proc logistic data=york.pva_train
		/* We 'only' want to see the 'effect' plots */
		plots(only)=(effect(clband /*clband = confidence limit*/ x=(&inputs))
				     oddsratio (type=horizontalstat /* shows 95% CL and point estimate*/)); 

   /*target_b is our target variable*/
   /*(event='1') tells SAS to predict the '1' event instead of the '0' event*/
   model target_b(event='1')=&inputs /
			stb /*stb displays standardized parameter estimates*/
			clodds=pl /*clodds = confidence limit for the odds, pl = profile likelihood*/;
run;
