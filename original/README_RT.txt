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

Format of the RT file:
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

Format of the AP file
DD MM YY TO_OB LO3(12:0) 
  1   8  57   279.0   0.1042   0.3372   0.9891   2.9847   9.7834  25.9466  52.5572  74.3062  60.6886  25.8584  11.3458  13.8404  23.6888 

Detailed Description of three errors: 
DIF ( or DFRMS in the code), CON (or FEPS), ERR (or RMSRES). They are printed out as (value *100 +0.5), except that the fisrt one is (value*1000 +0.5)

DIF is the root-mean squar deviation (RMSD) of the relative change in the solution (profile) from the previous iteration (ratio of the difference over the solution from the previous step). 
The condition to stop iteration is that DFRMS is less than 0.01 or less than 1 % change.

CON is the RMSD of the convergency of the forcing factor (or difference between FORSHD and DYMKDX, where FORSHD contains values of DYMKDX from the previous step of iterations),
The forcing factor is calculated in
DYMKDX=(N_observed-N_retrieved) - dN/dX*(X_retrieved-X_apriori),
where dN/dX is Jacobian, the term is called FEPS in the program and is RMSD of the sum over all SZA.
Condition to stop iteration is that FEPS is less than 0.15, which is a mean value of measurement errors in N-values

ERR is the the RMSD of the residual fit (difference between observed  and retrieved N-values). There is no condition to stop iteration. You can use this parameter to decide if you like the conversion.
Typically I advise users to accept everything below 100. If it happens to be larger, than most likely you will have more thnan 3 iterations (2 and 3 are good profiles).