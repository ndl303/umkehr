      BLOCK DATA
      INCLUDE 'umkehr_common.fix'
      DATA FILENAME_UNIT05 /'mk2v4cum.inp'/
      DATA FILENAME_UNIT08 /'stdmscdobc_depol_top5.dat'/
      DATA FILENAME_UNIT09 /'fstguess.99b'/
      DATA FILENAME_UNIT10 /'User must set name of the station file'/
      DATA FILENAME_UNIT11 /'phprofil.dat'/
      DATA FILENAME_UNIT13 /'refractn.dat'/
      DATA FILENAME_UNIT15 /'nrl.dat'/
      DATA FILENAME_UNIT18 /'std_pfl.asc'/
      DATA FILENAME_UNIT19 /'stdjacmsc.dat'/
      DATA FILENAME_UNIT79 /'totoz_press.dat'/
      DATA FILENAME_UNIT97 /'coef_dobch.dat'/
      DATA FILENAME_UNIT98 /'coef_dobcl.dat'/
      DATA INPUT_BASEFOLDER /''/
      END


C----------------------------------------------------------------------
C  UMKEHR_SET_INPUTFOLDER
C  Sets the input folder for the various input files used in the UMKEHR
C  analysis. The default is blank( current execution folder). It is
C  provided so users can change configuration if they need too. The
C  input folder name must include the trailing forward/backward slash
C  if it is anything othern than blank.
C----------------------------------------------------------------------

      SUBROUTINE UMKEHR_SET_INPUTFOLDER( FOLDERNAME )
      IMPLICIT NONE
      CHARACTER *(*) FOLDERNAME
      INCLUDE 'umkehr_common.fix'

      INPUT_BASEFOLDER = FOLDERNAME
      RETURN
      END

C----------------------------------------------------------------------
C  UMKEHR_SET_IONAMES
C  Sets the names of the various input files used in the UMKEHR
C  analysis. This function can be used to change the input names
C  of the file read in by UMKEHR. It is provided so users can change
C  configuration files without recompiling if they need too.
C----------------------------------------------------------------------

      SUBROUTINE UMKEHR_SET_IONAMES( JUNIT, FILENAME )
      IMPLICIT NONE

      INTEGER        JUNIT
      CHARACTER*(*)  FILENAME
      INCLUDE 'umkehr_common.fix'
      IF (JUNIT .EQ.  5) THEN
          FILENAME_UNIT05 = FILENAME
      ELSE IF (JUNIT .EQ.  8) THEN
          FILENAME_UNIT08 = FILENAME
      ELSE IF (JUNIT .EQ.  9) THEN
          FILENAME_UNIT09 = FILENAME
      ELSE IF (JUNIT .EQ. 10) THEN
          FILENAME_UNIT10 = FILENAME
      ELSE IF (JUNIT .EQ. 11) THEN
          FILENAME_UNIT11 = FILENAME
      ELSE IF (JUNIT .EQ. 13) THEN
          FILENAME_UNIT13 = FILENAME
      ELSE IF (JUNIT .EQ. 15) THEN
          FILENAME_UNIT15 = FILENAME
      ELSE IF (JUNIT .EQ. 18) THEN
          FILENAME_UNIT18 = FILENAME
      ELSE IF (JUNIT .EQ. 19) THEN
          FILENAME_UNIT19 = FILENAME
      ELSE IF (JUNIT .EQ. 79) THEN
          FILENAME_UNIT79 = FILENAME
      ELSE IF (JUNIT .EQ. 97) THEN
          FILENAME_UNIT97 = FILENAME
      ELSE IF (JUNIT .EQ. 98) THEN
          FILENAME_UNIT98 = FILENAME
      ELSE
         CALL CONSOLEMSG('ERROR: UMKEHR_SET_IONAMES, Unsupported unit')
      END IF
      RETURN
      END

C----------------------------------------------------------------------
C   UMKEHR_INPUTFILENAME
C   Returns the full name of one of the UMKEHR input files. This simply
C   checks that the reuested UNIT is one used by UMKEHR and then concatenates
C   the inpout base folder and the input filename
C
C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C
C   RETURNS:
C   --------
C   The character string representing the full filename
C
C----------------------------------------------------------------------

      FUNCTION UMKEHR_INPUTFILENAME( JUNIT )
      IMPLICIT NONE

      CHARACTER*600  UMKEHR_INPUTFILENAME
      INTEGER        JUNIT

      INCLUDE 'umkehr_common.fix'

      IF (JUNIT .EQ.  5) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT05
      ELSE IF (JUNIT .EQ.  8) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT08
      ELSE IF (JUNIT .EQ.  9) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT09
      ELSE IF (JUNIT .EQ. 10) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT10
      ELSE IF (JUNIT .EQ. 11) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT11
      ELSE IF (JUNIT .EQ. 13) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT13
      ELSE IF (JUNIT .EQ. 15) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT15
      ELSE IF (JUNIT .EQ. 18) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT18
      ELSE IF (JUNIT .EQ. 19) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT19
      ELSE IF (JUNIT .EQ. 79) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT79
      ELSE IF (JUNIT .EQ. 97) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT97
      ELSE IF (JUNIT .EQ. 98) THEN
          UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//FILENAME_UNIT98
      ELSE
          UMKEHR_INPUTFILENAME= 'INVALID UNIT REQUESTED'
      END IF
      RETURN
      END

C----------------------------------------------------------------------
C   UMKEHR_OPEN_INPUTFILE
C   Opens an input file for the UMKEHR algorithm
C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C
C   RETURNS:
C   --------
C   The character string representing the full filename
C
C----------------------------------------------------------------------

      SUBROUTINE UMKEHR_OPEN_INPUTFILE( JUNIT )
      IMPLICIT NONE
      INTEGER JUNIT
      CHARACTER*600 UMKEHR_INPUTFILENAME

      OPEN( UNIT   = JUNIT,
     1      FILE   = UMKEHR_INPUTFILENAME( JUNIT ),
     2      STATUS ='old')

      RETURN
      END

C----------------------------------------------------------------------
C   UMKEHR_CLOSE_INPUTFILE
C   Closes an input file for the UMKEHR algorithm
C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C
C   RETURNS:
C   --------
C   The character string representing the full filename
C
C----------------------------------------------------------------------

      SUBROUTINE UMKEHR_CLOSE_INPUTFILE( JUNIT )
      IMPLICIT NONE
      INTEGER JUNIT

      CLOSE( UNIT = JUNIT )
      RETURN
      END

