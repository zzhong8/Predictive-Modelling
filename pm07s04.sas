/* pgm07s04 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

%let ex_pi1=0.05;

%let ex_collapsed=LIFETIME_CARD_PROM LIFETIME_AVG_GIFT_AMT 
	PER_CAPITA_INCOME RECENT_RESPONSE_PROP M_INCOME_GROUP NURB_ 
	CARD_PROM_12 PCT_OWNER_OCCUPIED  
	LIFETIME_GIFT_RANGE M_DONOR_AGE M_WEALTH_RATING NURBU NURBR 
	HOME01 DONOR_AGE PUBLISHED_PHONE PCT_MALE_MILITARY 	
	MONTHS_SINCE_LAST_GIFT RECENT_STAR_STATUS NSES4 NSES3 
	STATUS_FL STATUS_ES IN_HOUSE MOR_HIT_RATE INCOME_GROUP 
	PCT_MALE_VETERANS NURBS ClusCdGrp1 ClusCdGrp2 ClusCdGrp3;

/* fast backward selection */
title1 'Fast Backward Selection';
proc logistic data=york.pva_train;
	model target_b(event='1')=&ex_collapsed/
		selection=backward fast stb clodds=pl;
	score data=york.pva_valid priorevent=&ex_pi1 out=scored_pva;
run;

title1 'Scored PVA validation data (Partial Listing)';
proc print data=scored_pva(obs=10);
	var p_1 p_0;
run;

title1 'Average Predicted Value';
proc means data=scored_pva mean;
	var p_1;
run;
