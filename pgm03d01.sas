/* pgm03d01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics / reset=all imagemap;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         	    Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

/* Part A */
title1 "Correlations and Scatter Plots with SalePrice";
proc corr data=york.ameshousing rank
          plots(only)=scatter(nvar=all ellipse=none);
   var &int_inputs;
   with SalePrice;
   id PID;
run;

/* Part B */
title1 "Correlations and Scatter Plot Matrix of Predictors";
proc corr data=york.amesHousing nosimple best=3;
   var &int_inputs;
run;

