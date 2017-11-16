/* pgm06d04b */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%macro bin_var(dsn=,var=,nbins=100);

	/* rank the observations */
	proc rank data=&dsn groups=&nbins out=out;
   		var &var;
   		ranks bin;
	run;

	/* save the endpoints of each bin */
	proc means data=out noprint nway;
   		class bin;
   		var &var;
   		output max=max out=endpts;
	run;

	title1 'Partial Listing of the Endpoint Values';
	title2 "Variable: &var";
	proc print data=endpts(obs=10);
	run;

	/* create a filename to write code into */
	filename rank "c:\temp\rank.sas";

	/* write the code to assign individuals to bins */
	data _null_;
   		file rank;
   		set endpts end=last;
   		if _n_ = 1 then put "select;";
   		if not last then do;
     		put "  when (&var <= " max ") B_&var =" bin ";";
   		end;
   		else if last then do;
     		put "  otherwise B_&var =" bin ";";
     		put "end;";
   		end;
	run;

	/* apply the stored code */
	data &dsn;
   		set &dsn;
   		%include rank / source;
	run;
	
	title1 'Confirmation of Generated Endpoint Values';
	proc means data=&dsn min max maxdec=2;
   		class B_&var;
   		var &var;
	run;
%mend bin_var;

%bin_var(dsn=york.train,var=DDABal)

/* modify the validation data */
data york.valid;
	set york.valid;
	%include rank;
run;

%bin_var(dsn=york.train,var=SavBal)

/* modify the validation data */
data york.valid;
	set york.valid;
	%include rank;
run;

/*
%let smoothed=M_CC Teller MM Income ILS LOC POSAmt NSFAmt CD 
		CCPurc ATMAmt InvBal Dep CashBk IRA M_AcctAge 
		IRABal M_CRScore CRScore MTGBal AcctAge B_SavBal B_DDABal SDB 
		InArea Sav Phone CCBal Inv MTG DepAmt DirDep ATM Age;
*/

