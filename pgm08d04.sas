/* pgm08d04 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* initial model */
proc logistic data=york.train noprint;
   class res;
   model ins(event='1')=dda ddabal dep depamt checks res;
   score data=york.valid out=sco_validate(rename=(p_1=p_initial));         
run;

/* final model */
%let selected=Teller MM ILS LOC NSFAmt CD ATMAmt Dep IRA M_AcctAge MTGBal AcctAge 
		B_SavBal B_DDABal Sav CCBal Inv MTG DirDep ATM brclus1 brclus3;

proc logistic data=york.train noprint;
   model ins(event='1')=&selected;
   score data=sco_validate out=sco_validate(rename=(p_1=p_final));         
run;

ods select ROCOverlay ROCAssociation ROCContrastTest;

title1 "Validation Data Set Performance";
proc logistic data=sco_validate;
   model ins(event='1')=p_initial p_final / nofit;
   roc "Initial Model" p_initial;
   roc "Final Model" p_final;
   roccontrast "Comparing the Two Models";
run;

