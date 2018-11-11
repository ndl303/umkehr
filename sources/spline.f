C ******************************************************************
      SUBROUTINE SPLSET(X,Y,M,C)                                        00006970
C ***** CALCULATES TABLE OF COEFFICIENTS FOR SPLINE INTERPOLATION ***
C***** X = INDEPENDENT VARIABLE                                         00006980
C***** Y = DEPENDENT VARIABLE                                           00006990
C***** M = NUMBER OF DATA POINTS IN THE X AND Y ARRAYS                  00007000
C***** C = COEFFICENTS OF THE CUBIC THAT IS FIT BETWEEN ADJACENT DATA PO00007010
C***** THE FOLLOWING DIMENSIONS MUST BE .GE. M                          00007020
      DIMENSION D(81), P(81), E(81), A(81,3), B(81), Z(81)
      DIMENSION X(m),Y(m),C(4,m)
      MM=M-1                                                            00007050
      DO 2 K=1,MM                                                       00007060
      D(K)=X(K+1)-X(K)                                                  00007070
      P(K)=D(K)/6.                                                      00007080
  2   E(K)=(Y(K+1)-Y(K))/D(K)                                           00007090
      DO 3 K=2,MM                                                       00007100
  3   B(K)=E(K)-E(K-1)                                                  00007110
      A(1,2)=-1.-D(1)/D(2)                                              00007120
      A(1,3)=D(1)/D(2)                                                  00007130
      A(2,3)=P(2)-P(1)*A(1,3)                                           00007140
      A(2,2)=2.*(P(1)+P(2))-P(1)*A(1,2)                                 00007150
      A(2,3)=A(2,3)/A(2,2)                                              00007160
      B(2)=B(2)/A(2,2)                                                  00007170
      DO 4  K=3,MM                                                      00007180
      A(K,2)=2.*(P(K-1)+P(K))-P(K-1)*A(K-1,3)                           00007190
      B(K)=B(K)-P(K-1)*B(K-1)                                           00007200
      A(K,3)=P(K)/A(K,2)                                                00007210
  4   B(K)=B(K)/A(K,2)                                                  00007220
      Q=D(M-2)/D(M-1)                                                   00007230
      A(M,1)=1.+Q+A(M-2,3)                                              00007240
      A(M,2)=-Q-A(M,1)*A(M-1,3)                                         00007250
      B(M)=B(M-2)-A(M,1)*B(M-1)                                         00007260
      Z(M)=B(M)/A(M,2)                                                  00007270
      MN=M-2                                                            00007280
      DO 6 I=1,MN                                                       00007290
      K=M-I                                                             00007300
  6   Z(K)=B(K)-A(K,3)*Z(K+1)                                           00007310
      Z(1)=-A(1,2)*Z(2)-A(1,3)*Z(3)                                     00007320
      DO 7 K=1,MM                                                       00007330
      Q=1./(6.*D(K))                                                    00007340
      C(1,K)=Z(K)*Q                                                     00007350
      C(2,K)=Z(K+1)*Q                                                   00007360
      C(3,K)=Y(K)/D(K)-Z(K)*P(K)                                        00007370
  7   C(4,K)=Y(K+1)/D(K)-Z(K+1)*P(K)                                    00007380
      RETURN                                                            00007390
      END                                                               00007400
C
      SUBROUTINE SPLINE (N,X,Y,M,A,B)                                   00006760
C ***** PERFORMS SPLINE INTERPOLATION USING ROUTINE SPLSET **********
      DIMENSION C(4,81),X(n),Y(n),A(m),B(m)
      CALL SPLSET (X,Y,N,C)                                             00006780
      NM=N-1                                                            00006790
      J=1                                                               00006800
      XD=A(1)                                                           00006810
      DO 20 I=1,NM                                                      00006820
      IP=I+1                                                            00006830
      IF (XD.GT.X(IP)) GO TO 20                                         00006840
   10 DA=X(IP)-XD                                                       00006850
      DB=XD-X(I)                                                        00006860
      B(J)=DA*(C(1,I)*DA**2+C(3,I)) + DB*(C(2,I)*DB**2+C(4,I))          00006870
      J=J+1                                                             00006880
      IF (J.GT.M) GO TO 30                                              00006890
      XD=A(J)                                                           00006900
      IF (XD.GT.X(I) .AND. XD.LE.X(IP)) GO TO 10                        00006910
      IF (XD.LE.X(1)) GO TO 10                                          00006920
   20 CONTINUE                                                          00006930
   30 CONTINUE                                                          00006940
      RETURN                                                            00006950
      END                                                               00006960
