C----------------------------------------------------------------------
C   This is UMKV8                                             02.FEB.2004
C   IT IS THE MAIN PROGRAM FOR THE NEW C-UMKEHR INVERSION ALGORITHM
C   USING BASS-PAUR OZONE ABSORPTION COEFFICIENTS. THE ALGORITHM
C   FOLLOWS EQUATION 100 OF RODGER'S 1976 REVIEW IN REV. GEOPHYS.
C   & SPACE PHYS., 14(4), PP. 609-624.
C
C   Update 2018-11-12, Nick Lloyd for Irina Petropavlovskikh.
C   ---------------------------------------------------------
C   This is now a subroutine that contains the core of the original code
C   Input to the system is through a set of 12 input files and the
C   parameter KBN.
C
C   Parameters:
C       KBN : Inetger that provides the lowest SZA index.
C
C   Input files can be specified by users calling subroutine UMKEHR_SET_IONAMES.
C   The following 12 input files are utilized by the code. Note that some files
C   are loaded the first time the routine is called. Others are loaded every time.
C
C      Unit 5       'mk2v4cum.inp'
C      Unit 8       'stdmscdobc_depol_top5.dat'
C      Unit 9       'fstguess.99b'
C      Unit 10      'User supplied UMKEHR station file'/
C      Unit 11      'phprofil.dat'
C      Unit 13      'refractn.dat'
C      Unit 15      'nrl.dat'
C      Unit 18      'std_pfl.asc'
C      Unit 19      'stdjacmsc.dat'
C      Unit 79      'totoz_press.dat'
C      Unit 97      'coef_dobch.dat'
C      Unit 98      'coef_dobcl.dat'
C
C   Outpout originall sent to FORTRAN WRITE statements are now sent to
C   subroutine UMKEHR_WRITE_STRING. A default implementation is
C   provided in cimpl_emulator.f which can be used if generating a pure
C   fortran program. This function is replaced with C/C++ function when
C   building the python package.

C----------------------------------------------------------------------
      SUBROUTINE UMKEHR( KBN )
      IMPLICIT NONE
      INTEGER KBN

      INCLUDE 'umkehr_common.fix'

      REAL PUF(61),DPUF(61),PUFL(61),SLS(61),HH(61),DHH(61),
     1 DLIDX(61,2),SEPS(16),DLIDLX(61,12),DNMSCDX(61,12),SXN(61),
     1 TC(61),                                                            ! UNUSED ,TCO(61),
     2 DXN(61),TT(61),DTT(61),TDX(16),TDXN(16), DXNN(61),DXNO(61),
     3 PUL(16),TDXP(16),VNRT(12),SEPSIND(12),FRES(12),                    ! UNUSED ,DY1(12),
     3 COVF(61,61),THENOT(12),TENSTY(2),VALN(12),                         ! UNUSED SXINV(61,61),VARN(12)
     4 SERX(61),DY(12),DYMKDX(12),AVARS(61,61),AKSX(12,61),               ! UNUSED FVEC(61),
     4 AKTSE(61,12),AKTSEK(12,12),AKTSEKI(12,12),AKTF(61,12),
     4 AVK(61,61),                                                        ! UNUSED AKTSEKK(61,61),CQ(3,3),DXT(61),CQMSS(12,9)
     5 ALFA(2),BETA(2),CQMSC(12),CQMST(12),VNFG(12),DXFG(61),
     6 AK(12,61),VNOB(12),FSOL(61,9),RES(12),FORSHD(12),CHPP(61,12),
     7 AKO(12,61),ALFT(61,2),ACOFT(2),DELT(61),                           ! UNUSED SEPSIN(12)
     9 ACOFTS(2),ALFBAR(2),gz(61),BETAG(61,2)

      INTEGER ID(7)

      REAL P3BAR(61),P3DEV(61),ERROR(61),VARED(61),SRES(61),
     1 SEPSD(11), DPS(45),PSL(45),HS(61),
     2 COVF8(8,8),AK8(12,8),DNDLOG16(16,12),DNDLOG8(8,12),
     3 TDX8(8),TDXN8(8),AKTSE8(8,12),AKTSEK8(12,12),AKTSEKI8(12,12),
     4 AKSX8(12,8),AKTF8(8,12),AVK8(8,8)                                 ! UNUSED ,PAVK8(8,8)

C Irina update 9/30/2002

      REAL totozbt(21),totozp(21),CQMSP(12,21),
     1 tenstysf(202),dlidxsf(61,202),
     1 sumdxl(61), sumdxh(61)                                            ! UNUSED , dlidxw(61,2)

      DATA totozbt/225,275,325,225,275,325,375,425,475,525,575,125,
     * 175,225,275,325,375,425,475,525,575/

      INTEGER KE,IOMEGA,ISTN,J1MAX,LATSKIP,J1,J2,J11,J12,IP,
     1 IFGLAT,JUMP,IMAX,MI,JMAX,LL,MEQ,MEQM,KBP,ITER,
     2 JTERM, ITMAX, JUZOUT,JUZDSK,JSX,JUZPR,JUZFGR,JUTMPR,
     3 NC,NCP1,JC,L1,L2,L3,MM,K,NR1,I, NR2,NR12,II,J,
     4 ISN,IB, ILAT,ITLAT, NITER,ISOL,NSOL,LAM,KB,L,
     5 ITEMPCORR, ITM, IJ, NN, KK, LYR,IOS

      REAL OMOBS,OMFG,TI,TIL,TIM,DHS,FSTLAT,ISTLAT,P1,P2,FFL1,FFL2,
     1 FFF2,FFF1,SUM, TABJ1,TABJ2,TABI1,TABI2,SUMF,NCP,OMCHEK,GGG1,
     2 GGG2,FGFLAT,RCOF,TFAC,SUMSF,SUMX,ALFAC,ALFACSF,OMSOL,TDX12,
     3 TDX10,TDX1,OMSDEV,AMUO,FUM,SUML,FUMT,SUMS,CON,SUMH,
     4 SUM1,DTDALFA,SUM2,CORR,FEPS,DUM,RMSRES,DFRMS,DFSOL,DFS,
     5 SUMSOL,R,PI,WTX,OMFAC,DPSL,VARX,AN,
     6 SUMSL,SUMSH,SWAP,CHPN,SQCHP,DD,DH,SCALX,CHX,CHXN,
     7 SQCHX,ALAT, PNOT,HGT,PSQ,FLAT,TFLAT,GZ0,RESBAR,
     8 RESDEV,OMOBAR,OMODEV,OMSBAR,
     9 CNVRT

                                                                         ! UNUSED character*11 result
C     character*60 ft4,ft6,ft14                                          ! UNUSED ,ft12
      CHARACTER*72 HEAD                                                  ! TEMP****
      CHARACTER*18 STATN                                                 ! TEMP****
      INTEGER IL(61), ISZA(4)
      REAL DET
                                                                        !00000140
C *******************************************************************
C ***** INITIALIZATION SEGMENT **************************************
C *******************************************************************
c     DATA HEAD/80H***New Shortwave Algorithm with FG=STD, Temperature, 
c    1ALT, and MS Corrections****/
c C-pair, 311.5 and 332.8 weighted with measured slit function (Komhyr)
      DATA ALFA/2.1960,0.1151/
      DATA ACOFT/5.6383E-3,6.8329E-4/                                   !00000160
      DATA ACOFTS/2.9501E-5,3.8094E-6/                                  !00000170
      DATA BETA/1.0362,0.7845/                                          !00000180
      DATA ISZA/5,7,9,11/  
      DATA SEPSD/0.33,0.37,0.41,0.45,0.49,0.53,0.57,0.61,0.8,1.2,1.6/  
      DATA THENOT/60.,65.,70.,74.,77.,80.,83.,85.,86.5,88.,89.,90./     !00000220


      CALL UMKEHR_OPEN_INPUTFILE(10)                                        ! open (unit=10,file=ft10,status='old')
      CALL UMKEHR_OPEN_INPUTFILE(11)                                        ! open (unit=11,file='phprofil.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(13)                                        ! open (unit=13,file='refractn.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(9)                                         ! open (unit=9,file='fstguess.99b',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(8)                                         ! open (unit=8,file='stdmscdobc_depol_top5.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(18)                                        ! open (unit=18,file='std_pfl.asc',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(19)                                        ! open (unit=19,file='stdjacmsc.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(15)                                        ! open (unit=15,file='nrl.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(98)                                        ! open (unit=98,file='coef_dobcl.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(97)                                        ! open (unit=97,file='coef_dobch.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(79)                                        ! open (unit=79, file='totoz_press.dat',status='old')
      CALL UMKEHR_OPEN_INPUTFILE(5)                                         ! open (unit=5,file='mk2v4cum.inp',status='old')

C      print*,'input file name for retrieval statistics output:   '
C      read*,ft6
C      open (unit=6,file=ft6,status='new')
C     print*,'     input name of nucumout file:   '
CC     read*,ft4
C     ft4='umout'
C      open (unit=4,file=ft4,status='unknown')
CC     print*,'     input name of nucprint file:   '
CC     read*,ft14
C     ft14='uprint'
C      open (unit=14,file=ft14,status='unknown')
C
c     call time (result)
c     print*,'     start time:   ',result


c **** end of open statements and printing start time *****
      R=6371.                                                            !00000230
      PI=ACOS(-1.)                                                       !00000240
      CNVRT=PI/180.                                                      !00000250
      WTX=100.                                                           !00000260
      ITMAX=5                                                            !00000270
      READ (5,5000) JUZOUT,JUZDSK,OMFAC,JSX
      JUZPR=0
      JUZFGR=0
      JUTMPR=0
      CALL LAYER (PUL,PUFL,PUF,DPUF,DPSL,NC,NCP1,JC)                     !00000300
      VARX=1e-5
c SZA dependent noise (Arosa 51 and 101)
      MM=0                                                               !00000420
      DO 150 K=1,11                                                      !00000440
      MM=MM+1                                                            !00000480
      SEPS(MM)=SEPSD(K)**2
      SEPSIND(MM)=1.0/SEPS(MM)                                           !00000500
  150 CONTINUE                                                           !00000510
      MM=MM+1                                                            !00000520
      SEPS(MM)=VARX*(WTX**2)                                             !00000530
      SEPSIND(MM)=1./SEPS(MM)                                            !00000540

      CALL RDSPECT(SUMSL,SUMSH, NR1,NR2,NR12)                            ! READ spectral parameters
      CALL READFG()                                                      ! READ FG, READ Total ozone at pressure levels 0.5, 0.8, 0.7, 0.9
      CALL RDMSCR()                                                      ! READ MULTIPLE SCATTERING CORRECTIONS
      CALL RDNRL()                                                       ! Read in NRL temperature/altitude climatology for monthly mean and zonal
      CALL RDREFR()                                                      ! READ REFRACTION CORRECTIONS
      CALL STNDRD (PUFL,DPUF,HH,DHH,CHPN,SQCHP,NCP1,JC)
      DD=R+R*HH(1)                                                      !00000690
      DH=R*(HH(1)-HH(9))                                                !00000700
      SCALX=DH/1.282                                                    !00000710
      CHX=0.5*DD/SCALX                                                  !00000720
      CHXN=SQRT(PI*CHX)                                                 !00000730
      SQCHX=SQRT(CHX)                                                   !00000740
      CALL SLANTS (NCP1,THENOT,SQCHP,CHPN,SQCHX,CHXN,HH,DHH,CHPP)       !00000750



C *******************************************************************
C *****END OF INITIALIZATION SEGMENT ********************************
C ***** BEGIN PROCESSING DATA FOR FIRST UMKEHR STATION **************
C ***** INITIALIZATION FOR STATION BATCH OF UMKEHR DATA *************
C *******************************************************************

  190 READ (10,5010, END=9999, IOSTAT=IOS) ISN,STATN,ALAT,PNOT,HGT      !TEMP****
      IF (IOS .NE. 0) THEN
         GOTO 9999
      END IF
      WRITE(OUT6, 5010) ISN,STATN,ALAT,PNOT,HGT                         !TEMP****
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      
      PNOT=PNOT/1013.25                                                 !TEMP****
      nc=15*jc
      ncp1=nc+1
      IB=NCP1-JC
      DO 200 I=IB,NCP1
      IF (PNOT.LE.PUF(I)) THEN
         PSQ=SQRT(PUF(I)*PUF(I-1))
         NCP1=I
         IF (PNOT.LT.PSQ) NCP1=I-1
         NC=NCP1-1
      ENDIF
  200 CONTINUE
      PUL(16)=PUFL(NCP1)                                                !00000830
C *** DETERMINE ILAT AND FLAT FOR STD PROFILE CALCULATION ***********
      FLAT=(105.-ALAT)/30.                                              !TEMP****
      IF (FLAT.LE.1.0) FLAT=1.0001                                      !TEMP****
      IF (FLAT.GE.6.0) FLAT=5.9999
      ILAT=INT(FLAT)                                                    !TEMP****
      FLAT=FLAT-FLOAT(ILAT)                                             !TEMP****
      IF (ILAT.EQ.3 .AND. ALAT.LE.0.) THEN
         ILAT=4
         FLAT=0.
      ENDIF
      TFLAT=(100.+ALAT)/10.
      IF (TFLAT.LE.1.0) TFLAT=1.0001
      IF (TFLAT.GE.19.0) TFLAT=18.9999
      ITLAT=INT(TFLAT)
      TFLAT=TFLAT-FLOAT(ITLAT)

      gz0=9.780356*(1+0.0052885*sin(alat*pi/180)**2
     * -0.0000059*sin(2*alat*pi/180)**2)
C *** CONTINUE INITIALIZATION FOR THIS STATION BATCH ****************
      NITER=0
      ISOL=0                                                            !00000840
      NSOL=0                                                            !00000850
      RESBAR=0.                                                         !00000860
      RESDEV=0.                                                         !00000870
      OMOBAR=0.                                                         !00000880
      OMODEV=0.                                                         !00000890
      OMSBAR=0.                                                         !00000900
      OMSDEV=0.                                                         !00000910
      DO 218 I=1,61
      P3BAR(I)=0.                                                       !00000930
      P3DEV(I)=0.                                                       !00000940
      ERROR(I)=0.                                                       !00000950
  218 VARED(I)=0.                                                       !00000960
C *******************************************************************
C ***** END OF INITIALIZATION FOR THIS STATION **********************
C ***** READ STANDARD C-UMKEHR DATA FOR THIS STATION ****************
C *******************************************************************
  220 READ (10,5600,END=900) (ID(I),I=3,6),LAM,KB,KE,ID(7),             !TEMP****
     1 IOMEGA,(VNOB(K),K=1,12),ISTN                                     !00000980
c       KBN=5
        if(KB.lt.KBN) KB=KBN

C ***** CHECK FOR END OF BATCH FOR THIS STATION *********************
      IF (ID(3).EQ.99) GO TO 900                                        !TEMP****
      IF (ISTN.NE.ISN) THEN                                             !TEMP****
         WRITE (OUT6,9001) ISTN,ISN                                     !TEMP****
         CALL UMKEHR_WRITE_STRING(6, OUT6)
         CALL CONSOLEMSG('ISTN does not equal Station Number.Sync lost')
         GOTO 9999                                                      !TEMP****
      ENDIF                                                             !TEMP****
C ***** CHECK FOR SOLAR ZENITH ANGLE RANGE FOR THIS UMKEHR **********
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      OMOBS=0.001*FLOAT(IOMEGA)                                         !00001090
      OMOBS=OMOBS*OMFAC
      OMFG=OMOBS                                                        !TEMP****
      ISOL=ISOL+1                                                       !TEMP****
      IF (MOD(ISOL,6).EQ.1 .AND. JUZDSK.EQ.0) THEN
         WRITE (OUT6,6000) HEAD
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
         WRITE (OUT6,6001) ALAT,PNOT,HGT
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
         WRITE (OUT6,9000)
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      ENDIF
      IF (JUZDSK.EQ.1 .AND. MOD(ISOL,15).EQ.1) THEN
         WRITE (OUT14,4000) HEAD
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
         WRITE (OUT14,4001) ALAT,PNOT,HGT
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
      ENDIF
      IF (JUZDSK.EQ.0) THEN
      WRITE(OUT6,6100) STATN,(ID(I),I=3,5),LAM,ID(6),KB,KE,ID(7),
     1 OMOBS*1000
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      ELSE
      WRITE(OUT14,4011)STATN,(ID(I),I=3,5),LAM,ID(6),KB,KE,ID(7),
     1 OMOBS*1000
      CALL UMKEHR_WRITE_STRING( 14, OUT14)
      WRITE(OUT14,6401)(VNOB(K),K=KB,KE)
      CALL UMKEHR_WRITE_STRING( 14, OUT14)
      ENDIF

C ****************************************************
C Use NRL altitude/temperature climatology for a given month and latitude
C ****************************************************
      i=1
      TI=(1-TFLAT)*TNRL(ID(4),I,ITLAT)+TFLAT*TNRL(ID(4),I,ITLAT+1)
      PSL(I)=1.
      TIL=TI
       DO I=2,45
        ii=45-i+1
      TI=(1-TFLAT)*TNRL(ID(4),I,ITLAT)+TFLAT*TNRL(ID(4),I,ITLAT+1)
      TIM=0.5*(TI+TIL)
      gz(i)=gz0 - HM(ii)*0.003086
      DPS(I)=gz(I)*3.483637*(HM(ii)-HM(ii+1))/TIM
      PSL(I)=exp(log(psl(i-1))-dps(i))
      TIL=TI
      end do
       DO I=1,45
      PSL(I)=ALOG(PSL(I))
      end do
       DO  I=1,22
      K=46-I
      SWAP=PSL(I)
      PSL(I)=PSL(K)
      PSL(K)=SWAP
      end do
      CALL SPLINE (45,PSL,HM,NCP1,PUFL,HS)
      DO  I=2,NCP1
      DHS=HS(i-1)-HS(i)

      gz(i)=gz0 - HS(i)*0.003086
      TC(I)=gz(I)*3.483637*DHS/(PUFL(I)-PUFL(I-1))-273.15
      end do

C ***** CALCULATION OF FIRST GUESS PROFILE **************************
C ***** CALCULATE MULTIPLE SCATTERING CORRECTIONS TO FG N-VALUES **
C Latitude bands are 0-30 (3,4), 30-60,(2,5) and 60-90 (1,6)
      FSTLAT=(120.-ALAT)/30.
      IF (FSTLAT.LE.1.0) FSTLAT=1.0001
      IF (FSTLAT.GE.7.0) FSTLAT=6.9999
      ISTLAT=INT(FSTLAT)             

         if(ISTLAT.eq.3.or.ISTLAT.eq.4)J1MAX=2
         if(ISTLAT.eq.2.or.ISTLAT.eq.5)J1MAX=7
         if(ISTLAT.eq.1.or.ISTLAT.eq.6)J1MAX=9
         if(ISTLAT.eq.3.or.ISTLAT.eq.4)LATSKIP=0
         if(ISTLAT.eq.2.or.ISTLAT.eq.5)LATSKIP=3
         if(ISTLAT.eq.1.or.ISTLAT.eq.6)LATSKIP=11

C ***** CALCULATION OF FIRST GUESS PROFILE **************************
c***** CALCULATE MULTIPLE SCATTERING CORRECTIONS TO FG N-VALUES **

C Correct for altitude of the station
          p1=1.
          p2=0.5
          pi=PNOT
          ffl1=(p2-pi)/(p2-p1)
          ffl2=(pi-p1)/(p2-p1)
          do i=1,21
          do k=1,12
C Use interpolation of tabulated MSC, and Eff. X-section correction
C  to pressure altitude of the station
          CQMSP(k,i)=ffl1*CQMS(k,i)+ffl2*CQMS(k,i+21)
           end do
          totozp(i)=ffl1*totozbt(i)/1000+ffl2*totoztp(i)
           end do

C Correct for total ozone

           if (OMOBS.lt.totozp(1+LATSKIP)) j1=1
               do i =2, J1MAX
      if (OMOBS.lt.totozp(i+LATSKIP).and.OMOBS.ge.totozp(i-1+LATSKIP))
     1 j1=i-1
              end do
           if (OMOBS.ge.totozp(J1MAX+LATSKIP)) j1=J1MAX
                   j2=j1+1
         j11=j1+latskip
         j12=j11+1
          FFF2=(totozp(j12)-OMOBS)/(totozp(j12)-totozp(j11))
          FFF1=(OMOBS-totozp(j11))/(totozp(j12)-totozp(j11))

                 sum=0.
      DO  I=1,NCP1
      DXFG(I)=FFF2*TABJMS(I,13,J11)+FFF1*TABJMS(I,13,J12)
      DXFG(I)=DXFG(I)/1000
        sum=sum+DXFG(I)
         end do


      DO 10 K=KB,KE 
      CQMST(K)=FFF2*CQMSP(K,J11)+FFF1*CQMSP(K,J12)

      DO  I=1,NCP1
       tabj1=TABJMS(I,K,J11)
       tabj2=TABJMS(I,K,J12)
       tabi1=TABJMS(I,13,J11)/1000
       tabi2=TABJMS(I,13,J12)/1000
      DNMSCDX(I,K)=(FFF2*tabj1+FFF1*tabj2)/
     *             (FFF2*tabi1+FFF1*tabi2)
         end do
 10    continue
c     write(44,*)IOMEGA,(CQMST(K),k=1,12)
C     CALL UMKEHR_WRITE_STRING( 44, OUT6)
c Correct standard profile for observed TO by adjusting ozone in the lowermost layer
      sumf=sum-DXFG(NCP1)
      DXFG(NCP1)=OMOBS-sumf
      if (DXFG(NCP1).lt.0.) then
         DXFG(NC)=DXFG(NC)+OMOBS-sumf
         DXFG(NCP1)=1.e-9
         WRITE(OUT6,*)ID(3),ID(4),ID(5),ID(6),OMOBS,sumf,DXFG(NCP),
     1                DXFG(NCP1)
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      end if

C ****** APPLY REFRACTION CORRECTIONS TO OBSERVED N-VALUES***********
      DO 16 I=1,4
      IP=I+1
      OMCHEK=OMOBS
      IF (OMOBS.GT.0.55) OMCHEK=0.55
      IF (OMCHEK.GT.TOTREF(I) .AND. OMCHEK.LE.TOTREF(IP)) THEN
         GGG1=(TOTREF(IP)-OMOBS)/(TOTREF(IP)-TOTREF(I))
         GGG2=1.0-GGG1
         DO 15 K=KB,KE
   15    VNOB(K)=VNOB(K)-GGG1*REFCOR(K,I)-GGG2*REFCOR(K,IP)
      ENDIF
   16 CONTINUE
c      WRITE(*,*)(VNOB(K),K=KB,KE)

C ***** CALCULATION OF A PRIORI PROFILE **************************
c Use of new a priori coefficients require new latitude index system
c there are 14 latitude bands starting with 75 N, then 55N,45N...45S,55S, 75S
      FGFLAT=(80.-ALAT)/10.
      IF (FGFLAT.LE.1.0) FGFLAT=1.0001
      IF (FGFLAT.GE.14.0) FGFLAT=14.0001
      IFGLAT=INT(FGFLAT)

      JUMP=1
  221 CONTINUE
      CALL SASCO3 (ID,IFGLAT,PNOT,OMOBS,TDX)
  224 CONTINUE
         
      CALL EXPAND (PUL,TDX,NCP1,PUFL,SXN,DXN)
C FG=STD
      DO 245 I=1,NCP1
      DXNN(I)=DXFG(I)
      FSOL(I,1)=DXFG(I)-DXN(I)
  245 CONTINUE                                                          !00001520
       	sum=0
      DO  I=1,NCP1
       	sum=sum+FSOL(I,1)
       	end do
      IF (JUZPR.eq.1) THEN
      	WRITE (OUT6,*)'FSOL0',sum, (FSOL(I,1),I=1,61)
      	CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      TDXP(1)=DXN(1)
      IMAX=14*JC+2                                                      !00002470
      MI=1
      DO 7450 I=2,IMAX,JC                                               !00002480
      MI=MI+1                                                           !00002490
      TDXP(MI)=0.
      JMAX=I+JC-1                                                       !00002510
      IF (JMAX.GT.NCP1) JMAX=NCP1                                       !00002520
      DO 7450 J=I,JMAX                                                  !00002530
      TDXP(MI)=TDXP(MI)+DXN(J)
 7450 CONTINUE                                                          !00002550


C*********************************
C     Corrections made by Irina  6/25/99
C     to incorporate gravity acceleration at altitude H
c T=g(z)*dz*M/R/dlog(P), where R/M=287.05 J/kg/K, if g(z)=9.806, g(z)*R/M=34.16316

c     gz0=9.780356*(1+0.0052885*sin(alat*pi/180)**2
c    * -0.0000059*sin(2*alat*pi/180)**2) 
      RCOF=0.003086*R
      gz(1)=gz0 - hh(1)*RCOF
      BETAG(1,1)=BETA(1)*gz0/gz(1)
      BETAG(1,2)=BETA(2)*gz0/gz(1)
      sfbetag(1,1)=sfbeta(1)*gz0/gz(1)
      sfbetag(1,2)=sfbeta(2)*gz0/gz(1)
      do ll=1,nr12
      betagw(1,ll)=betaw(ll)*gz0/gz(1)
      end do
      DO 247 I=2,NCP1
      gz(i)=gz0 - hh(i)*RCOF
      DELT(I)=gz(I)*3.483637*R*DHH(I)/(PUFL(I)-PUFL(I-1))-273.15
c***********************************
      TFAC=1.0112 - 0.6903 / (87.3 - DELT(I))

      DO 246 L=1,2
      ALFT(I,L)=(ALFA(L)+DELT(I)*(ACOFT(L)+DELT(I)*ACOFTS(L)))*TFAC
      BETAG(I,L)=BETA(L)*gz0/gz(i)
      IF (I.GT.2) GO TO 246
      ALFT(1,L)=ALFT(2,L)
  246 CONTINUE
      DO 1246 L=1,2
      sfalft(I,L)=sfalfa(L)+DELT(I)*(sfacoft(L)+DELT(I)*sfacofts(L))
      sfalft(I,L)=sfalft(I,L)*TFAC
      sfbetag(I,L)=sfbeta(L)*gz0/gz(i)
      IF (I.GT.2) GO TO 1246
      sfalft(1,L)=sfalft(2,L)
 1246 CONTINUE
      do ll=1,nr12
      alftw(i,ll)=alfaw(ll)+DELT(I)*(acoftw(ll)+DELT(I)*acoftsw(ll))
      alftw(i,ll)=alftw(i,ll)*TFAC
      betagw(i,ll)=betaw(ll)*gz0/gz(i)
      IF (I.EQ.2) alftw(1,ll)=alftw(2,ll)
      end do
  247 CONTINUE
      DO 2474 L=1,2
      SUM=0.
      sumsf=0.
      SUMX=0.
      DO 2472 I=1,NCP1
      sumsf=sumsf+sfalft(I,L)*DXNN(I)
      SUM=SUM+ALFT(I,L)*DXNN(I)
      SUMX=SUMX+DXNN(I)
 2472 CONTINUE
      ALFBAR(L)=SUM/SUMX
      sfalfbar(L)=sumsf/SUMX
 2474 CONTINUE
      ALFAC=ALFBAR(1)-ALFBAR(2)
      alfacsf=sfalfbar(1)-sfalfbar(2)
      OMFG=SUMX                                                        
      OMSOL=OMFG                                                        !TEMP****

C Save AP ozone profile
       TDX12=0.
       do i=1,4
       TDX12=TDX12+TDX(i)
       end do
       TDX10=0.
       do i=1,6
       TDX10=TDX10+TDX(i)
       end do
       TDX1=TDX(15)+TDX(16)
       WRITE(OUT22,8102)(ID(I),I=3,5),OMOBS*1000,TDX12*1000,
     *(TDX(i)*1000,i=5,16)
       CALL UMKEHR_WRITE_STRING( 22, OUT22)
       WRITE (OUT14,6601)TDX10*1000,(TDX(i)*1000,i=7,14),TDX1*1000
       CALL UMKEHR_WRITE_STRING( 14, OUT14)


C *******************************************************************
C ***** Create a PRIORi INFORMATION MATRICES                            !00000310
C ***** PROFILE COVARIANCE MATRIX                                       !00000320
      do i=1,NCP1
        IL(I)=i
      do j=1,NCP1
      if (i.ne.j) COVF(I,J)=0.1*DXN(i)*DXN(j)*EXP(-IABS(i-j)/5.)
      if (i.eq.j) COVF(I,J)=0.1*DXN(i)*DXN(j)
      end do
      end do
C************ 8-layer output
      TDX8(1)=0.0
      do i=1,7
      TDX8(1)=TDX8(1)+TDX(i)
      end do
      do i=2,6
      TDX8(i)=TDX(i+6)
      end do
      TDX8(7)=TDX(13)+TDX(14)
      TDX8(8)=TDX(15)+TDX(16)

      do i=1,8
      do j=1,8
      if (i.ne.j) COVF8(I,J)=0.1*TDX8(i)*TDX8(j)*EXP(-IABS(i-j)/5.)
      if (i.eq.j) COVF8(I,J)=0.1*TDX8(i)*TDX8(j)
      end do
      end do

C ******************************************************************
      MEQ=KE-KB+1                                                       !00001290
      MEQM=MEQ-1                                                        !00001300
      KBP=KB+1                                                          !00001310
      DO 242 K=1,NCP1
      AK(MEQ,K)=WTX
  242 CONTINUE                                                          !00001400
      IF (JUZFGR .EQ. 1) THEN                                            !TEMP****
      WRITE (OUT6,9050) (I,TDX(I),I=1,16)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZFGR.EQ.1) THEN
      WRITE (OUT6,9000)                                                    !TEMP****
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.0) GO TO 244                                         !00001460
      WRITE (OUT6,9000)                                                    !00001480
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
  244 CONTINUE                                                          !00001490
      DO 2451 I=1,16                                                    !00001500
      TDXN(I)=TDX(I)                                                    !00001510
 2451 CONTINUE                                                          !00001520
      DY(MEQ)=WTX*(OMOBS-OMFG)                                          !TEMP****
      DYMKDX(MEQ)=DY(MEQ)                                               !TEMP****
C FG=STD
      FORSHD(MEQ)=DYMKDX(MEQ)
      DO     K=KB,KE                                                    !00001850
      CQMSC(K)=CQMST(K)
       END DO
C ***** COMMENCE INVERSION ITERATIONS ******************************
      ITER=0                                                            !00001800
          ITEMPCORR=0
  250 ITER=ITER+1
       ITM=ITER-1
C ***** FORWARD (PHYSICAL) MODEL CALCULATION ************************
C ***** COMPUTE N-VALUES AND PARTIAL DERIVATIVES FOR FG PROFILE *****
C ***** MAIN LOOP THROUGH ZENITH ANGLE ******************************
      DO 430 K=KB,KE                                                    !00001850
      AMUO=COS(CNVRT*THENOT(K))                                         !00001860
      FUM=3./16.*(1.+AMUO**2)*DPSL                                      !00001870
C ***** SUB-LOOP THROUGH WAVELENGTH *********************************
        suml=0
      DO i =1,NCP1
          sumdxl(i)=0
       end do
      DO 400 L=1,nr1
      IJ=0                                                              !00001900
      SUM=0.                                                            !00001910
      FUMT=FUM*betagw(1,L)
      DTT(1)=alftw(1,L)*DXNN(1)+betagw(1,L)*DPUF(1)
      TT(1)=DTT(1)                                                      !00001940
      dlidxsf(1,L)=0.
      DO 300 I=2,NCP1                                                   !00001950
      SLS(I)=1.                                                         !00001960
      DTT(I)=alftw(I,L)*DXNN(I)+betagw(I,L)*DPUF(I)
      TT(I)=DTT(I)+TT(I-1)                                              !00001980
      dlidxsf(I,L)=0.                                                   !00001990
  300 CONTINUE                                                          !00002000
      DO 350 I=1,NCP1                                                   !00002010
      DO 310 J=1,I                                                      !00002020
      IJ=IJ+1                                                           !00002030
  310 SLS(J)=SLANT(K,IJ)                                                !00002040
      SUMS=alftw(1,L)*SLS(1)*DXNN(1)+betagw(1,L)*CHPP(I,K)*DPUF(1)
      IF (I.EQ.1) GO TO 330                                             !00002060
      DO 320 J=2,I                                                      !00002070
  320 SUMS=SUMS+SLS(J)*DTT(J)                                           !00002080
  330 CON=PUF(I)*EXP(-SUMS-TT(NCP1)+TT(I))                              !00002090
      IF (I.EQ.NCP1) CON=0.5*CON                                        !00002100
  335 SUM=SUM+CON                                                       !00002110
      DO 340 J=1,NCP1                                                   !00002120
  340 dlidxsf(J,L)=dlidxsf(J,L)-alftw(J,L)*CON*SLS(J) 
  350 CONTINUE                                                          !00002140
      tenstysf(L)=FUMT*SUM                                              !00002150
C CHANGE DLIDX to SF weighted
      DO 360 I=1,NCP1                                                   !00002160
  360 dlidxsf(I,L)=dlidxsf(I,L)*FUMT/tenstysf(L) 

          suml=suml+tenstysf(L)*sfw(L)*etfw(L)
      DO i =1,NCP1
         sumdxl(i)=sumdxl(i)+dlidxsf(i,L)*sfw(L)*etfw(L)
         end do

 400  CONTINUE                                                          !00002180

        sumh=0
      DO i =1,NCP1
          sumdxh(i)=0
              end do


      DO 4002 LL=1,nr2                                                  !00001890
      L=LL+nr1
      IJ=0                                                              !00001900
      SUM=0.                                                            !00001910
      FUMT=FUM*betagw(1,L)
      DTT(1)=alftw(1,L)*DXNN(1)+betagw(1,L)*DPUF(1)
      TT(1)=DTT(1)                                                      !00001940
      dlidxsf(1,L)=0.
      DO 3001 I=2,NCP1                                                  !00001950
      SLS(I)=1.                                                         !00001960
      DTT(I)=alftw(I,L)*DXNN(I)+betagw(I,L)*DPUF(I)
      TT(I)=DTT(I)+TT(I-1)                                              !00001980
      dlidxsf(I,L)=0.                                                   !00001990
 3001 CONTINUE                                                          !00002000
      DO 3501 I=1,NCP1                                                  !00002010
      DO 3101 J=1,I                                                     !00002020
      IJ=IJ+1                                                           !00002030
 3101 SLS(J)=SLANT(K,IJ)                                                !00002040
      SUMS=alftw(1,L)*SLS(1)*DXNN(1)+betagw(1,L)*CHPP(I,K)*DPUF(1)
      IF (I.EQ.1) GO TO 3301                                            !00002060
      DO 3201 J=2,I                                                     !00002070
 3201 SUMS=SUMS+SLS(J)*DTT(J)                                           !00002080
 3301 CON=PUF(I)*EXP(-SUMS-TT(NCP1)+TT(I))                              !00002090
      IF (I.EQ.NCP1) CON=0.5*CON                                        !00002100
 3351 SUM=SUM+CON                                                       !00002110
      DO 3401 J=1,NCP1                                                  !00002120
 3401 dlidxsf(J,L)=dlidxsf(J,L)-alftw(J,L)*CON*SLS(J)
 3501 CONTINUE                                                          !00002140
      tenstysf(L)=FUMT*SUM                                              !00002150

C CHANGE DLIDX to SF weighted
      DO 3601 I=1,NCP1                                                  !00002160
 3601 dlidxsf(I,L)=dlidxsf(I,L)*FUMT/tenstysf(L)  

          sumh=sumh+tenstysf(L)*sfw(L)*etfw(L)
      DO i =1,NCP1
          sumdxh(i)=sumdxh(i)+dlidxsf(i,L)*sfw(L)*etfw(L)
         end do

 4002 CONTINUE                                                          !00002180
          TENSTY(1)=suml/sumsl
          TENSTY(2)=sumh/sumsh
      DO i =1,NCP1
         DLIDX(i,1)=sumdxl(i)/sumsl
         DLIDX(i,2)=sumdxh(i)/sumsh
          end do
C ***** END OF WAVELENGTH LOOP **************************************
      VALN(K)=100.*ALOG10(TENSTY(2)/TENSTY(1))                          !00002200
C Temperature correction of N-value
       if (ITEMPCORR.EQ.1) then
      sum1=0
      DO i =1,NCP1
      dtdalfa=sfacoft(1)*(TC(i)-DELT(i))+
     *       sfacofts(1)*(TC(i)**2-DELT(i)**2)
      sum1=sum1+
     * 43.4294*DLIDX(i,1)*DXNN(i)*dtdalfa/sfalft(i,1)
      END DO
      sum2=0
      DO i =1,NCP1
      dtdalfa=sfacoft(2)*(TC(i)-DELT(i))+
     *       sfacofts(2)*(TC(i)**2-DELT(i)**2)
      sum2=sum2+
     * 43.4294*DLIDX(i,2)*DXNN(i)*dtdalfa/sfalft(i,2)
      END DO

      VALNTC(K)=sum2-sum1
        end if

      DO 410 I=1,NCP1                                                   !00002210
      DLIDLX(I,K)=43.4294*(DLIDX(I,2)-DLIDX(I,1))
  410 CONTINUE
      NN=15*JC+1
      IF (NCP1.EQ.NN) GO TO 430
      IP=NCP1+1                                                         !00002240
      DO 425 I=IP,NN                                                    !00002260
      DO 425 J=1,I                                                      !00002270
  425 IJ=IJ+1                                                           !00002280
C ***** END OF ZENITH ANGLE LOOP ************************************
  430 CONTINUE                                                          !00002300
C*******************************************************************
C At the First iteration step: Add MSC derved from the table for appropriate FG 
C At the next iteration steps: Add MSC = MSC(i-1)+dNmsc/dx*[x(i)-x(i-1)] 
C*******************************************************************
c ***** ADD MULTIPLE SCATTERING CORRECTIONS TO FG N-VALUES **
      DO  K=KB,KE
      CORR=0
         if(ITER.GT.1) then
       DO I=1,NCP1
       CORR=CORR+DNMSCDX(I,K)*(DXNN(I)-DXNO(I))
      END DO
       end if
      CQMSC(K)=CQMSC(K)+CORR
      END DO

C*******************************************************************
C Correct SS N-valueand SS Jacobean by adding MSC from the table
C Correct total N-value by adding eff. X-section correction from the table
C*******************************************************************
      DO 2123 K=KB,KE                                                   !00001200
      VALN(K)=VALN(K)+CQMSC(K)
       
       DO I=1,NCP1
      DLIDLX(I,K)=DLIDLX(I,K)+DNMSCDX(I,K)
      END DO
 2123   continue

C*******************************************************************
C Temperature correction of N-value
C*******************************************************************
       if (ITEMPCORR.EQ.1) then
            do k=KB,KE
         VALN(k)=VALN(k)+VALNTC(k)
          end do
          end if
      IF (JUZPR.EQ.1) THEN
      WRITE (OUT6,9100) ITER,(THENOT(K),VALN(K),K=KB,KE)                   !00002310
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
C *******************************************************************
C Calculate FG N-values
C *******************************************************************
        if (ITER.eq.1) then
      DO K=1,12
      VNFG(K)=-.1
      END DO
      DO K=KB,KE
      SRES(K)=(VNOB(K)-VALN(K))
      VNFG(K)=VALN(K)
      END DO
      WRITE (OUT14,6402)(SRES(K),K=KB,KE)
      CALL UMKEHR_WRITE_STRING( 14, OUT14)
c ****** ADD REFRACTION CORRECTIONS TO FG N-VALUES***********
      DO 2124 I=1,4
      IP=I+1
      OMCHEK=OMOBS
      IF (OMOBS.GT.0.55) OMCHEK=0.55
      IF (OMCHEK.GT.TOTREF(I) .AND. OMCHEK.LE.TOTREF(IP)) THEN
        GGG1=(TOTREF(IP)-OMOBS)/(TOTREF(IP)-TOTREF(I))
        GGG2=1.0-GGG1
        DO 2125 K=KB,KE
      VNFG(K)=VNFG(K)+GGG1*REFCOR(K,I)+GGG2*REFCOR(K,IP)
 2125   continue
      ENDIF
 2124  CONTINUE
C *******************************************************************
C Temperature correction of N-value
C *******************************************************************
      DO K=KB,KE
      sum1=0
      DO i =1,NCP1
      dtdalfa=sfacoft(1)*(TC(i)-DELT(i))+
     *       sfacofts(1)*(TC(i)**2-DELT(i)**2)
      sum1=sum1+
     * 43.4294*DLIDX(i,1)*DXNN(i)*dtdalfa/sfalft(i,1)
      END DO
      sum2=0
      DO i =1,NCP1
      dtdalfa=sfacoft(2)*(TC(i)-DELT(i))+
     *       sfacofts(2)*(TC(i)**2-DELT(i)**2)
      sum2=sum2+
     * 43.4294*DLIDX(i,2)*DXNN(i)*dtdalfa/sfalft(i,2)
      END DO

      VNFG(K)=VNFG(K)+sum2-sum1
      end do
      WRITE(OUT21,7000) (ID(I),I=3,6),LAM,KB,KE,ID(7),
     1 IOMEGA,(NINT(VNFG(K)*10),K=1,12),ISTN                            !00000980
      CALL UMKEHR_WRITE_STRING( 21, OUT21)
       end if
c *******************************************************************
c *******************************************************************
      IF (JUZPR.EQ.1) THEN
         WRITE (OUT6,9000)                                                 !00002320
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
C ***** END OF FORWARD MODEL CALCULATION ****************************
C ***** SET UP FORCING VECTOR AND TRUNCATED DERIVATIVE MATRIX *******
      DO  K=KB,KE
      DO  I=1,NCP1
      AKO(K,I)=DLIDLX(I,K)
       END DO
       END DO
      MM=0
      DO 470 K=KBP,KE                                                   !00002350
      MM=MM+1
      DY(MM)=(VNOB(K)-VALN(K))-     (VNOB( KB)-VALN( KB))
      DYMKDX(MM)=DY(MM)
C FG=STD
      if (ITER.EQ.1) FORSHD(MM)=DYMKDX(MM)
      DO 440 I=1,NCP1                                                   !00002350
      AK(MM,I)=DLIDLX(I,K)-DLIDLX(I,KB)
  440 CONTINUE                                                          !00002450
  470 CONTINUE                                                          !00002560
      IF (JUZPR .EQ. 1)                                                 !00002730
     1WRITE (6,9301) ITER,(I,DYMKDX(I),I=1,MEQ)
      IF (JUZPR .EQ. 1) THEN                                            !00002570
        WRITE (OUT6,9200) (J,J=1,MEQ), (J,(AK(I,J),I=1,MEQ),J=1,61)
        CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR .EQ. 1) THEN                                            !00002570
      WRITE (OUT6,9201) (DY(I),I=1,MEQ)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.1) THEN 
      WRITE (OUT6,9000)                                                    !00002590
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
C ***** IF (ITER.GT.1) CALCULATE FORCING VECTOR ADJUSTMENT TERM *****
C FG=STD, calculate FSOL, comment if statement

      DY(MEQ)=WTX*(OMOBS-OMSOL)                                         !00002620
      DO 490 I=1,MEQ                                                    !00002630
      SUM=0.                                                            !00002640
      DO 480 J=1,NCP1                                                   !00002650
  480 SUM=SUM-AK(I,J)*FSOL(J,ITER)                                      !00002660
  490 DYMKDX(I)=DY(I)-SUM                                               !00002670
C ***** EXAMINE CHANGE FROM LAST FORCING VECTOR ********************
      if(ITEMPCORR.EQ.1)  go to 1520
      FEPS=0.                                                           !00002690
      DO 500 I=1,MEQ                                                    !00002700
  500 FEPS=FEPS+(DYMKDX(I)-FORSHD(I))**2                                !00002710
      FEPS=SQRT(FEPS/FLOAT(MEQ))                                        !00002720
      IF (JUZPR .EQ. 1) THEN                                                 !00002730
       WRITE (OUT6,9300) FEPS,(I,DYMKDX(I),I=1,MEQ)                         !00002740
       CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.1) THEN 
       WRITE (OUT6,9000)                                    	            !00002750
       CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
  510 DO 520 I=1,MEQ                                                    !00002760
  520 FORSHD(I)=DYMKDX(I)                                               !00002770
1520   continue
C ***** FORM MATRIX SX*K(TRANSPOSE) ********************
      DO 541 I=1,NCP1
      DO 541 K=1,MEQ
      SUM=0.                                                            !00002860
      DO 540 J=1,NCP1
      SUM=SUM+COVF(I,J)*AK(K,J)
  540 CONTINUE
      AKTSE(I,K)=SUM
  541 CONTINUE
C ***** FORM MATRIX K*Sx ************************
      DO 542 K=1,MEQ
      DO 542 I=1,NCP1
      SUM=0.                                                            !00002860
      DO 543 J=1,NCP1
      SUM=SUM+AK(K,J)*COVF(J,I)
  543 CONTINUE
      AKSX(K,I)=SUM
  542 CONTINUE
C ***** FORM MATRIX K *SX* K(TRANSPOSE) + SEPS
      DO 561 K=1,MEQ
      DO 560 KK=1,MEQ
      SUM=0.
      DO 550 I=1,NCP1
      SUM=SUM+AK(K,I)*AKTSE(I,KK)
  550 Continue
      AKTSEK(K,KK)=SUM
  560 Continue
       AKTSEK(K,K)=AKTSEK(K,K)+SEPS(K+KB-1)
  561 Continue
C ***** MATRIX INVERSION
      CALL MATINVN (MEQ,12,AKTSEK,AKTSEKI,DET)
      DO 590 I=1,NCP1
      DO 590 K=1,MEQ
      SUM=0.
      DO 580 J=1,MEQ
  580 SUM=SUM+AKTSE(I,J)*AKTSEKI(J,K)
  590 AKTF(I,K)=SUM
       if (ITER.eq.1.and.JUZPR.eq.1) THEN
        WRITE (OUT6,9400) ((AKTF(I,J),j=1,MEQ),i=1,NCP1)
        CALL UMKEHR_WRITE_STRING( 6, OUT6)
       ENDIF 
      DO 591 I=1,NCP1
      DO 591 K=1,NCP1
      SUM=0.
      DO 581 J=1,MEQ
  581 SUM=SUM+AKTF(I,J)*AKSX(J,K)
      AVARS(I,K)=COVF(I,K)-SUM
      SUM=0.
      DO 2581 J=1,MEQ
 2581 SUM=SUM+AKTF(I,J)*AK(J,K)
      AVK(I,K)=SUM
  591 CONTINUE
      IF (JUZPR.EQ.1) THEN
         WRITE (OUT6,9000)                                                 !00003000
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      ENDIF
      
      IF (JUZPR .EQ. 1) THEN                                            !00002730
        WRITE (OUT6,9300) FEPS,(I,DYMKDX(I),I=1,MEQ)                       !00002740
        CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF 
C ***** CALCULATE RETRIEVAL OZONE PROFILE ***************************
      DO 610 I=1,NCP1                                                   !00003020
      SUM=0.                                                            !00003030
      DO 600 J=1,MEQ
  600 SUM=SUM+AKTF(I,J)*DYMKDX(J)
  610 FSOL(I,ITER+1)=SUM                                                !00003060
cc end of change*********************************************************
      sum=0
      DO  I=1,NCP1
      sum=sum+FSOL(I,ITER+1)
      end do
      IF (JUZPR.eq.1) THEN 
        WRITE (OUT6,*)'FSOLI',sum, (FSOL(I,ITER+1),I=1,61)
        CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF

      DO  I=1,NCP1
      DXNO(I)=DXNN(I)
       if (ITER.eq.1) DXNO(I)=DXFG(I)
      END DO
      IF (JUZPR .EQ. 1) THEN                                            !00003070
       WRITE (OUT6,9500) (IL(I),FSOL(I,ITER+1),I=1,NCP1)                   !00003080
       CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.1) THEN 
         WRITE (OUT6,9000)                                                 !00003090
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      DO 630 I=1,NCP1                                                   !00003100
C FG=AP, works all the time
      DXNN(I)=DXN(I)+FSOL(I,ITER+1)
  630 CONTINUE                                                          !00003160
      IF (NCP1.LT.61) THEN
      DUM=DXNN(NCP1)/DXN(NCP1)
      DO 624 I=NCP1+1,61
  624 DXNN(I)=DUM*DXN(I)
        END IF
      TDXN(1)=DXNN(1)
      IMAX=14*JC+2                                                      !00002470
      MI=1
      DO 450 I=2,IMAX,JC                                                !00002480
      MI=MI+1                                                           !00002490
      TDXN(MI)=0.
      JMAX=I+JC-1                                                       !00002510
      IF (JMAX.GT.NCP1) JMAX=NCP1                                       !00002520
      DO 450 J=I,JMAX                                                   !00002530
      TDXN(MI)=TDXN(MI)+DXNN(J)
  450 CONTINUE                                                          !00002550

      IF (JUZPR .EQ. 1) THEN                                                 !00003200     
       WRITE (OUT6,9600) (I,TDXN(I),I=1,16)                                 !00003210
       CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.1) THEN 
         WRITE (OUT6,9000)                                                 !00003220
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
C ***** CALCULATE RESIDUALS FOR LINEAR SYSTEM ***********************
      RMSRES=0.                                                         !00003240
      DO 650 I=1,MEQ                                                    !00003250
      SUM=0.                                                            !00003260
      DO 640 J=1,NCP1                                                   !00003270
  640 SUM=SUM+AK(I,J)*FSOL(J,ITER+1)                                    !00003280
      RES(I)=DYMKDX(I)-SUM                                              !00003290
  650 RMSRES=RMSRES+RES(I)**2                                           !00003300
      RMSRES=SQRT(RMSRES/FLOAT(MEQ))                                    !00003310
      IF (RMSRES.GT.9.9) RMSRES=9.9                                     !00003320
      IF (JUZPR .EQ. 1) THEN                                            !00003330
        WRITE (OUT6,9700) RMSRES,(I,RES(I),I=1,MEQ)                        !00003340
        CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.1) THEN 
         WRITE (OUT6,9000)                                                 !00003350
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF 
      
C ***** EXAMINE CHANGES FROM FSOL FROM LAST ITERATION ***************
      IF (ITER.EQ.1.OR.ITEMPCORR.EQ.1) GO TO 700
      DFRMS=0.                                                          !00003380
      DO 660 I=1,NCP1                                                   !00003390
        dfsol=FSOL(I,ITER)+DXN(I)
  660 DFRMS=DFRMS+((FSOL(I,ITER+1)-FSOL(I,ITER))/dfsol)**2   
      DFRMS=SQRT(DFRMS/NCP1)                                            !00003410
      IF (JUZPR .EQ. 1) THEN                                            !00003420
       WRITE (OUT6,9800) DFRMS                                             !00003430
       CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.1) THEN 
        WRITE (OUT6,9000)                                                  !00003440
        CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
C ***** CONVERGENCE TESTING BLOCK ***********************************
  700 CONTINUE                                                          !00003460
      JTERM=1                                                           !00003470
      DO 702 I=1,NCP1                                                   !00003480
       dfs=(FSOL(I,ITER+1)-FSOL(I,ITER))/(FSOL(I,ITER)+DXN(I))
      IF (ABS(dfs).GT.0.04) JTERM=0   
  702 CONTINUE                                                          !00003500
      IF (DFRMS.GT.0.01) JTERM=0                                        !00003510
      IF (FEPS.LE.0.15 .AND. ITER.GT.1) JTERM=1                         !00003520
        SUMSOL=0
       do i=1,NCP1
        SUMSOL=SUMSOL+DXNN(I)
       end do
      OMSOL=SUMSOL
      IF (JUZPR.EQ.1) THEN 
          WRITE (OUT6,9000)                                                !00003590
          CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
         IF(ITEMPCORR.EQ.1) go to 1250
      IF (ITER.LT.ITMAX .AND. JTERM.EQ.0) GO TO 250                     !00003610
C *******************************************************************
C STOP ITERATIONS, END OF RETRIEVAL
C *******************************************************************
C *******************************************************************
C Add temperature correction
c check if alfa(TC)*DXNN =alfa(DELT)*(DXNN+CORT), DXALFT vs. DXALFC (77)
c difference is +/- 1 % for 311 and +/- 3 % for 332 in layers 0,1,2
C *******************************************************************
          if (ITEMPCORR.eq.0) then
          ITEMPCORR=1
          go to 250
          end if
1250       continue
           ITER=ITER-1
C *******************************************************************
C ***** FORWARD (PHYSICAL) MODEL CALCULATION ************************
C ***** COMPUTE N-VALUES AND PARTIAL DERIVATIVES FOR RT PROFILE *****
C ***** MAIN LOOP THROUGH ZENITH ANGLE ******************************
          DO k=1,12
         VALN(K)=-.1
          FRES(K)=999
             END DO
      DO 7430 K=KB,KE                                                   !00001850
      AMUO=COS(CNVRT*THENOT(K))                                         !00001860
      FUM=3./16.*(1.+AMUO**2)*DPSL                                      !00001870
C ***** SUB-LOOP THROUGH WAVELENGTH *********************************
        suml=0
      DO i =1,NCP1
          sumdxl(i)=0
       end do
      DO 7400 L=1,nr1
      IJ=0                                                              !00001900
      SUM=0.                                                            !00001910
      FUMT=FUM*betagw(1,L)
      DTT(1)=alftw(1,L)*DXNN(1)+betagw(1,L)*DPUF(1)
      TT(1)=DTT(1)                                                      !00001940
      dlidxsf(1,L)=0.
      DO 7300 I=2,NCP1                                                  !00001950
      SLS(I)=1.                                                         !00001960
      DTT(I)=alftw(I,L)*DXNN(I)+betagw(I,L)*DPUF(I)
      TT(I)=DTT(I)+TT(I-1)                                              !00001980
      dlidxsf(I,L)=0.                                                   !00001990
 7300 CONTINUE                                                          !00002000
      DO 7350 I=1,NCP1                                                  !00002010
      DO 7310 J=1,I                                                     !00002020
      IJ=IJ+1                                                           !00002030
 7310 SLS(J)=SLANT(K,IJ)                                                !00002040
      SUMS=alftw(1,L)*SLS(1)*DXNN(1)+betagw(1,L)*CHPP(I,K)*DPUF(1)
      IF (I.EQ.1) GO TO 7330                                            !00002060
      DO 7320 J=2,I                                                     !00002070
 7320 SUMS=SUMS+SLS(J)*DTT(J)                                           !00002080
 7330 CON=PUF(I)*EXP(-SUMS-TT(NCP1)+TT(I))                              !00002090
      IF (I.EQ.NCP1) CON=0.5*CON                                        !00002100
 7335 SUM=SUM+CON                                                       !00002110
      DO 7340 J=1,NCP1                                                  !00002120
 7340 dlidxsf(J,L)=dlidxsf(J,L)-alftw(J,L)*CON*SLS(J) 
 7350 CONTINUE                                                          !00002140
      tenstysf(L)=FUMT*SUM                                              !00002150

C CHANGE DLIDX to SF weighted
      DO 7360 I=1,NCP1                                                  !00002160
 7360 dlidxsf(I,L)=dlidxsf(I,L)*FUMT/tenstysf(L) 

          suml=suml+tenstysf(L)*sfw(L)*etfw(L)
      DO i =1,NCP1
         sumdxl(i)=sumdxl(i)+dlidxsf(i,L)*sfw(L)*etfw(L)
         end do

 7400  CONTINUE                                                         !00002180

        sumh=0
      DO i =1,NCP1
          sumdxh(i)=0
              end do


      DO 8400 LL=1,nr2                                                  !00001890
      L=LL+nr1
      IJ=0                                                              !00001900
      SUM=0.                                                            !00001910
      FUMT=FUM*betagw(1,L)
      DTT(1)=alftw(1,L)*DXNN(1)+betagw(1,L)*DPUF(1)
      TT(1)=DTT(1)                                                      !00001940
      dlidxsf(1,L)=0.
      DO 8300 I=2,NCP1                                                  !00001950
      SLS(I)=1.                                                         !00001960
      DTT(I)=alftw(I,L)*DXNN(I)+betagw(I,L)*DPUF(I)
      TT(I)=DTT(I)+TT(I-1)                                              !00001980
      dlidxsf(I,L)=0.                                                   !00001990
 8300 CONTINUE                                                          !00002000
      DO 8350 I=1,NCP1                                                  !00002010
      DO 8310 J=1,I                                                     !00002020
      IJ=IJ+1                                                           !00002030
 8310 SLS(J)=SLANT(K,IJ)                                                !00002040
      SUMS=alftw(1,L)*SLS(1)*DXNN(1)+betagw(1,L)*CHPP(I,K)*DPUF(1)
      IF (I.EQ.1) GO TO 8330                                            !00002060
      DO 8320 J=2,I                                                     !00002070
 8320 SUMS=SUMS+SLS(J)*DTT(J)                                           !00002080
 8330 CON=PUF(I)*EXP(-SUMS-TT(NCP1)+TT(I))                              !00002090
      IF (I.EQ.NCP1) CON=0.5*CON                                        !00002100
 8335 SUM=SUM+CON                                                       !00002110
      DO 8340 J=1,NCP1                                                  !00002120
 8340 dlidxsf(J,L)=dlidxsf(J,L)-alftw(J,L)*CON*SLS(J)
 8350 CONTINUE                                                          !00002140
      tenstysf(L)=FUMT*SUM                                              !00002150

C CHANGE DLIDX to SF weighted
      DO 8360 I=1,NCP1                                                  !00002160
 8360 dlidxsf(I,L)=dlidxsf(I,L)*FUMT/tenstysf(L)  
          sumh=sumh+tenstysf(L)*sfw(L)*etfw(L)
      DO i =1,NCP1
          sumdxh(i)=sumdxh(i)+dlidxsf(i,L)*sfw(L)*etfw(L)
         end do

 8400 CONTINUE                                                          !00002180
          TENSTY(1)=suml/sumsl
          TENSTY(2)=sumh/sumsh
      DO i =1,NCP1
         DLIDX(i,1)=sumdxl(i)/sumsl
         DLIDX(i,2)=sumdxh(i)/sumsh
          end do
C ***** END OF WAVELENGTH LOOP **************************************
      VALN(K)=100.*ALOG10(TENSTY(2)/TENSTY(1))                          !00002200
      DO 7410 I=1,NCP1                                                  !00002210
      DLIDLX(I,K)=43.4294*(DLIDX(I,2)-DLIDX(I,1))
 7410 CONTINUE
      NN=15*JC+1
      IF (NCP1.EQ.NN) GO TO 7430
      IP=NCP1+1                                                         !00002240
      DO 7425 I=IP,NN                                                   !00002260
      DO 7425 J=1,I                                                     !00002270
 7425 IJ=IJ+1                                                           !00002280
C ***** END OF ZENITH ANGLE LOOP ************************************
 7430 CONTINUE                                                          !00002300
C *******************************************************************
C Calculate RT N-values
      DO K=1,12
      VNRT(K)=-.1
      END DO
c ***** ADD MULTIPLE SCATTERING CORRECTIONS TO FG N-VALUES **
      DO  K=KB,KE
      CORR=0
       do i=1,NCP1
c 9.11.03 use K instead of KB
       CORR=CORR+DNMSCDX(i,K)*(DXNN(i)-DXNO(i))
      END DO
      CQMSC(K)=CQMSC(K)+CORR
      END DO
c ***** ADD MULTIPLE SCATTERING CORRECTIONS TO FG N-VALUES **
      DO 7123 K=KB,KE                                                   !00001200
      VNRT(K)=VALN(K)+CQMSC(K)
       DO I=1,NCP1
      DLIDLX(I,K)=DLIDLX(I,K)+DNMSCDX(I,K)
      END DO
 7123   continue
C *******************************************************************
C********* calculate final residuals
C include VALNTC (temp corr.) in final residuals
       DO  K=KB,KE
       FRES(K)=VNRT(K)-VNOB(K)+VALNTC(k)
c      FRES(K)=VNRT(K)-VNOB(K)
       END DO
       WRITE(OUT25,*) (ID(I),I=3,5),KB,KE,
     1 IOMEGA,SUMSOL,(FRES(K),K=1,12)
      CALL UMKEHR_WRITE_STRING( 25, OUT25)
C *******************************************************************
      DO 710 I=1,NCP1                                                   !00003630
  710 SERX(I)=100.*SQRT(AVARS(I,I))
      IF (JUZPR.EQ.1) THEN 
         WRITE (OUT6,9900) (IL(I),SERX(I),I=1,NCP1)                        !00003650
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
      IF (JUZPR.EQ.1) THEN 
         WRITE (OUT6,9000)                                                 !00003660
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      END IF
C ***** PRINT FINAL RESULTS FOR THIS UMKEHR RETRIEVAL ***************
        WRITE(OUT31,*)(DXNN(I),I=1,NCP1)
        CALL UMKEHR_WRITE_STRING( 31, OUT31)

C Print out the last AK in 8 layers (9+,8,7,6,5,4,3+2,1+0)

      DO 1451  K=KB,KE
      DNDLOG16(1,K)=DLIDLX(1,K)*DXNN(1)
      IMAX=14*JC+2
      MI=1
      DO 1450 I=2,IMAX,JC
      MI=MI+1
      DNDLOG16(MI,K)=0.
      JMAX=I+JC-1
      IF (JMAX.GT.NCP1) JMAX=NCP1
      DO 1450 J=I,JMAX
      DNDLOG16(MI,K)=DNDLOG16(MI,K)+DLIDLX(J,K)*DXNN(J)
 1450 CONTINUE
      DNDLOG8(1,K)=0.0
      TDXN8(1)=0.
      do i=1,7
      DNDLOG8(1,K)=DNDLOG8(1,K)+DNDLOG16(i,k)
      TDXN8(1)=TDXN8(1)+TDXN(i)
      end do
      do i=2,6
      DNDLOG8(i,K)=DNDLOG16(i+6,k)
      TDXN8(i)=TDXN(i+6)
      end do
      DNDLOG8(7,K)=DNDLOG16(13,k)+DNDLOG16(14,k)
      DNDLOG8(8,K)=DNDLOG16(15,k)+DNDLOG16(16,k)
      TDXN8(7)=TDXN(13)+TDXN(14)
      TDXN8(8)=TDXN(15)+TDXN(16)
 1451 CONTINUE
            DO  I=1,8
      AK8(MEQ,I)=WTX
      END DO
      MM=0
      DO 1470 K=KBP,KE
      MM=MM+1
      DO 1440 I=1,8
      AK8(MM,I)=(DNDLOG8(I,K)-DNDLOG8(I,KB))/TDXN8(I)
 1440 CONTINUE

 1470 CONTINUE


C ***** FORM MATRIX SX*K(TRANSPOSE) ********************
      DO 1541 I=1,8
      DO 1541 K=1,MEQ
      SUM=0.
      DO 1540 J=1,8
      SUM=SUM+COVF8(I,J)*AK8(K,J)
 1540 CONTINUE
      AKTSE8(I,K)=SUM
 1541 CONTINUE
C ***** FORM MATRIX K*Sx ************************
      DO 1542 K=1,MEQ
      DO 1542 I=1,8
      SUM=0.
      DO 1543 J=1,8
      SUM=SUM+AK8(K,J)*COVF8(J,I)
 1543 CONTINUE
      AKSX8(K,I)=SUM
 1542 CONTINUE
C ***** FORM MATRIX K *SX* K(TRANSPOSE) + SEPS
      DO 1561 K=1,MEQ
      DO 1560 KK=1,MEQ
      SUM=0.
      DO 1550 I=1,8
      SUM=SUM+AK8(K,I)*AKTSE8(I,KK)
 1550 Continue
      AKTSEK8(K,KK)=SUM
 1560 Continue
       AKTSEK8(K,K)=AKTSEK8(K,K)+SEPS(K)
 1561 Continue
C ***** MATRIX INVERSION
      CALL MATINVN (MEQ,12,AKTSEK8,AKTSEKI8,DET)
      DO 1590 I=1,8
      DO 1590 K=1,MEQ
      SUM=0.
      DO 1580 J=1,MEQ
 1580 SUM=SUM+AKTSE8(I,J)*AKTSEKI8(J,K)

      AKTF8(I,K)=SUM
 1590 CONTINUE

      DO 1591 I=1,8
      DO 1591 K=1,8
      SUM=0.
      DO 1581 J=1,MEQ
 1581 SUM=SUM+AKTF8(I,J)*AK8(J,K)
      AVK8(I,K)=SUM
 1591 CONTINUE
c *******************************************************************

      DO 735 I=1,5
  735 TDXN(6)=TDXN(6)+TDXN(I)
      TDXN(15)=TDXN(15)+TDXN(16)
      IF (JUZDSK.EQ.0) THEN
         WRITE (OUT6,6200) SUMSOL,ITER,RMSRES,DFRMS,FEPS
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
         WRITE (OUT6,6300) (VNOB(K),K=KB,KE)                               !3850
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
         WRITE (OUT6,6400) (FRES(I),I=KB,KE)                               !3860
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
         WRITE (OUT6,6600) (TDXN(I)*1000.,I=6,15)                          !3870
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
         WRITE(OUT14,*)'8-LAYER AVERAGING KERNEL'
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
          do k=1,8
         WRITE (OUT6,6661) (AVK8(K,I),I=1,8)
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
          end do
         WRITE (OUT6,6700) (SERX(I),I=3,12)                                !3880
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
         WRITE (OUT6,9000)                                                 !00003
         CALL UMKEHR_WRITE_STRING( 6, OUT6)
      ELSE
         WRITE (OUT14,4010) OMOBS*1000,ALFAC,(ALFBAR(L),L=1,2),
     1   SUMSOL*1000,ITER, RMSRES,DFRMS,FEPS
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
         WRITE (OUT14,6400) (FRES(I),I=KB,KE)
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
         WRITE (OUT14,6600) (TDXN(I)*1000.,I=6,15)
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
         WRITE(OUT14,*)'8-LAYER AVERAGING KERNEL'
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
          do k=1,8
         WRITE (OUT14,6661) (AVK8(K,I),I=1,8)
         CALL UMKEHR_WRITE_STRING( 14, OUT14)
          end do
      ENDIF
      IF (JUZOUT.EQ.1) THEN
         OMOBS=1000.*OMOBS
         SUMSOL=1000.*SUMSOL
         CALL DSKOUT (OMOBS,SUMSOL,ID,TDXN,ITER,KB,KE,FEPS,DFRMS,
     1   RMSRES,ISN,JSX,LAM)
         OMOBS=OMOBS/1000.
         SUMSOL=SUMSOL/1000.
      ENDIF
C ***** COLLECT SUMS FOR FINAL RETRIEVAL STATISTICS *****************
      IF (RMSRES.GT.3.0) GO TO 730                                      !00003670
      NITER=NITER+ITER
      NSOL=NSOL+1                                                       !00003680
      OMOBAR=OMOBAR+OMOBS                                               !00003690
      OMODEV=OMODEV+OMOBS**2                                            !00003700
      OMSBAR=OMSBAR+OMSOL                                               !00003710
      OMSDEV=OMSDEV+OMSOL**2                                            !00003720
      RESBAR=RESBAR+RMSRES                                              !00003730
      RESDEV=RESDEV+RMSRES**2                                           !00003740
      DO 720 I=1,NCP1
      K=I
      P3BAR(I)=P3BAR(I)+DXNN(K)  
      P3DEV(I)=P3DEV(I)+DXNN(K)**2
      ERROR(I)=ERROR(I)+SERX(I)
      VARED(I)=VARED(I)+(COVF(I,I)-AKTSEKI(I,I))/COVF(I,I)  
  720 CONTINUE                                                          !00003810
  730 CONTINUE                                                          !00003820
C ***** RECYCLE TO READ NEW UMKEHR CURVE ***************************
      GO TO 220                                                         !00003960
  900 CONTINUE                                                          !00003970

C ***** COMPUTE FINAL STATISTICS FOR THIS STATION BATCH *************
      IF (NSOL.LE.0) GO TO 750                                          !00003990
      AN=1./FLOAT(NSOL)                                                 !00004000
      OMOBAR=AN*OMOBAR                                                  !00004010
      OMODEV=AN*OMODEV-OMOBAR**2                                        !00004020
      OMSBAR=AN*OMSBAR                                                  !00004030
      OMSDEV=AN*OMSDEV-OMSBAR**2                                        !00004040
      RESBAR=AN*RESBAR                                                  !00004050
      RESDEV=AN*RESDEV-RESBAR**2                                        !00004060
      IF (OMODEV.GT.0.) OMODEV=SQRT(OMODEV)                             !00004070
      IF (OMSDEV.GT.0.) OMSDEV=SQRT(OMSDEV)                             !00004080
      IF (RESDEV.GT.0.) RESDEV=SQRT(RESDEV)                             !00004090
      DO 740 I=1,NCP1
      P3BAR(I)=AN*P3BAR(I)                                              !00004110
      P3DEV(I)=AN*P3DEV(I)-P3BAR(I)**2                                  !00004120
      IF (P3DEV(I).GT.0.) P3DEV(I)=SQRT(P3DEV(I))                       !00004130
      ERROR(I)=AN*ERROR(I)                                              !00004140
      VARED(I)=AN*VARED(I)                                              !00004150
  740 CONTINUE                                                          !00004160
      L1=61                                                             !00004170
      L2=1                                                              !00004180
      L3=-1                                                             !00004190
      WRITE (OUT6, 6790) NSOL
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6, 6791) OMOBAR*1000.,OMODEV,OMSBAR*1000.,OMSDEV
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6, 6792) RESBAR,RESDEV,NITER
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6, 6801) (LYR,LYR=L1,L2,L3)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6, 6802) (P3BAR(I),I=1,61)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6, 6803) (P3DEV(I),I=1,61)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6, 6804) (ERROR(I),I=1,61)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6, 6805) (VARED(I),I=1,61)
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
      WRITE (OUT6,9000)                                                    !00004230
      CALL UMKEHR_WRITE_STRING( 6, OUT6)
  750 CONTINUE                                                          !00004240
      IF (ID(3).EQ.99) GO TO 190                                        !TEMP****

 9999 CALL UMKEHR_CLOSE_INPUTFILE(5)
      CALL UMKEHR_CLOSE_INPUTFILE(10)
      CALL UMKEHR_CLOSE_INPUTFILE(11)
      CALL UMKEHR_CLOSE_INPUTFILE(13)
      CALL UMKEHR_CLOSE_INPUTFILE(9)
      CALL UMKEHR_CLOSE_INPUTFILE(8)
      CALL UMKEHR_CLOSE_INPUTFILE(18)
      CALL UMKEHR_CLOSE_INPUTFILE(19)
      CALL UMKEHR_CLOSE_INPUTFILE(15)
      CALL UMKEHR_CLOSE_INPUTFILE(98)
      CALL UMKEHR_CLOSE_INPUTFILE(97)
      CALL UMKEHR_CLOSE_INPUTFILE(79)
      CALL UMKEHR_CLOSE_OUTPUT(4)
      CALL UMKEHR_CLOSE_OUTPUT(6)
      CALL UMKEHR_CLOSE_OUTPUT(10)
      CALL UMKEHR_CLOSE_OUTPUT(14)
      CALL UMKEHR_CLOSE_OUTPUT(16)
      CALL UMKEHR_CLOSE_OUTPUT(21)
      CALL UMKEHR_CLOSE_OUTPUT(22)
      CALL UMKEHR_CLOSE_OUTPUT(25)
      CALL UMKEHR_CLOSE_OUTPUT(31)

      RETURN                                                            !00004250

C ***** FORMAT STATEMENTS *******************************************
 4000 FORMAT (1H ,14X,A72)                                              !TEMP****
 4001 FORMAT (1H ,4X,'LATITUDE=',F8.2,5X,'SFC PRESSURE=',F6.3,' ATM',
     15X,'STN HEIGHT=',F6.0,' M',5X,'STD TEMP PROFILE')
 4010 FORMAT (1H ,7HNU TOZ=,F5.1,3X,6HALFAS=,3F7.4,3X,8HSOL TOZ=,
     1F5.1,3X,5HITER=,I1,3X,4HRES=,F4.2,3X,3HDF=,F5.3,3X,3HDN=,F4.2)
 4011 FORMAT (9H ********,A18,3X,4HDATE,3I3,3X,2HL=,I2,2X,2HT=,A1,2X,
     1 3HKB=,I1,2X,3HKE=,I2,2X,3HLS=,A2,2X,8HOBS TOZ=,F5.1,
     2 10H**********)
 5000 FORMAT (2I2,F10.4,1X,A1)
 5010 FORMAT (I4,1X,A18,1X,F8.2,2F6.0)                                  !TEMP****
 5500 FORMAT (8X,12F6.1)                                                !00000640

 5600 FORMAT (3I2,A1,I1,2I2,A2,I4,2F4.1,10F5.1,I3)                      !TEMP****
 6000 FORMAT (1H0,28X,A72)                                              !TEMP****
 6001 FORMAT (1H ,19X,'LATITUDE=',F8.2,5X,'SFC PRESSURE=',F6.3,' ATM',  !TEMP****
     15X,'STN HEIGHT=',F6.0,' M',5X,'STD TEMP PROFILE')
 6100 FORMAT (1H ,A18,3X,5HDATE=,3I3,3X,11HID DATA  L=,I2,3X,2HT=,A1,
     1 2X,3HKB=,I2,2X,3HKE=,I2,3X,3HLS=,A2,3X,12HOBSVD TOTOZ=,F6.1)
 6200 FORMAT (1H ,11HSOLN TOTOZ=,F6.1,3X,5HITER=, I2,3X,7HRMSRES=,
     1 F4.2, 3X,6HDFRMS=,F5.3,3X,6HDNRMS=,F4.2)
 6300 FORMAT (5H NOBS, 12F7.1)                                          !00004370
 6400 FORMAT (11H FINAL NRES,3X,12F6.1)
 6401 FORMAT (11H INITL NVAL,3X,12F6.1)
 6402 FORMAT (11H INITL NRES,3X,12F6.1)
 6600 FORMAT (19HSOLUTION PROF (DU) ,10F7.2)
 6601 FORMAT (19HA PRIORI PROF (DU) ,10F7.2)
 6661 FORMAT (8F8.3)
 6700 FORMAT (19H EST PCT SOLN ERROR,2X,10F7.1)                         !00004410

 6790 FORMAT (1H ,' SOLUTION STATISTICS FOR ',I5,' PROFILES')               !00004420
 6791 FORMAT (1H ,' TOTAL OZONE OBSERVED=',F6.1,' +/- ',F6.1,
     1        '     SOLUTION=',F6.1,' +/- ',F6.1)
 6792 FORMAT (1H ,' AVERAGE RESIDUAL=',F5.2,' +/- ',F5.2,
     1            '         TOTAL ITERATIONS=', I4)
C 6800 FORMAT (1H0,5X,'SOLUTION STATISTICS FOR ',I5,' PROFILES'/         !00004420
C     1 1H ,'TOTAL OZONE',3X,'OBSERVED=',F6.1,' +/- ',F6.1,5X,
C     2 'SOLUTION=',F6.1,' +/- ',F6.1/ 1H ,'AVERAGE RESIDUAL=',
C     3 F5.2,' +/- ',F5.2,10X,'TOTAL ITERATIONS=',I4/ 1H ,'LAYER',
C    3 61I7/ 1H ,'AVE DU',3X,61E10.2/
C    4 1H ,'DEV DU',61E10.2/ 1H ,'ERROR',61E10.1/1H ,'VARED ',61E10.3)  !TEMP****
 6801 FORMAT(1H ,' LAYER  ',61I14)
 6802 FORMAT(1H ,' AVE DU ',61E14.2)
 6803 FORMAT(1H ,' DEV DU ',61E14.2)
 6804 FORMAT(1H ,' ERROR  ',61E14.1)
 6805 FORMAT(1H ,' VARED  ',61E14.3)  !TEMP****

 7000 FORMAT (3I2,A1,I1,I2,I2,A2,3I4,10I5,I3)                           !TEMP****
 7777 FORMAT (' THIS UMKEHR OUTSIDE ZENITH ANGLE LIMITS DATE',3I3,5X,
     1 2HT=,A1,3X, 'KB=',I3,3X,'KE=',I3)
 8001 FORMAT (4(I7,F7.1,2F9.5))
 8003 FORMAT (11H NEW TOTOZ=,F7.1,5X,10HNEW ALFAC=,F7.4,
     1 3X,9HALFABARS=,2F7.4)
 8101 FORMAT (3I4,F8.1,10(F9.4))
 8102 FORMAT (3I4,F8.1,13(F9.4))
 9000 FORMAT (1H , 20(6H *****))                                         !00004470
 9001 FORMAT (' UMKEHR STATION NO.',I4,'DIFFERS FROM THAT ON BATCH HEADE !TEMP****
     1R CARD.',I4,'RUN TERMINATED.')                                     !TEMP****
 9040 FORMAT (' PROFILE COVARIANCE MATRIX USED IN THIS RUN'/
     1 (I9,61E10.3))
 9041 FORMAT (' 8-layer COVARIANCE MATRIX USED IN THIS RUN'/
     1 (I9,8E10.3))
 9042 FORMAT (I9,8E10.3)
 9050 FORMAT (28H APRIORI INFORMATION PROFILE/1H /(6(4H LYR,I3,E11.4))) !00004480
 9100 FORMAT (' ITERATION',I2/' THENOT',7X,'NCAL'/1H /(F6.1,F11.1))     !00004490
 9200 FORMAT (' KERNEL FOR THIS ITERATION'/' EQTN=',
     112I8,5X /'  LAYER'/1H /(I5,12E10.3))
 9201 FORMAT (' RESIDUALS FOR THIS ITERATION'/12E11.3)  
 9300 FORMAT (' ADJUSTED FORCING VECTOR',5X,'RMS CHANGE FROM LAST ITERAT!00004520
     1ION=',F7.2/1H /(8(' EQ',I2,F7.1,4X)))                             !00004530
 9301 FORMAT (' BEFORE ADJUSTING FORCING VECTOR',5X,'BEGINNING OF ITERAT
     1ION=',F7.2/1H /(8(' EQ',I2,F7.1,4X)))
 9400 FORMAT (' INTERMEDIATE SOLUTION'/1H /(6(' EQ',I2,E12.3,4X)))      !00004540
 9500 FORMAT (' FRACTIONAL SOLUTION CHANGE FROM PRIOR INFORMATION PROFIL!00004550
     1E IN EACH LAYER'/1H /(7(' LYR',I2,E11.4,4X)))                     !00004560
 9600 FORMAT (' SOLUTION PROFILE AFTER CURRENT ITERATION'/1H /(6(' LYR' !00004570
     1,I3, E11.4, 3X )))                                                !00004580
 9700 FORMAT (' RESIDUALS AFTER THIS ITERATION',10X,'RMSRES=',F6.2/1H / !00004590
     1 (8(' EQ',I2,E11.4,4X)))                                          !00004600

 9800 FORMAT (' RMS CHANGE IN FRACTIONAL SOLUTION FROM LAST ITERATION=' !00004610
     1,E11.4)                                                           !00004620
 9900 FORMAT (' ESTIMATED ERROR OF FINAL SOLUTION IN EACH LAYER'/1H /   !00004640
     1 (8(2X,1HL,I2,F6.1,5X)))                                          !00004650
      END                                                               !00004660

C----------------------------------------------------------------------
C   SUBROUTINE EXPAND
C   EXPANDS BASIC FIRST GUESS PROFILE TO FORWARD MODEL PROFILE **
C----------------------------------------------------------------------
      SUBROUTINE EXPAND (PUL,TDXN,NCP1,PUFL,SXN,DXN)                    !00004870

      DIMENSION PUL(16),TDXN(16),PUFL(61),SXN(61),DXN(61),XL(16)
      SUM=TDXN(1)                                                       !00004900
      XL(1)=ALOG(SUM)                                                   !00004910
      DO 10 I=2,16                                                      !00004920
      SUM=SUM+TDXN(I)                                                   !00004930
   10 XL(I)=ALOG(SUM)                                                   !00004940
      CALL SPLINE (16,PUL,XL,NCP1,PUFL,SXN)                             !00004950
      SXN(1)=EXP(SXN(1))                                                !00004960
      DXN(1)=SXN(1)                                                     !00004970
      DO 20 I=2,NCP1                                                    !00004980
      SXN(I)=EXP(SXN(I))                                                !00004990
   20 DXN(I)=SXN(I)-SXN(I-1)                                            !00005000
      RETURN                                                            !00005010
      END                                                               !00005020

C----------------------------------------------------------------------
C   SUBROUTINE SLANTS
C   CALCULATES SLANT PATHS FOR FORWARD MODEL CALCULATION
C----------------------------------------------------------------------

      SUBROUTINE SLANTS (NCP1,THENOT,SQCHP,CHPN,SQCHX,CHXN,HHH,DHH,CHPP)!00005030
      IMPLICIT NONE

      INCLUDE 'umkehr_common.fix'
C      REAL CQMS(12,42), SLANT(12,1891), TABJMS(61,13,21)
C      COMMON /BBBB/ SLANT,CQMS, TABJMS

      REAL SQCHP,CHPN,SQCHX,CHXN,AMU
      REAL HHH(61),DHH(61),CHPP(61,12),THENOT(12)
      DOUBLE PRECISION CNVRT,SN,RAYCON,THNT,DA,DB,HH(61)
      INTEGER NCP1,I,J,K,IJ

      REAL OMERF

      DO 5 I=1,NCP1                                                     !00005070
    5 HH(I)=1.D00+HHH(I)                                                !00005080
      CNVRT=DACOS(-1.D00)/180.D00                                       !00005090
      DO 30 K=1,12                                                      !00005100
      THNT=THENOT(K)                                                    !00005110
      SN=DSIN(CNVRT*THNT)                                               !00005120
      IJ=0                                                              !00005130
      DO 20 I=1,NCP1                                                    !00005140
      RAYCON=SN*HH(I)                                                   !00005150
      AMU=RAYCON/HH(1)                                                  !00005160
      AMU=SQRT(1.-AMU**2)                                               !00005170
      CHPP(I,K)=OMERF(AMU*SQCHP,AMU,CHPN)                               !00005180
      IJ=IJ+1                                                           !00005190
      SLANT(K,IJ)=OMERF(AMU*SQCHX,AMU,CHXN)                             !00005200
      IF (I.EQ.1) GO TO 20                                              !00005210
      DA=DSQRT((HH(1)-RAYCON)*(HH(1)+RAYCON))                           !00005220
      DO 10 J=2,I                                                       !00005230
      DB=DSQRT((HH(J)-RAYCON)*(HH(J)+RAYCON))                           !00005240
      IJ=IJ+1                                                           !00005250
      SLANT(K,IJ)=(DA-DB)/DHH(J)                                        !00005260
   10 DA=DB                                                             !00005270
   20 CONTINUE                                                          !00005280
   30 CONTINUE                                                          !00005290
      RETURN                                                            !00005300
      END                                                               !00005310

C----------------------------------------------------------------------
C   SUBROUTINE LAYER
C   CALCULATE PLOG  (=PUL) FOR UMKEHR BASE-LAYER MODEL
C   CALCULATE PLOG (=PUFL), P(=PUF), AND DP(=DPUF) FOR FORWARD CALCULATION MODEL
C----------------------------------------------------------------------

      SUBROUTINE LAYER (PUL,PUFL,PUF,DPUF,DPSL,NC,NCP1,JC)              !00005710
      DIMENSION PUFL(61),PUF(61),DPUF(61),PUL(16)
      TWOLOG=ALOG(2.)                                                   !00005730
      JC=4                                                              !TEMP****
      NC=15*JC                                                          !00005780
      NCP1=NC+1                                                         !00005790
      DPSL=TWOLOG/FLOAT(JC)                                             !00005800
      FRAC=EXP(DPSL)                                                    !00005810
      PUFL(1)=-15.*TWOLOG                                               !00005820
      PUF(1)=EXP(PUFL(1))                                               !00005830
      DPUF(1)=PUF(1)                                                    !00005840
      DO 20 I=2,NC                                                      !00005850
      IM=I-1                                                            !00005860
      PUFL(I)=PUFL(IM)+DPSL                                             !00005870
      PUF(I)=FRAC*PUF(IM)                                               !00005880
   20 DPUF(I)=PUF(I)-PUF(IM)                                            !00005890
      PUFL(NCP1)=0.                                                     !00005900
      PUF(NCP1)=1.                                                      !00005910
      DPUF(NCP1)=1.-PUF(NC)                                             !00005920
      PUL(1)=PUFL(1)                                                    !00005930
      DO 30 I=2,15                                                      !00005940
   30 PUL(I)=PUL(I-1)+TWOLOG                                            !00005950
      PUL(16)=0.                                                        !00005960
      RETURN                                                            !00005970
      END                                                               !00005980

C----------------------------------------------------------------------
C   FUNCTIONE OMERF
C   CALCULATES CHAPMAN FUNCTION FOR OZONE ABSORPTION AND
C   RAYLEIGH SCATTERING ATTENUATION PATH ABOVE TOP OF LAYERS
C   OF FORWARD MODEL
C----------------------------------------------------------------------

      FUNCTION OMERF (X, Y, SQ)                                         !00006610
      DIMENSION A(5)                                                    !00006620
      DATA P/ .3275911/, A/ 1.061405429, -1.453152027,                  !00006630
     1 1.421413741, -0.284496736, 0.254829592/                          !00006640
      IF (Y .GE. 0.2) GO TO 20                                          !00006650
      T = 1./(1. + P*X)                                                 !00006660
      SUM = T*A(1)                                                      !00006670
      DO 10 I = 2, 5                                                    !00006680
   10 SUM = T*(A(I) + SUM)                                              !00006690
      OMERF = SUM*SQ                                                    !00006700
      RETURN                                                            !00006710
   20 T = 0.5/(X**2)                                                    !00006720
      OMERF = (1. - T*(1. - 3.*T*(1. - 5.*T)))/Y                        !00006730
      RETURN                                                            !00006740
      END                                                               !00006750

C----------------------------------------------------------------------
C   SUBROUTINE DSKOUT
C   SETS UP AND WRITES DISK OR TAPE OUTPUT FILE ON UNIT 4
C----------------------------------------------------------------------

      SUBROUTINE DSKOUT (OMOBS,OMSOL,ID,TDXN,ITER,KB,KE,FEPS,DFRMS,
     1 RMSRES,ISN,JSX,LAM)

      IMPLICIT NONE
      REAL OMOBS,OMSOL,TDXN(16),FEPS,DFRMS,RMSRES
      INTEGER ID(7),ITER,KB,KE,ISN,JSX,LAM
      INCLUDE 'umkehr_common.fix'

      INTEGER IOUT(19),NK,I,ISTAR
      REAL SCALE

      NK=KE-KB+1
      IOUT(1)=INT(OMOBS+0.5)
      IOUT(2)=INT(10.*OMSOL+0.5)
      DO 20 I=3,12
      ISTAR=I+3
      SCALE=100000.
   20 IOUT(I)=INT(SCALE*TDXN(ISTAR)+0.5)
      IOUT(13)=ITER
      IOUT(14)=JSX
      IOUT(15)=KB
      IOUT(16)=NK
      IOUT(17)=INT(1000.*DFRMS+0.5)
      IOUT(18)=INT(100.*FEPS+0.5)
      IOUT(19)=INT(100.*RMSRES+0.5)
      WRITE(OUT4, 4000) (ID(I),I=3,6),LAM,(IOUT(I),I=1,13),
     *(IOUT(I),I=15,19),ISN
      CALL UMKEHR_WRITE_STRING( 4, OUT4)
 4000 FORMAT (3(I3),1X,A1,I2,I5,I6,10(I6),I2,I2,I3,2(I4),I5,I4)
      
      RETURN
      END

C----------------------------------------------------------------------
C   SUBROUTINE RDSPECT
C   READ spectral parameters
C   Lambda, slit function, ET flux, alfa0, alfat, alfatt, beta, rho
C----------------------------------------------------------------------

      SUBROUTINE RDSPECT(SUMSL, SUMSH, NR1, NR2, NR12)

      IMPLICIT NONE
      REAL SUMSL,SUMSH
      INTEGER NR1,NR2,NR12
      INCLUDE 'umkehr_common.fix'
C      REAL alfaw(202), acoftw(202), acoftsw(202), betaw(202),
C     1  sfalfa(2), sfacoft(2), sfacofts(2), sfbeta(2),VALNTC(12),
C     1 sfw(202), etfw(202), alamw(202), rhow(202), sfbetag(61,2),
C     2 alftw(61,202),betagw(61,202), sfalfbar(2), sfalft(61,2)

C      COMMON /SPECTRAL/ alfaw, acoftw, acoftsw, betaw,
C     1  sfalfa, sfacoft, sfacofts, sfbeta,VALNTC,
C     1 sfw, etfw, alamw, rhow, sfbetag,
C     2 alftw,betagw, sfalfbar, sfalft

      REAL SUMA,SUMT,SUMTT,SUMB
      INTEGER NR11,NR21,II,I

        suma=0
        sumt=0
        sumtt=0
        sumb=0
        sumsl=0
          nr1=61
          nr11=nr1-1
        do i=1,nr11
        read(98,*)alamw(i),sfw(i),etfw(i),alfaw(i),acoftw(i),
     1     acoftsw(i),betaw(i),rhow(i)
          suma=suma+alfaw(i)*sfw(i)*etfw(i)
          sumt=sumt+acoftw(i)*sfw(i)*etfw(i)
          sumtt=sumtt+acoftsw(i)*sfw(i)*etfw(i)
          sumb=sumb+betaw(i)*sfw(i)*etfw(i)
          sumsl=sumsl+sfw(i)*etfw(i)
        end do

            i=nr1
        read(98,*)alamw(i),sfw(i),etfw(i),alfaw(i),acoftw(i),
     1     acoftsw(i),betaw(i),rhow(i)
          suma=suma+alfaw(i)*sfw(i)*etfw(i)
          sumt=sumt+acoftw(i)*sfw(i)*etfw(i)
          sumtt=sumtt+acoftsw(i)*sfw(i)*etfw(i)
          sumb=sumb+betaw(i)*sfw(i)*etfw(i)
          sumsl=sumsl+sfw(i)*etfw(i)

          sfalfa(1)=suma/sumsl
          sfacoft(1)=sumt/sumsl
          sfacofts(1)=sumtt/sumsl
          sfbeta(1)=sumb/sumsl

        suma=0
        sumt=0
        sumtt=0
        sumb=0
        sumsh=0
          nr2=141
          nr21=nr2-1
         nr12=nr1+nr2
        do i=1,nr21
         ii=i+nr1
        read(97,*)alamw(ii),sfw(ii),etfw(ii),alfaw(ii),acoftw(ii),
     1     acoftsw(ii),betaw(ii),rhow(ii)
          suma=suma+alfaw(ii)*sfw(ii)*etfw(ii)
          sumt=sumt+acoftw(ii)*sfw(ii)*etfw(ii)
          sumtt=sumtt+acoftsw(ii)*sfw(ii)*etfw(ii)
          sumb=sumb+betaw(ii)*sfw(ii)*etfw(ii)
          sumsh=sumsh+sfw(ii)*etfw(ii)
        end do

         ii=nr12
        read(97,*)alamw(ii),sfw(ii),etfw(ii),alfaw(ii),acoftw(ii),
     1     acoftsw(ii),betaw(ii),rhow(ii)
          suma=suma+alfaw(ii)*sfw(ii)*etfw(ii)
          sumt=sumt+acoftw(ii)*sfw(ii)*etfw(ii)
          sumtt=sumtt+acoftsw(ii)*sfw(ii)*etfw(ii)
          sumb=sumb+betaw(ii)*sfw(ii)*etfw(ii)
          sumsh=sumsh+sfw(ii)*etfw(ii)

          sfalfa(2)=suma/sumsh
          sfacoft(2)=sumt/sumsh
          sfacofts(2)=sumtt/sumsh
          sfbeta(2)=sumb/sumsh
      RETURN
      END

C ****** READ FG *********
C READ Total ozone at pressure levels 0.5, 0.8, 0.7, 0.9

      SUBROUTINE READFG()
      IMPLICIT NONE
      INCLUDE 'umkehr_common.fix'
C      REAL TOTOZTP(21),TABFG(61,21),PRES(61)
C      COMMON /FG_IO/TOTOZTP,TABFG,PRES

      INTEGER I,J
      READ (79,*) (totoztp(i),i=1,21)
      READ (18,*) (PRES(I),I=1,61)
      READ (18,*) ((TABFG(I,J),I=1,61),J=1,21)
      RETURN
      END
C----------------------------------------------------------------------
C   Subroutine RDMSCR
C   Inputs the multiple scattering corrections on unit 8
C   and the multiple scatterings correction JACOBIAN on unit 19
C----------------------------------------------------------------------

      SUBROUTINE RDMSCR()
      IMPLICIT NONE
      INCLUDE 'umkehr_common.fix'
C      REAL CQMS(12,42), SLANT(12,1891), TABJMS(61,13,21)
C      COMMON /BBBB/ SLANT,CQMS, TABJMS
      INTEGER I,J,K

      READ (8,*) ((CQMS(I,J),I=1,12),J=1,42)                             ! Read the multiple scattering corrections on unit 8, typically 'stdmscdobc_depol_top5.dat'
      do k=1,21                                                          ! READ MULTIPLE SCATTERING CORRECTIONS JACOBEAN on unit 19, typically 'stdjacmsc.dat'
      do j=1,13
      READ (19,*) (TABJMS(I,J,K),I=1,61)
      end do
      end do
      RETURN
      END

C----------------------------------------------------------------------
C   SUBROUTINE RDNRL
C   Read in NRL temperature/altitude climatology for monthly mean and zonal
C   averaged profiles
C----------------------------------------------------------------------
      SUBROUTINE RDNRL()
      IMPLICIT NONE
      INCLUDE 'umkehr_common.fix'

      INTEGER JJ,I,J,K
      REAL SWAP

      do jj=1,5
      read(15,*)
      end do
      do i=1,12
       do j=1,45
      READ(15, 9796) (TNRL(i,j,k),k=1,10)
      end do
      do jj=1,15
       read(15,*)
      end do
       do j=1,45
       READ(15, 9796) (TNRL(i,j,k),k=10,19)
      end do
       do jj=1,15
      read(15,*)
      end do
      end do
      do i=1,25
       HM(I)=FLOAT(I)-1
      end do
       do i=5,24
       HM(I+21)=5*FLOAT(I)
      end do
       DO  I=1,22
      K=46-I
      SWAP=HM(I)
      HM(I)=HM(K)
      HM(K)=SWAP
      end do
      RETURN
 9796 FORMAT (8X,10F7.2)
      END

C----------------------------------------------------------------------
C   Subroutine RDREFR
C   Inputs the refraction corrections on input unit 13
C----------------------------------------------------------------------

      SUBROUTINE RDREFR()
      IMPLICIT NONE
      INCLUDE 'umkehr_common.fix'
      INTEGER I,J

      READ (13,5501) (TOTREF(I),(REFCOR(J,I),J=12,1,-1),I=1,5)
      DO 160 I=1,5
  160 TOTREF(I)=0.01*TOTREF(I)
      RETURN
 5501 FORMAT (6X,F2.0,12F6.2)
      END

