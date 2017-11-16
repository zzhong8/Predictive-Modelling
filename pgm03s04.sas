options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

%let nom_inputs=House_Style Overall_Qual Overall_Cond Fireplaces 
         Season_Sold Garage_Type Foundation Heating_QC 
         Masonry_Veneer Lot_Shape Central_Air;

/* pgm03s04 */
title1 "Selecting the Best Model using Honest Assessment";
proc glmselect data=york.ameshousing seed=8675309;
   class &nom_inputs / param=glm ref=first;
   model SalePrice=&nom_inputs &int_inputs / 
               selection=stepwise select=aic choose=validate;
   partition fraction(validate=0.3333);
   score data=york.ameshousing3 out=score1;
   store out=amesstore;
run;

proc plm restore=amesstore;
   score data=york.ameshousing3 out=score2;
run;

proc compare base=score1 compare=score2 criterion=0.0001;
   var P_SalePrice;
   with Predicted;
run;
