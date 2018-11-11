C ******************************************************************
C **** SUBROUTINE TO CREATE SASC STANDARD PROFILES ******************
C ****  FG is based on seasonal cycle in all 16 layers, NOT the total ozone
C **** OMOBS is used to normalize seasonal FG to the observed total ozone
C **** INPUT INCLUDES LATITUDE BAND NUMBER 1,...,6                      00007430
C ****                DAY AND MONTH TO GET JULIAN DAY                   00007440
C ****                TOTAL OZONE IN M ATM-CM                           00007450
C ****                                                                  00007460
      SUBROUTINE SASCO3 (ID,IFGLAT,PNOT,OMOBS,TDX)
      IMPLICIT NONE
      REAL    PNOT,  OMOBS, TDX(16)
      INTEGER ID(7), IFGLAT

      REAL    C(14,13,3),SX(16)
      INTEGER MONTH(12),JUMP,JSMUTH,I,K,L,IM
      REAL C0, CNVRT,AJULDA, OM, RR,SWAP, DOM
C                                                                       ! UNUNSED ,R3(13)        00007470
C                                                                       ! UNUNSED DIMENSION STND325(11)

      DATA MONTH/0,31,59,90,120,151,181,212,243,273,304,334/            00007480
      DATA JUMP/0/                                                      00007490
      DATA C0/1.72142E-02/                                              00007500


      CNVRT=2.584E-03
      IF (JUMP.EQ.1) GO TO 50                                           ! If the first guess has no been loaded
      JUMP=1                                                            ! and flag that it has been loaded
      JSMUTH=1                                                          TEMP****
      DO 20 L=1,14                                                      00007530
      DO 20 K=1,3                                                       00007540
      READ (9,9000) (C(L,I,K),I=1,6)                                    TEMP****
      READ (9,9000) (C(L,I,K),I=7,13)                                   00007560
   20 CONTINUE                                                          00007570

   50 CONTINUE                                                          !First guess is loaded into memory

      AJULDA=FLOAT(ID(3)+MONTH(ID(4)))                                  00007630
      OM=1000.*OMOBS                                                    00007640
      DO 70 I=1,13                                                      00007760
      TDX(I)= C(IFGLAT,I,1)+
     1        C(IFGLAT,I,2)*COS(C0*(AJULDA-C(IFGLAT,I,3)))              00007770
 70   CONTINUE
      SX(13)=TDX(13)                                                    00007780
      DO 80 I=12,1,-1                                                   00007790
   80 SX(I)=SX(I+1)+TDX(I)                                              00007800
      RR=SX(13)/SX(12)                                                  00007990
      DO 90 I=14,16                                                     00008000
      IM=I-1                                                            00008010
      SX(I)=RR*SX(IM)                                                   00008020
      TDX(IM)=SX(IM)-SX(I)                                              00008030
   90 CONTINUE                                                          00008040
      TDX(16)=SX(16)
      DO 110 I=1,8                                                      00008080
      K=17-I                                                            00008090
      SWAP=TDX(I)                                                       00008100
      TDX(I)=TDX(K)                                                     00008110
      TDX(K)=SWAP                                                       00008120
  110 CONTINUE                                                          00008130
      DOM=2.*(1.-PNOT)*TDX(16)
      TDX(16)=TDX(16)-DOM
      DO 100 I=1,16                                                     00008060
  100 TDX(I)=0.001*TDX(I)
 9000 FORMAT (7E10.3)                                                   00008140
      RETURN                                                            00008150
      END                                                               00008160

