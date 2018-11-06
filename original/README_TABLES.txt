This is file for tabulated ("look-up") data:
"stdmscdobc_depol_top5.dat" - file to correct for multiple-scattering component of  the 
N-values calculated in forward model as single-scatted radiances;
"stdrfcdobc_depol_top5_std21.dat" – file to correct N-value for atmospheric refraction of 
the solar radiation;

These data are organized as following: 
two blocks: first block is for sea-level pressure (lines 1-21), second block is for 500 mb 
pressure (lines 22-42), so we can use linear interpolation in pressure to the altitude of the 
station. 
Each block has data for low latitude (3 lines=3 standard profiles at 225, 275 and 325 
DU), followed by ozone profile data typical for the middle latitudes (8 lines, from 225 to 
575 DU, by 50 DU increments), and then by the data for high latitudes (10 profiles, from 
125 to 575 DU by 50 DU increments). 
The columns are data at 12 SZAs: from 60 to 90 SZA  
The tables were produced using TOMRAD RT code, based on Dave-Mateer code. In MS 
correction tables ("stdmscdob*_depol_top5.dat", * is a, c, d for wavelength pairs A, C, 
D) the de-polarization of radiation (important for MS correction, and cancels out in SS N-
values) is taken into account. I also re-calculated refraction correction tables 
(stdrfcdob*.dat). You will see that refraction table for C-pair is very different from the 
old table. I am not sure what is causing it. So, use refraction correction tables with 
caution (but you have to use the new table for all 3 pairs for consistency).
 
The ozone absorption and Rayleigh scattering coefficients at three wavelength pairs are 
as following:
A_short (305.5), A_long (325.0), C_short (311.5), C_long (332.4), D_short (317.6), 
D_long (339.8) 
     DATA ALFA/4.7815,3.1154E-1,2.1960,0.1151,0.9764,3.6910E-2/ 
      DATA ACOFT/1.0329E-2,1.4906E-3,5.6383E-3,6.8329E-4,3.0454E-3, 
     * 3.4829E-4/ 
      DATA ACOFTS/4.2446E-5,7.1465E-6,2.9501E-5,3.8094E-6,1.8284E-5, 
     * 2.4727E-6/ 
      DATA BETA/1.1260,0.8635,1.0362,0.7845,0.9532,0.7138/,
where ALFA, ACOFT, and ACOFTS are coefficients of the second-degree polynomial 
fit of the spectral ozone absorption sensitivity to the atmospheric temperature variability. 
The BETA is a spectral Rayleigh scattering coefficient.

The files called stdweffdobc_depol_top5.datn are data to correct N-values for change in 
ozone effective X-section as function of SZA (change of weighting of spectral 
contributions within the band-pass as SZA changes and shorter wavelengths are absorbed 
stronger than longer wavelengths. Thus the median wavelength shifts.) They are not used 
in the latest version where RT calculations are done at high resolution within th band-
pass, followed by convolution over the ban-pass function instead of using effective X-
section.

Files called "stdjacmsc.dat" are MS correction Jacobian (12x61) + ozone profile (1x61). 
Each block of 13 lines is for one of 21 standard profiles (3 of low latitudes, 8 of middle 
latitudes, and 10 of high latitudes sets). They are used to correct MS tables for change in 
ozone profile dMSC=dN/dx*(X_new-X_std).

File "totoz_press.dat" contains ozone in layer 0 for 21 standard profiles. This info is used 
when pressure interpolation is needed. Since TO is measured above pressure level of the 
station, the table helps to adjust measured TO to the sea level. Thus the appropriate 
standard ozone profile (defined by its TO at the sea-level) can be chosen.
File "coef_dobacdh.dat" and "coef_dobacdl.dat" are part of Bass and Paur tables for 
wavelengths within band-passes for A, C, D pairs. There are 3 blocks in high and low 
wavelengths data (3x161 and 3x61 respectively).
The line format is as following: 
wavelength *10 (nm), quadrature weights (from 0 to 1) , ET solar flux (W/m2/sec),  
alfa0, alfa1, alfa2, beta, de-polarization coefficient
3215 0 786.6 0.453706 0.00229443 1.0219e-05 0.903854 0.0311156
where ozone absorption coefficient=alfa0+alfa1*Temp+alfa2*Temp*Temp,
beta is Rayleigh extinction coefficient.

