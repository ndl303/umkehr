 The "fstguess.dat" file lists parameters for generating typical seasonal variations in 
ozone profile. The latitude-dependent climatology of monthly averages of ozone profiles 
was compiled by NASA/Goddard (McPeters and Labow, 2003). The cosine fit to the 
climatology is as following:
AP(i)=COEF1(i) +COEF2(i)*COS((JULDAY-COEF3(i))*2*p/365),
where AP(i) is a priori ozone amount in DU in layer i, COEF1 (i), COEF2 (i), COEF3 (i) 
are coefficients of the fit for layer i tabulated in the file "fstguess.dat", and JULDAY is a 
Julian day of the year. The file is organized in 14 blocks of three coefficients, where each 
block represents the fit for a climatology averaged over 10-degree latitude band. The first 
block has data for 60-degrees Northern latitude and above, and the last block has data for 
60-degrees Southern latitude and above. Each block is organized as following:
COEF1(i=1,13)
COEF3(i=1,13)
COEF3(i=1,13),
where i=1 is the bottom layer, i=13 is the top layer. The layering system is given in 
pressure-level coordinates, where the bottom layer is confined between 1 and 0.5 atm, the 
top pressure level of the layer is half of the pressure at the bottom level.

