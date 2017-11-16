/* pgm03d04 */

options nodate nonumber;
libname york 'c:\workshop\winsas\mban5110';

ods graphics / imagemap tipmax=2600;

/* Part A */
title1 "Basement Area and Above Ground Living Area";
proc reg data=york.ameshousing;
    model SalePrice=Basement_Area Gr_Liv_Area;
run;

/* Part B */
title1 "Model with Basement Area and Above Ground Living Area";
proc glm data=york.ameshousing plots(only)=(contourfit);
    model SalePrice=Basement_Area Gr_Liv_Area;
    store out=multiple;
run;

/* Part C */
proc plm restore=multiple plots=all;
    effectplot contour (y=Basement_Area x=Gr_Liv_Area);
    effectplot slicefit(x=Gr_Liv_Area 
			sliceby=Basement_Area=250 to 1000 by 250);
run; 



