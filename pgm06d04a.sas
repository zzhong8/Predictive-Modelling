/* pgm06d04a */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%macro empirical_logit(dsn=,input=,target=,nbins=100);

	/* group the data to create empirical logit plots */
	proc rank data=&dsn groups=&nbins out=out;
   		var &input;
   		ranks bin;
	run;

	/* determine variable mean and target frequency in each bin */
	proc means data=out noprint nway;
   		class bin;
   		var ins &input;
   		output sum(ins)=&target mean(&input)=&input out=bins;
	run;

	/* calculate the empirical logit */ 
	data bins;
   		set bins;
   			elogit=log((ins+(sqrt(_FREQ_ )/2))/
          		( _FREQ_ -ins+(sqrt(_FREQ_ )/2)));
	run;

	/* generate the elogit by raw variable plot */
	title1 "Empirical Logit Against &input";
	proc sgplot data=bins;
   		reg y=elogit x=&input /
       		curvelabel="Linear?"
	   		curvelabelloc=outside
	   		lineattrs=(color=ligr);
   		series y=elogit x=&input;
	run;

	/* generate the elogit by bin number plot */
	title1 "Empirical Logit Against Binned &input";
	proc sgplot data=bins;
   		reg y=elogit x=bin /
       		curvelabel="Linear?"
	   		curvelabelloc=outside
	   		lineattrs=(color=ligr);
   		series y=elogit x=bin;
	run;
%mend empirical_logit;

title1 'Mean Value for Account Holders (DDABal)';
proc sql;
	select mean(DDABal) into :mean 
   		from york.train where DDA=1;
quit;

/* replace training balance of non-account holders with mean */
data york.train;
	set york.train;
	if DDA=0 then DDABal=&mean;
run;

/* replace validation balance of non-account holders with training mean */
data york.valid;
	set york.valid;
	if DDA=0 then DDABal=&mean;
run;

%empirical_logit(dsn=york.train,input=DDABal,target=ins)
%empirical_logit(dsn=york.train,input=SavBal,target=ins)
