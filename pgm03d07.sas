/* pgm03d07 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

/* variables selected using ADJRSQ Criterion (previous demo) */
%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         	    Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

title1 "Parameter Estimates for the All-Possible Model";
proc reg data=york.ameshousing;
    model SalePrice = &int_inputs;
run;
quit;
