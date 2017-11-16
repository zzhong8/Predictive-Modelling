/* pgm03d06 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics / imagemap=on;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         	    Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

/* Part A */
title1 "Best Models Using R-Square Option";
proc reg data=york.ameshousing plots(only)=(rsquare adjrsq cp);
    model SalePrice = &int_inputs / selection=rsquare best=2;
run;

/* Part B */
title1 "Best Models Using Adjusted R-Square Option";
proc reg data=york.ameshousing plots(only)=(cp);
    model SalePrice = &int_inputs / selection=adjrsq best=10;
run;
quit;

