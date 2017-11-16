/* pgm02d07 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* Part A */
title1 'Partial Listing of the Drug Data Set';
proc print data=york.drug(obs=10);
run;

/* Part B */
proc format;
    value dosefmt 1='Placebo'
                  2='50 mg'
                  3='100 mg'
                  4='200 mg';
run;

title1 'Selected Descriptive Statistics for Drug Data Set';
proc means data=york.drug mean var std nway;
    class Disease DrugDose;
    var BloodP;
	format DrugDose dosefmt.;
    output mean=BloodP_Mean out=means;
run;

/* Part C */
title1 'Plot of Stratified Means in Drug Data Set';
proc sgplot data=means;
    series x=DrugDose y=BloodP_Mean / group=Disease markers;
    xaxis integer;
	format DrugDose dosefmt.;
run;

/* Part D */
title1 'Analyze the Effects of DrugDose and Disease';
title2 'Including Interaction';
proc glm data=york.drug order=internal;
    class DrugDose Disease;
    model Bloodp=DrugDose Disease DrugDose*Disease;
	format DrugDose dosefmt.;
run;
quit;

/* Part E */
ods graphics off;
ods select LSMeans SlicedANOVA;

title1 'Analyze the Effects of DrugDose at Each Level of Disease';
proc glm data=york.drug order=internal;
    class DrugDose Disease;
    model Bloodp=DrugDose Disease DrugDose*Disease;
    lsmeans DrugDose*Disease / slice=Disease;
	format DrugDose dosefmt.;
run;
quit;

ods graphics on;
