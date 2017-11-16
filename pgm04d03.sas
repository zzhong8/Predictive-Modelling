/* pgm04d03 */ 

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics off;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

title1 'Collinearity Diagnostics';
proc reg data=york.ameshousing;
    model SalePrice = &int_inputs score / 
		vif collin collinoint;
run;

title2 'With Score Removed';
proc reg data=york.ameshousing;
    NOSCORE: model SalePrice = &int_inputs / vif;
run;
quit;

ods graphics on;
