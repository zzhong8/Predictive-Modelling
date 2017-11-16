/* pgm07d04a */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let collapsed=M_CC Teller MM Income ILS LOC POSAmt NSFAmt CD 
		CCPurc ATMAmt InvBal Dep CashBk IRA M_AcctAge 
		IRABal M_CRScore CRScore MTGBal AcctAge B_SavBal B_DDABal SDB 
		InArea Sav Phone CCBal Inv MTG DepAmt DirDep ATM Age;

/* fast backward selection */
title1 'Fast Backward Selection';
proc logistic data=york.train 
		plots(only maxpoints=none)=oddsratio(type=horizontalstat);
	class res(param=ref ref='S');
	model ins(event='1')=&collapsed res/selection=backward fast 
			slstay=0.1 stb clodds=pl;
run;
