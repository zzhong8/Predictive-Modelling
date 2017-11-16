/* pgm03d05 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics on;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

/* Part A */
title1 "Forward Model Selection for SalePrice";
proc reg data=york.ameshousing;
    FORWARD: model SalePrice = &int_inputs
            / selection=forward slentry=0.05;
run;

/* Part B */
title1 "Backward Model Selection for SalePrice";
proc reg data=york.ameshousing;
    BACKWARD: model SalePrice = &int_inputs
            / selection=backward slstay=0.05;
run;

/* Part C */
title1 "Stepwise Model Selection for SalePrice";
proc reg data=york.ameshousing;
    STEPWISE: model SalePrice = &int_inputs
            / selection=stepwise slentry=0.05 slstay=0.05;
run;
quit;
