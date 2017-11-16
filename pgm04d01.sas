/* pgm04d01 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics on;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom ;

/* Part A */
title1 'SalePrice Model - Default Plots';
proc reg data=york.ameshousing;
    model SalePrice = &int_inputs;
run;

/* Part B */
title1 'SalePrice Model - Requested Plots';
proc reg data=york.ameshousing plots(only)=(QQ RESIDUALBYPREDICTED);
	model SalePrice = &int_inputs;
run;
quit;

