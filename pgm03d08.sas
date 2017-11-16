/* pgm03d08 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics;

%let int_inputs=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

%let nom_inputs=House_Style Overall_Qual Overall_Cond Fireplaces 
         Season_Sold Garage_Type Foundation Heating_QC 
         Masonry_Veneer Lot_Shape Central_Air;

title1 "Selecting the Best Model using Honest Assessment";
proc glmselect data=york.ameshousing valdata=york.ameshousing2 plots=all;
    class &nom_inputs / param=glm ref=first;
    model SalePrice=&int_inputs &nom_inputs / 
			selection=backward select=sbc choose=validate;
    store out=york.amesstore;
run;

