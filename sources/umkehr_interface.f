      BLOCK DATA
      INCLUDE 'umkehr_common.fix'
      DATA UMKEHR_FILENAME_UNIT05 /'mk2v4cum.inp'/
      DATA UMKEHR_FILENAME_UNIT08 /'stdmscdobc_depol_top5.dat'/
      DATA UMKEHR_FILENAME_UNIT09 /'fstguess.99b'/
      DATA UMKEHR_FILENAME_UNIT10 /'User must set station file'/
      DATA UMKEHR_FILENAME_UNIT11 /'phprofil.dat'/
      DATA UMKEHR_FILENAME_UNIT13 /'refractn.dat'/
      DATA UMKEHR_FILENAME_UNIT15 /'nrl.dat'/
      DATA UMKEHR_FILENAME_UNIT18 /'std_pfl.asc'/
      DATA UMKEHR_FILENAME_UNIT19 /'stdjacmsc.dat'/
      DATA UMKEHR_FILENAME_UNIT79 /'totoz_press.dat'/
      DATA UMKEHR_FILENAME_UNIT97 /'coef_dobch.dat'/
      DATA UMKEHR_FILENAME_UNIT98 /'coef_dobcl.dat'/

      DATA DECODE_FILENAME_UNIT05 /'decodev4.inp'/
      DATA DECODE_FILENAME_UNIT06 /'unit6.prn'/
      DATA DECODE_FILENAME_UNIT10 /'User must set station file'/
      DATA DECODE_FILENAME_UNIT11 /'stnindex.dat'/
      DATA DECODE_FILENAME_UNIT12 /'umknov09.jpn'/

      DATA INPUT_BASEFOLDER /''/

      DATA UMKEHR_USEDEFAULT_UNIT05 /1/
      DATA UMKEHR_USEDEFAULT_UNIT08 /1/
      DATA UMKEHR_USEDEFAULT_UNIT09 /1/
      DATA UMKEHR_USEDEFAULT_UNIT10 /1/
      DATA UMKEHR_USEDEFAULT_UNIT11 /1/
      DATA UMKEHR_USEDEFAULT_UNIT13 /1/
      DATA UMKEHR_USEDEFAULT_UNIT15 /1/
      DATA UMKEHR_USEDEFAULT_UNIT18 /1/
      DATA UMKEHR_USEDEFAULT_UNIT19 /1/
      DATA UMKEHR_USEDEFAULT_UNIT79 /1/
      DATA UMKEHR_USEDEFAULT_UNIT97 /1/
      DATA UMKEHR_USEDEFAULT_UNIT98 /1/

      DATA DECODE_USEDEFAULT_UNIT05 /1/
      DATA DECODE_USEDEFAULT_UNIT06 /1/
      DATA DECODE_USEDEFAULT_UNIT10 /1/
      DATA DECODE_USEDEFAULT_UNIT11 /1/
      DATA DECODE_USEDEFAULT_UNIT12 /1/

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
          UMKEHR_FILENAME_UNIT05   = FILENAME
          UMKEHR_USEDEFAULT_UNIT05 = 0
      ELSE IF (JUNIT .EQ.  8) THEN
          UMKEHR_FILENAME_UNIT08   = FILENAME
          UMKEHR_USEDEFAULT_UNIT08 = 0
      ELSE IF (JUNIT .EQ.  9) THEN
          UMKEHR_FILENAME_UNIT09   = FILENAME
          UMKEHR_USEDEFAULT_UNIT09 = 0
      ELSE IF (JUNIT .EQ. 10) THEN
          UMKEHR_FILENAME_UNIT10   = FILENAME
          UMKEHR_USEDEFAULT_UNIT10 = 0
      ELSE IF (JUNIT .EQ. 11) THEN
          UMKEHR_FILENAME_UNIT11   = FILENAME
          UMKEHR_USEDEFAULT_UNIT11 = 0
      ELSE IF (JUNIT .EQ. 13) THEN
          UMKEHR_FILENAME_UNIT13   = FILENAME
          UMKEHR_USEDEFAULT_UNIT13 = 0
      ELSE IF (JUNIT .EQ. 15) THEN
          UMKEHR_FILENAME_UNIT15   = FILENAME
          UMKEHR_USEDEFAULT_UNIT15 = 0
      ELSE IF (JUNIT .EQ. 18) THEN
          UMKEHR_FILENAME_UNIT18   = FILENAME
          UMKEHR_USEDEFAULT_UNIT18 = 0
      ELSE IF (JUNIT .EQ. 19) THEN
          UMKEHR_FILENAME_UNIT19   = FILENAME
          UMKEHR_USEDEFAULT_UNIT19 = 0
      ELSE IF (JUNIT .EQ. 79) THEN
          UMKEHR_FILENAME_UNIT79   = FILENAME
          UMKEHR_USEDEFAULT_UNIT79 = 0
      ELSE IF (JUNIT .EQ. 97) THEN
          UMKEHR_FILENAME_UNIT97   = FILENAME
          UMKEHR_USEDEFAULT_UNIT97 = 0
      ELSE IF (JUNIT .EQ. 98) THEN
          UMKEHR_FILENAME_UNIT98   = FILENAME
          UMKEHR_USEDEFAULT_UNIT98 = 0
C     ----- Handle the DECODE filenames.  User adds 100 to unit for the decode subroutine
      ELSE IF (JUNIT .EQ. 105) THEN
          DECODE_FILENAME_UNIT05   = FILENAME
          DECODE_USEDEFAULT_UNIT05 = 0
      ELSE IF (JUNIT .EQ. 106) THEN
          DECODE_FILENAME_UNIT06   = FILENAME
          DECODE_USEDEFAULT_UNIT06 = 0
      ELSE IF (JUNIT .EQ. 110) THEN
          DECODE_FILENAME_UNIT10   = FILENAME
          DECODE_USEDEFAULT_UNIT10 = 0
      ELSE IF (JUNIT .EQ. 111) THEN
          DECODE_FILENAME_UNIT11   = FILENAME
          DECODE_USEDEFAULT_UNIT11 = 0
      ELSE IF (JUNIT .EQ. 112) THEN
          DECODE_FILENAME_UNIT12   = FILENAME
          DECODE_USEDEFAULT_UNIT12  = 0

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
C   JUNIT : The integer number of the fortran file unit. For the DECODE subroutine
C           add 100 to the UNIT number
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
      INTEGER       USEDEFAULT

      INCLUDE 'umkehr_common.fix'

      IF (JUNIT .EQ.  5) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT05
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT05
      ELSE IF (JUNIT .EQ.  8) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT08
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT08
      ELSE IF (JUNIT .EQ.  9) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT09
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT09
      ELSE IF (JUNIT .EQ. 10) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT10
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT10
      ELSE IF (JUNIT .EQ. 11) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT11
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT11
      ELSE IF (JUNIT .EQ. 13) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT13
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT13
      ELSE IF (JUNIT .EQ. 15) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT15
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT15
      ELSE IF (JUNIT .EQ. 18) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT18
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT18
      ELSE IF (JUNIT .EQ. 19) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT19
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT19
      ELSE IF (JUNIT .EQ. 79) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT79
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT79
      ELSE IF (JUNIT .EQ. 97) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT97
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT97
      ELSE IF (JUNIT .EQ. 98) THEN
          UMKEHR_INPUTFILENAME= UMKEHR_FILENAME_UNIT98
          USEDEFAULT          = UMKEHR_USEDEFAULT_UNIT98
      ELSE IF (JUNIT .EQ. 105) THEN
          UMKEHR_INPUTFILENAME= DECODE_FILENAME_UNIT05
          USEDEFAULT          = DECODE_USEDEFAULT_UNIT05
      ELSE IF (JUNIT .EQ. 106) THEN
          UMKEHR_INPUTFILENAME= DECODE_FILENAME_UNIT06
          USEDEFAULT          = DECODE_USEDEFAULT_UNIT06
      ELSE IF (JUNIT .EQ. 110) THEN
          UMKEHR_INPUTFILENAME= DECODE_FILENAME_UNIT10
          USEDEFAULT          = DECODE_USEDEFAULT_UNIT10
      ELSE IF (JUNIT .EQ. 111) THEN
          UMKEHR_INPUTFILENAME= DECODE_FILENAME_UNIT11
          USEDEFAULT          = DECODE_USEDEFAULT_UNIT11
      ELSE IF (JUNIT .EQ. 112) THEN
          UMKEHR_INPUTFILENAME= DECODE_FILENAME_UNIT12
          USEDEFAULT          = DECODE_USEDEFAULT_UNIT12
      ELSE
          UMKEHR_INPUTFILENAME= 'INVALID UNIT REQUESTED'
      END IF

      IF (USEDEFAULT .NE. 0 ) THEN
      UMKEHR_INPUTFILENAME= TRIM(INPUT_BASEFOLDER)//UMKEHR_INPUTFILENAME
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
C   DECODE_OPEN_INPUTFILE
C   Opens an input file for the DECODE algorithm
C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C
C   RETURNS:
C   --------
C   The character string representing the full filename
C
C----------------------------------------------------------------------

      SUBROUTINE DECODE_OPEN_INPUTFILE( JUNIT )
      IMPLICIT NONE
      INTEGER JUNIT
      CHARACTER*600 UMKEHR_INPUTFILENAME

      OPEN( UNIT   = JUNIT,
     1      FILE   = UMKEHR_INPUTFILENAME( 100 + JUNIT ),
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


C----------------------------------------------------------------------
C   DECODE_CLOSE_INPUTFILE
C   Closes an input file for the DECODE algorithm
C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C
C   RETURNS:
C   --------
C   The character string representing the full filename
C
C----------------------------------------------------------------------

      SUBROUTINE DECODE_CLOSE_FILE( JUNIT )
      IMPLICIT NONE
      INTEGER JUNIT

      CLOSE( UNIT = JUNIT )
      RETURN
      END


