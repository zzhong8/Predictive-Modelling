/* pgm03d01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics / reset=all imagemap;

/* Whenever you see int_inputs replace with

Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom*/

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         	    Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

/* Part A */
title1 "Correlations and Scatter Plots with SalePrice";
proc corr data=york.ameshousing rank /*rank - order the correlations from highest to lowest for me*/
          plots(only)=scatter(nvar=all /*show scatterplot for all vars*/ ellipse=none);
   var &int_inputs;
   with SalePrice;
   id PID;
run;

/* Part B */
title1 "Correlations and Scatter Plot Matrix of Predictors";
proc corr data=york.amesHousing nosimple best=3;
   var &int_inputs; *Check to see if there is collinearity;
run;

