..  _umkehr_inputs:

Inputs
======

Units

Unit       File
----      -----

4         Output   umout, O3 profile                    Fortran writes to python buffer
5         Input    mk2v4cum.inp                         default in python package
6         Output   Umkehr retrieval statistics          Fortran writes to python buffer.
8         Input    stdmscdobc_depol_top5.dat            static
9         Input    fstguess.dat                         default in python package
10        Output   output from DECODE                   Fortran writes to python buffer
10        Input    input to UMKEHR                      reads from python buffer
11        Input    phprofil.dat                         default in python package
13        Input    refractn.dat                         default in python package
18        Input    std_pfl.asc                          default in python package
19        Input    stdjacmsc.dat                        default in python package
14        Output   uprint, Averaging Kernels            Fortran writes to python buffer
15        Input    nrl.dat                              default in python package
21        Output                                        Fortran writes to python buffer
22        Output                                        Fortran writes to python buffer
25        Output                                        Fortran writes to python buffer
31        Output                                        Fortran writes to python buffer

phprofile.dat
-------------

Unit 11, phprofil.dat. SUBROUTINE STNDRD. INITIALIZATION STAGE. READS 81 ELEEMNT STANDARD PRESSURE-HEIGHT PROFILE AND SPLINE INTERPOLATES FOR FORWARD MODEL CALCULATION

refractn.dat
------------
LINE 235
Unit 13, refractn.dat. MAIN ROUTINE, INITIALIZATION , Reads An Array of Refraction corrections
5 lines
Total refraction + 12 refraction corrections

fstguess.dat
------------

9  fstguess.dat, SUBROUTINE SASCO3 (ID,IFGLAT,PNOT,OMOBS,TDX)
SUBROUTINE TO CREATE SASC STANDARD PROFILES. FG is based on seasonal cycle in all 16 layers, NOT the total ozone
OMOBS is used to normalize seasonal FG to the observed total ozone
INPUT INCLUDES LATITUDE BAND NUMBER 1,...,6    
DAY AND MONTH TO GET JULIAN DAY 
TOTAL OZONE IN M ATM-CM         
  
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
 



stdmscdobc_depol_top5
---------------------

LINE 192
8 stdmscdobc_depol_top5.dat, 
READ MULTIPLE SCATTERING CORRECTIONS array ( 12,42)

std_pfl.asc
-----------

LINE 189
READ FG, READ Total ozone at pressure levels 0.5, 0.8, 0.7, 0.9
PRES(61)
TABFG(61,12)

18 std_pfl.asc, 


This is file for tabulated ("look-up") data:
"stdmscdobc_depol_top5.dat" - file to correct for multiple-scattering component of  the 
N-values calculated in forward model as single-scatted radiances;
"stdrfcdobc_depol_top5_std21.dat" file to correct N-value for atmospheric refraction of
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
as following::

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

The files called ``stdweffdobc_depol_top5.datn`` are data to correct N-values for change in
ozone effective X-section as function of SZA (change of weighting of spectral 
contributions within the band-pass as SZA changes and shorter wavelengths are absorbed 
stronger than longer wavelengths. Thus the median wavelength shifts.) They are not used 
in the latest version where RT calculations are done at high resolution within th band-
pass, followed by convolution over the ban-pass function instead of using effective X-
section.

Files called ``stdjacmsc.dat`` are MS correction Jacobian (12x61) + ozone profile (1x61).
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
wavelength \*10 (nm), quadrature weights (from 0 to 1) , ET solar flux (W/m2/sec),
alfa0, alfa1, alfa2, beta, de-polarization coefficient
3215 0 786.6 0.453706 0.00229443 1.0219e-05 0.903854 0.0311156
where ozone absorption coefficient=alfa0+alfa1\*Temp+alfa2\*Temp\*Temp,
beta is Rayleigh extinction coefficient.



stdjacmsc.dat
-------------

LINE 197
READ MULTIPLE SCATTERING CORRECTIONS JACOBEAN, Array (61,13,21)
19 stdjacmsc.dat

nrl.dat
-------

Line 205
Read in NRL temperature/altitude climatology for monthly mean and zonal
C averaged profiles

Array( 12,45, 19)
15 nrl.dat

coef_dobcl.dat
--------------

Line 129
READ spectral parameters
Lambda, slit function, ET flux, alfa0, alfat, alfatt, beta, rho

98 coef_dobcl.dat

coef_dobch.dat
--------------
97 coef_dobch.dat

Line 162
READ spectral parameters
Lambda, slit function, ET flux, alfa0, alfat, alfatt, beta, rho

totoz_press.dat
---------------
Line 188, C READ Total ozone at pressure levels 0.5, 0.8, 0.7, 0.9
Array(21)
79 totoz_press.dat



output
------

Feb 10, 2006
Final stage of reprocessing Umkehr data using FAP03 algorithm.
name: STN##_SZA.swfgztw_sevar_out, SZA is normalization angle
Description of files:
STN014-Tateno
STN035-Arosa
STN067-Boulder

Example of file for Arosa::

    0     SOLUTION STATISTICS FOR  5337 PROFILES
     TOTAL OZONE   OBSERVED= 311.4 +/-    0.0     SOLUTION= 310.5 +/-    0.0
     AVERAGE RESIDUAL= 0.30 +/-  0.14          TOTAL ITERATIONS=****
     LAYER     61     60     59     58     57     56     55     54     53     52     51     50     49     48     47     46     45     44     43     42     41     40     39     38     37     36     35     34     33     32     31     30     29     28     27     26     25     24     23     22     21     20     19     18     17     16     15     14     13     12     11     10      9      8      7      6      5      4      3      2      1
     AVE DU     0.12E-05  0.54E-06  0.78E-06  0.11E-05  0.16E-05  0.24E-05  0.34E-05  0.50E-05  0.71E-05  0.10E-04  0.15E-04  0.22E-04  0.32E-04  0.47E-04  0.68E-04  0.96E-04  0.13E-03  0.17E-03  0.22E-03  0.28E-03  0.37E-03  0.50E-03  0.67E-03  0.89E-03  0.12E-02  0.16E-02  0.20E-02  0.26E-02  0.32E-02  0.40E-02  0.48E-02  0.58E-02  0.69E-02  0.80E-02  0.93E-02  0.11E-01  0.12E-01  0.14E-01  0.15E-01  0.16E-01  0.17E-01  0.18E-01  0.18E-01  0.17E-01  0.16E-01  0.14E-01  0.12E-01  0.11E-01  0.94E-02  0.84E-02  0.76E-02  0.67E-02  0.57E-02  0.48E-02  0.41E-02  0.37E-02  0.35E-02  0.37E-02  0.41E-02  0.48E-02  0.00E+00
     DEV DU  0.20E-06  0.67E-07  0.88E-07  0.11E-06  0.14E-06  0.18E-06  0.22E-06  0.26E-06  0.30E-06  0.33E-06  0.37E-06  0.48E-06  0.83E-06  0.16E-05  0.31E-05  0.56E-05  0.92E-05  0.14E-04  0.22E-04  0.33E-04  0.50E-04  0.78E-04  0.11E-03  0.16E-03  0.22E-03  0.28E-03  0.34E-03  0.41E-03  0.47E-03  0.53E-03  0.61E-03  0.73E-03  0.89E-03  0.11E-02  0.12E-02  0.13E-02  0.14E-02  0.15E-02  0.16E-02  0.19E-02  0.23E-02  0.28E-02  0.32E-02  0.36E-02  0.36E-02  0.35E-02  0.32E-02  0.30E-02  0.30E-02  0.32E-02  0.32E-02  0.29E-02  0.23E-02  0.15E-02  0.11E-02  0.10E-02  0.11E-02  0.11E-02  0.11E-02  0.12E-02  0.00E+00
     ERROR   0.4E-04   0.2E-04   0.2E-04   0.4E-04   0.5E-04   0.8E-04   0.1E-03   0.2E-03   0.2E-03   0.3E-03   0.5E-03   0.7E-03   0.1E-02   0.1E-02   0.2E-02   0.3E-02   0.4E-02   0.5E-02   0.7E-02   0.8E-02   0.1E-01   0.1E-01   0.2E-01   0.2E-01   0.3E-01   0.3E-01   0.4E-01   0.5E-01   0.6E-01   0.8E-01   0.9E-01   0.1E+00   0.1E+00   0.1E+00   0.2E+00   0.2E+00   0.2E+00   0.2E+00   0.3E+00   0.3E+00   0.3E+00   0.3E+00   0.3E+00   0.3E+00   0.3E+00   0.3E+00   0.2E+00   0.2E+00   0.2E+00   0.2E+00   0.1E+00   0.1E+00   0.1E+00   0.9E-01   0.8E-01   0.7E-01   0.7E-01   0.8E-01   0.9E-01   0.1E+00   0.0E+00
     VARED -0.402E+14-0.140E+15-0.467E+14-0.183E+14-0.741E+13-0.289E+13-0.859E+12-0.199E+12-0.441E+11-0.828E+11 0.100E+01 0.100E+01-0.246E+03-0.571E+05 0.482E+06 0.440E+05 0.818E+00-0.160E+03-0.141E+05-0.639E+05 0.209E+05 0.813E+00-0.873E+02 0.959E+03-0.215E+04 0.104E+04 0.923E+00-0.170E+02-0.221E+03 0.210E+03 0.100E+01 0.105E+01 0.989E+01-0.201E+01-0.109E+02 0.100E+01 0.126E+01-0.787E+01 0.135E+02-0.147E+01 0.100E+01 0.116E+01 0.376E+01-0.403E+01 0.100E+01 0.989E+00-0.269E+01 0.648E+01 0.482E+01 0.999E+00-0.178E+00 0.228E+02-0.673E+02 0.132E+02 0.994E+00-0.474E+01-0.380E+03-0.850E+03 0.100E+01 0.100E+01 0.000E+00

    The output is given in 61 layers (top to bottom), where each layer is 1/4 of traditional umkehr layer (total of 16).
    AVE DU is average ozone profile for all 5337 profiles in data file
    DEV DU is standard deviation in retrieved profiles around average profile.
    ERROR is mean of ESTIMATED ERROR OF FINAL SOLUTION IN EACH LAYER, called SERX ( after Rodgers, 1976, eq. 22)
        SERX is sqrt(AVARS)*100, where AVARS(I,K)=COVF(I,K)-SUM(AKTF(I,J)*AKSX(J,K), j=1,MEQ), I=1,NCP1, K=1, NCP1
        COVF is profile covariance matrix (Sx),
        AKSX =K*Sx (or product of Jacobian dN/dX and co-variance of a priori),
        AKTF=Sx*K^T*(K *SX* K^T+ Se)^-1 (or called Gy in Rodgers 2000, sensitivity of the retrieval to measurement error),
        where AKTF*K is Averaging Kernel
    VARED is reduction in variance or difference between apriori Sx and total error of solution (smoothing and measurement errors)
        VARED = mean of (COVF(I,I)-AKTSEKI(I,I))/COVF(I,I), where I - diagonal element of the covariance meatrix
        COVF is a priori covariance matrix,
        AKTSEKI is (K *SX* K^T+ Se)^-1, and AKTF*K is AK=Sx*K^T*K*(K *SX* K^T+ Se)^-1 =Sx*(K *SX* K^T+ Se)^-1

FAP03 Algorithm
---------------
Jan 5, 2004
Final stage of reprocessing Umkehr data using FAP03 algorithm.

RT - retrieved (using Umkehr Dobson C-pair retrieval algorithm UMKV8)
OBS - observed Umkehr measurements (so-called N-values)
SZA - solar zenith znagle

Description of files:
STN014-Tateno
STN035-Arosa
STN067-Boulder

'ap' means a priori
'fap' means fixed a priori (no seasonal cycle)
60 or 70 means that data werer normalized to the measurement at either 60 or 70-degrees SZA

Format of the RT file::

    DD MM YY M/A LAM TO_OB TO_RT LO3(10:1)*100 NUMIT SZA_b SZA_num RMSD(DIF) RMSD(CONV) RMSD(err) STN_num
      1  8 57 2 3  279  2827   116   191   677  2607  5158  7266  6210  2528   988  2525 3 3 10   1   3   48  14
    DD is day
    MM is month
    YY is year
    M/A is morning or afternoon (1/2)
    TO_OB is observed total ozone (TO)
    TO_RT is retrieved TO
    LO3(10:1) is 100*ozone amount (DU*100) in Umkehr layers 10, 9,...1 (layer 1 is a double layer 0+1)
    NUMIT is number of iterations
    SZA_b is the SZA number for the first available measurement (1 is 60, 2 is 65, 3 is 70 etc)
    SZA_nub is the number of measurements (12 is the maximum number)
    RMSD(DIF) is the root-mean squar deviation (RMSD) of the difference from the solution from the previous iteration
    RMSD(CON) the the RMSD of the convergency of the forcing factor
    RMSD(err) is the the RMSD of the residual fit (difference between OB and RT N-values)
    STN_num station number

Format of the AP file::

    DD MM YY TO_OB LO3(12:0)
     1   8  57   279.0   0.1042   0.3372   0.9891   2.9847   9.7834  25.9466  52.5572  74.3062  60.6886  25.8584  11.3458  13.8404  23.6888

Detailed Description of three errors: 
DIF ( or DFRMS in the code), CON (or FEPS), ERR (or RMSRES). They are printed out as (value \*100 +0.5), except that the fisrt one is (value*1000 +0.5)

DIF is the root-mean squar deviation (RMSD) of the relative change in the solution (profile) from the previous iteration (ratio of the difference over the solution from the previous step). 
The condition to stop iteration is that DFRMS is less than 0.01 or less than 1 % change.

CON is the RMSD of the convergency of the forcing factor (or difference between FORSHD and DYMKDX, where FORSHD contains values of DYMKDX from the previous step of iterations),
The forcing factor is calculated in
DYMKDX=(N_observed-N_retrieved) - dN/dX\*(X_retrieved-X_apriori),
where dN/dX is Jacobian, the term is called FEPS in the program and is RMSD of the sum over all SZA.
Condition to stop iteration is that FEPS is less than 0.15, which is a mean value of measurement errors in N-values

ERR is the the RMSD of the residual fit (difference between observed  and retrieved N-values). There is no condition to stop iteration. You can use this parameter to decide if you like the conversion.
Typically I advise users to accept everything below 100. If it happens to be larger, than most likely you will have more thnan 3 iterations (2 and 3 are good profiles).
