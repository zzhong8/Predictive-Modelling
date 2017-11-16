/* pgm07d02 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

title1 'Score Initial Model';
title2 'No Correction for Oversampling';
proc logistic data=york.train;
	class res(param=ref ref='S');
	model ins(event='1')=dda ddabal dep depamt cashbk checks res
   		/ stb clodds=pl;
	units ddabal=1000 depamt=1000 /default=1;
	oddsratio 'Comparisons of Residential Classification' res / cl=pl;
	score data=york.valid out=scored;
run;

title1 'Partial Listing of Predicted Values';
proc print data=scored(obs=10);
	var p_1 p_0 dda ddabal dep depamt cashbk checks res;
run;

title1 'Average Predicted Value';
proc means data=scored mean;
	var p_1;
run; 
