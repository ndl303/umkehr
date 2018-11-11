      SUBROUTINE STNDRD (PUFL,DPUF,HH,DHH,CHPN,SQCHP,NCP1,JC)
C ***** READS STANDARD PRESSURE-HEIGHT PROFILE AND INTERPOLATES FOR *
C ***** FORWARD MODEL CALCULATION ***********************************
      DIMENSION PUFL(61),HH(61),DHH(61),H(81),PS(81),DPUF(61)
      PI=ACOS(-1.)                                                      00005340
      R=6371.                                                           00005350


      DO 10 I=1,81                                                      00005360
   10 H(I)=FLOAT(81-I)                                                  00005370
      READ (11,1100) (PS(I),I=1,81)                                     00005430
 1100 FORMAT (4X,7E10.3)                                                00005440
      DO 30 I=1,81                                                      00005450
   30 PS(I)=ALOG(PS(I))                                                 00005460
      DO 35 I=1,40                                                      00005470
      K=82-I                                                            00005480
      SWAP=PS(I)                                                        00005490
      PS(I)=PS(K)                                                       00005500
      PS(K)=SWAP                                                        00005510
   35 CONTINUE                                                          00005520
      CALL SPLINE (81,PS,H,NCP1,PUFL,HH)                                00005530
      HH(NCP1)=0.0                                                      00005540
      HH(1)= HH(1)/R                                                    00005550
      DO 40 J=2,NCP1                                                    00005560
      HH(J)= HH(J)/R                                                    00005570
   40 DHH(J)=HH(J-1)-HH(J)                                              00005580
      DD=R+R*HH(1)                                                      00005590
      NUM=2*(JC+1)                                                      00005600
      NUMM=NUM-1                                                        00005610
      DH=0.5*R*(HH(1)+HH(2)-HH(NUM)-HH(NUMM))                           00005620
      SCALP=DH/ALOG(DPUF(NUM)/DPUF(2))                                  00005630
      CHP=0.5*DD/SCALP                                                  00005640
      CHPN=SQRT(CHP*PI)                                                 00005650
      SQCHP=SQRT(CHP)                                                   00005660
      RETURN                                                            00005670
      END                                                               00005700
