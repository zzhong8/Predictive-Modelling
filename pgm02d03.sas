/* pgm02d03 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* Part A */
title1 'Partial Listing of Garlic Data';
proc print data=york.mggarlic (obs=10);
run;

/* Part B */
title1 'Descriptive Statistics of Garlic Weight';
proc means data=york.mggarlic printalltypes maxdec=3;
	class Fertilizer;    
	var BulbWt;
run;

/* Part C */
title1 "Box and Whisker Plots of Garlic Weight";
proc sgplot data=york.mggarlic;
    vbox BulbWt / category=Fertilizer datalabel=BedID;
    format BedID 5.;
run;
