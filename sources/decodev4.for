      SUBROUTINE DECODE_CUMKEHR_OBS( )
      IMPLICIT NONE
C     CHARACTER *(*) INPUT_STATION_FILENAME
      INCLUDE 'umkehr_common.fix'

C *******************************************************************
C **** THIS IS DECODE PGM FOR PGM.MK2V4.NEWCUMK **** 22.NOV.1991 ****
c ***  ***** REVISED ***** 20.NOV.94*********************************
C *** FRONT END QUALITY CONTROL AND STATION BATCH INITIALIZATION        !00000010
C *** FOR NEW C-UMKEHR ALGORITHM USING BASS-PAUR OZONE ABSORPTION       !00000020
C *** COEFFICIENTS WITH TEMPERATURE EFFECT.                             !00000030
C *******************************************************************
      REAL      ERROR(14)                                               !00000060
      INTEGER   NVAL(14),NSTD(14,3),KZEN(14),JSH(12),NRES(14)           !00000050
      INTEGER   NRESDL(14),INTERP(14),NNVAL(14)                         !00000060
      REAL      XSTD(3),ALAT(100),PNOT(100),HGT(100)                    !00000070
      INTEGER   NNSTD(14),ISN(100)
      CHARACTER*18 STN(100)                                             !00000080
      INTEGER   CHOICE,AD(7)
      CHARACTER*300 ALINE
      INTEGER       IEOF

      CHARACTER*4 AD1
      CHARACTER*1 AD2
      CHARACTER*1 AD6
      CHARACTER*2 AD7
C     CHARACTER*11 result
C      CHARACTER*30 ft10
      INTEGER   JJ,MAX,MINSH,IB,IBP,KB,KE,MTEST,NTEST,ITAIL,JUMP,NPAG
      INTEGER   KEEP,JUZPRT,IBEG,IEND,NUMSTN,I,J,K,LAM,IOMEGA,ISTN
      INTEGER   ISNHLD,N,NSTN,IPAG,NERR,MIN,MAXSH
      REAL      FAC,AA,AB,SLAT,SPNOT,SHGT,XOMEGA,AC

      DATA MTEST,NTEST,NPAG/20,650,13/
      DATA KZEN/600,650,700,740,750,770,800,830,840,850,865,880,890,900/!00000110
      DATA AA,AB/1HE,1H /                                               !00000120
      DATA JSH/14,13,12,11,10,8,7,6,4,3,2,1/                            !00000130
      DATA XSTD/200.,350.,550./                                         !00000140

      ITAIL=99                                                          !00000150
      JUMP=0                                                            !00000160
c *** open input and output files ****
C     open (unit=10,file=ft10,status='new')
C     open (6,file='unit6.prn',status='new')
C      open (unit=12,file=INPUT_STATION_FILENAME,status='old')          Python now writes to an internal buffer
      CALL DECODE_OPEN_INPUTFILE(11)                                    !open (unit=11,file='stnindex.dat',status='old')
      CALL DECODE_OPEN_INPUTFILE(5)                                     !open (unit=5,file='decodev4.inp',status='old')
C      call time(result)
C      print*,'     start time:  ',result
C ****


                                                                        !00000170
      READ (5,5150) KEEP,JUZPRT,IBEG,IEND
C                                                                       !00000190
      READ (11,5300) NUMSTN,(ISN(I),STN(I),ALAT(I),PNOT(I),HGT(I),I=1   !00000200
     1 ,NUMSTN)                                                         !00000210
      READ (11,5100) ((NSTD(K,I),K=1,14),I=1,3)                         !00000220
C                                                                       !00000230
      I=0
C   1 READ (12,5200,END=600) AD1,AD2,(AD(J),J=3,5),AD6,LAM,AD7,IOMEGA,  !00000240
C    1 (NVAL(J),J=1,14),ISTN                                            !00000250
    1 CALL UMKEHR_READ_LINE( 12, IEOF, ALINE )
      IF (IEOF .NE. 0) GOTO 600
      READ(ALINE,5200) AD1,AD2,(AD(J),J=3,5),AD6,LAM,AD7,IOMEGA,
     1 (NVAL(J),J=1,14),ISTN
      I=I+1
      IF (I.LT.IBEG) GO TO 1
      IF (I.GT.IEND) GO TO 600
      IF (IOMEGA.LE.0) GO TO 1
c      if (lam.ne.3) go to 1
      IF (LAM.NE.3 .and. LAM.NE.5) GO TO 1                              
      IF (JUMP.EQ.1 .AND. ISTN.EQ.ISNHLD) GO TO 5                       !00000270
      IF (ISTN.NE.ISNHLD) GO TO 500                                     !00000280
   2  JUMP=1                                                            !00000290
      ISNHLD=ISTN                                                       !00000300
      DO 3 N=1,NUMSTN                                                   !00000310
      IF (ISTN.EQ.ISN(N)) THEN                                          !00000320
        NSTN=N                                                          !00000330
        SLAT=ALAT(N)                                                    !00000340
        SPNOT=PNOT(N)                                                   !00000350
        SHGT=HGT(N)                                                     !00000360
        WRITE (OUT10,7100) ISTN,STN(NSTN),SLAT,SPNOT,SHGT               !00000370
        CALL UMKEHR_WRITE_STRING( 10, OUT10)
        GO TO 5                                                         !00000380
      ENDIF                                                             !00000390
    3 CONTINUE                                                          !00000400
      WRITE (OUT6,9000) ISTN                                               !00000410
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      GOTO 9999                                                         !00000420
    5 CONTINUE
      IF (JUZPRT.EQ.0) GO TO 7                                          !00000440
      IPAG=I/NPAG+1                                                     !00000450
      IF (I-(IPAG-1)*NPAG.EQ.1) THEN
      WRITE (OUT6,6000) IPAG
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6,6001)(KZEN(K),K=1,14)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6,6002)                                                 !00000460
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
    7 CONTINUE                                                          !00000470
      XOMEGA=IOMEGA                                                     !00000480
      IF (JUZPRT.EQ.0) GO TO 8                                          !00000490
      WRITE (OUT6,6100) STN(NSTN), AD1,AD2,(AD(J),J=3,5),AD6,LAM,AD7,               !00000500
     1 XOMEGA,(NVAL(J),J=1,14)                                          !00000510
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
    8 CONTINUE                                                          !00000520
C                                                                       !00000530
      DO  10 J=1,14                                                     !00000540
      ERROR(J)=AB                                                       !00000550
      NNVAL(J)=-1                                                       !00000560
      NRES(J)=0                                                         !00000570
   10 NRESDL(J)=0                                                       !00000580
      AC=0.                                                             !00000590
      NERR=0                                                            !00000600
C                                                                       !00000610
      DO 20 J=1,14                                                      !00000620
      IF (NVAL(   J).LT.0) GO TO 20                                     !00000630
      MIN=J                                                             !00000640
      MAXSH=13-J                                                        !00000650
      GO TO 30                                                          !00000660
   20 CONTINUE                                                          !00000670
   30 IF(MAXSH.LE.7) MAXSH=MAXSH+1                                      !00000680
      IF (MAXSH.LE.4) MAXSH=MAXSH+1                                     !00000690
      DO 40 J=1,14                                                      !00000700
      JJ=15-J                                                           !00000710
      IF (NVAL(   JJ).LT.0) GO TO 40                                    !00000720
      MAX=JJ                                                            !00000730
      MINSH=J                                                           !00000740
      GO TO 50                                                          !00000750
   40 CONTINUE                                                          !00000760
C                                                                       !00000770
   50 IB=1                                                              !00000780
      IF (IOMEGA.GT.350) IB=2                                           !00000790
      IBP=IB+1                                                          !00000800
      FAC=(XOMEGA-XSTD(IB))/(XSTD(IBP)-XSTD(IB))                        !00000810
      DO 51 K=1,14                                                      !00000820
      NNSTD(K)=NSTD(K,IB)+INT(FAC*FLOAT(NSTD(K,IBP)-                    !00000830
     1 NSTD(K,IB)))                                                     !00000840
   51 CONTINUE                                                          !00000850
      DO 70 J=MIN,MAX                                                   !00000870
      IF (NVAL(   J).LT.0) GO TO 60                                     !00000880
      INTERP(J)=0                                                       !00000890
      NRES(J)=NVAL(J)-NNSTD(J)                                          !00000900
      IF(IABS(NRES(J)).GT.NTEST)NRES(J)=NRES(J)+1000                    !00000910
      IF(IABS(NRES(J)).GT.NTEST)NRES(J)=NRES(J)+1000                    !00000920
      GO TO 70                                                          !00000930
   60 INTERP(J)=1                                                       !00000940
   70 CONTINUE                                                          !00000950
C                                                                       !00000960
      DO 100 J=MIN,MAX                                                  !00000990
      IF (INTERP(J).EQ.0) GO TO 100                                     !00001000
      KB=J+1                                                            !00001010
      DO 80 K=KB,MAX                                                    !00001020
      IF (INTERP(K).EQ.1) GO TO 80                                      !00001030
      KE=K                                                              !00001040
      GO TO 90                                                          !00001050
   80 CONTINUE                                                          !00001060
   90 NRES(J)=NRES(J-1)+((NRES(KE)-NRES(J-1))*(KZEN(J)-KZEN(J-1)))/(KZEN!00001070
     1(KE)-KZEN(J-1))                                                   !00001080
  100 CONTINUE                                                          !00001090
      MIN=MIN+1                                                         !00000970
      MAX=MAX-1                                                         !00000980
C                                                                       !00001100
      CHOICE=1                                                          !00001110
      MAX=MAX-1                                                         !00001120
      GO TO 120                                                         !00001130
  110 CHOICE=0                                                          !00001140
      MIN=MIN-1                                                         !00001150
  120 DO 130 J=MIN,MAX,2                                                !00001160
      NRESDL(J+1)=NRES(J)-NRES(J+1)+((NRES(J+2)-NRES(J))*(KZEN(J+1)-KZEN!00001170
     1(J)))/(KZEN(J+2)-KZEN(J))                                         !00001180
      IF (IABS(NRESDL(J+1)).LT.MTEST) GO TO 130                         !00001190
      AC=1.                                                             !00001200
      NERR=NERR+1                                                       !00001210
      ERROR(J+1)=AA                                                     !00001220
  130 CONTINUE                                                          !00001230
      IF(CHOICE.EQ.1) GO TO 110                                         !00001240
C                                                                       !00001250
      DO 150 J=MINSH,MAXSH                                              !00001260
      JJ=JSH(J)                                                         !00001270
  150 NNVAL(J)=NRES(JJ)+NNSTD(JJ)                                       !00001280
C                                                                       !00001290
      IF (JUZPRT.EQ.0) GO TO 5605                                       !00001300
      IF (AC.GE.1.) GO TO 152                                           !00001310
      WRITE(OUT6,6200)(NRES(J),J=1,14)                                  !00001320
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE(OUT6,6200)(NRESDL(J),J=1,14)                                !00001320
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE(OUT6,6200)(NNVAL(J),J=1,12)                                 !00001320
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      GO TO 5605
                                                                        !00001330
  152 WRITE (OUT6,6300)(NRES(J),J=1,14),NERR,(NRESDL(J),ERROR(J),J=1,14)!00001340
     1,(NNVAL(J),J=1,12)                                                !00001350
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
C                                                                       !00001360
 5605 CONTINUE                                                          !00001370
      IF (KEEP.EQ.1) GO TO 154
      DO 153 J=1,14                                                     !00001380
      IF(IABS(NRESDL(J)).GT.30) GO TO 1                                 !00001390
  153 CONTINUE                                                          !00001400
  154 KE=13-MINSH                                                       !00001410
      KB=13-MAXSH                                                       !00001420
      WRITE (OUT10,7000) (AD(J),J=3,5),AD6,LAM,KB,KE,AD7,IOMEGA,          !00001430
     1 (NNVAL(J),J=12,1,-1),ISTN
      CALL UMKEHR_WRITE_STRING( 10, OUT10)                              !00001440
      GO TO 1                                                           !00001450
  500 IF (JUMP.EQ.1) THEN
      WRITE (OUT10,5150) ITAIL                                          !00001460
      CALL UMKEHR_WRITE_STRING( 10, OUT10)
      END IF
      JUMP=0                                                            !00001480
      GO TO 2                                                           !00001490
  600 CONTINUE                                                          !00001500
 9999 CALL DECODE_CLOSE_FILE(12)                                        !file = input file
      CALL DECODE_CLOSE_FILE(11)                                        !file = 'stnindex.dat'
      CALL DECODE_CLOSE_FILE(5)                                         !file = 'decodev4.inp'
      CALL UMKEHR_CLOSE_OUTPUT(6)
      CALL UMKEHR_CLOSE_OUTPUT(10)
                                                        !00001510
C      CALL TIME(result)
C     print*,'     end   time:   ',result
      RETURN                                                             !00001520
C                                                                       !00001530
 5150 FORMAT (2I2,2I5)
 5200 FORMAT (A4,A1,1X3I2,1XA1,I1,A2,I3,15I4)                           !00001550
 5300 FORMAT (I4/(I4,1X,A18,F7.2,2F5.0))
 5100 FORMAT (14I5)                                                     !00001570
 6000 FORMAT (38X,32HDETAIL SHEET FOR QUALITY CONTROL,30X,4HPAGE,I4)
 6001 FORMAT (44X,14I5)
 6002 FORMAT (114(1H*))
 6100 FORMAT (A18,1XA4,A1,2X,3I2,2X,A1,I1,1X,A2,F5.1,14I5)       
 6200 FORMAT (44X,14I5)                          
 6300 FORMAT (44X,14I5/31X 8HERRORS - I2,5X,14(I4,A1)/45X,12I5)         !00001620
 7000 FORMAT (3I2,A1,I1,I2,I2,A2,3I4,10I5,I3)                           !TEMP****
 7100 FORMAT (I4,1X,A18,1X,F8.2,2F6.0)                                  !00001640
 9000 FORMAT (' ISTN=',I4,' NOT IN STATION INDEX. RUN TERMINATED.')     !00001650
      END
