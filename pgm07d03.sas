/* pgm07d03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let pi1=0.02;

title1 'Score Initial Model';
title2 'Corrected for Oversampling using PRIOREVENT';
proc logistic data=york.train;
	class res(param=ref ref='S');
	model ins(event='1')=dda ddabal dep depamt cashbk checks res
		/ stb clodds=pl;
	units ddabal=1000 depamt=1000 / default=1;
	oddsratio 'Comparisons of Residential Classification' res / cl=pl;
	score data=york.valid priorevent=&pi1 out=scored;
run; 

title1 'Partial Listing of Predicted Values';
proc print data=scored(obs=10);
	var p_1 p_0 dda ddabal dep depamt cashbk checks res;
run;

title1 'Average Predicted Value';
proc means data=scored mean;
	var p_1;
run;

proc SQL noprint;
	select mean(INS) into :rho1 from york.develop;
quit;

%put &rho1;

data train;
	set york.train;
	off=log(((1-&pi1)*&rho1)/(&pi1*(1-&rho1)));
run;

title2 'Corrected for Oversampling using OFFSET';
proc logistic data=train outest=betas;
	class res(param=ref ref='S');
	model ins(event='1')=dda ddabal dep depamt cashbk checks res
		/ stb clodds=pl offset=off;
	units ddabal=1000 depamt=1000 / default=1;
	oddsratio 'Comparisons of Residential Classification' res / cl=pl;
run;

data valid(drop=ins);
	set york.valid;
	ResR=(Res='R');
	ResU=(Res='U');
run;

proc score data=valid score=betas type=parms out=scored;
	var dda ddabal dep depamt cashbk checks ResR ResU;
run;

data scored;
	set scored;
	p_1=1/(1+exp(-ins));
	p_0=1-p_1;
run;

title1 'Partial Listing of Predicted Values';
proc print data=scored(obs=10);
	var p_1 p_0 ins dda ddabal dep depamt cashbk checks res;
run;

title1 'Average Predicted Value';
proc means data=scored mean;
	var p_1;
run;

