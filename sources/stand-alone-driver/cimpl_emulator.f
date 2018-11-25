
C----------------------------------------------------------------------
C   CONSOLEMSG
C   This emulates a console message. This stream is reserved for
C   logging type activity as errors will normally flow through this
C   function.
C
C   Input Parameter
C   ---------------
C   MESSAGE : The character string to write to the console/log
C----------------------------------------------------------------------

      SUBROUTINE CONSOLEMSG( MESSAGE )
      IMPLICIT NONE
      CHARACTER*(*) MESSAGE
      WRITE(*,*) MESSAGE
      RETURN
      END

C----------------------------------------------------------------------
C   UMKEHR_WRITE_STRING
C   This emulates a write to a Fortran file unit. This is normally implemented
C   by the C++ -> Python interface. This function provides a quick and
C   dirty implementation for testing purposes.
C
C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C
C----------------------------------------------------------------------

      SUBROUTINE UMKEHR_WRITE_STRING( JUNIT, STRLINE )
      IMPLICIT NONE
      INTEGER       JUNIT
      CHARACTER*(*) STRLINE

      WRITE( JUNIT, 123)TRIM(STRLINE)
      if (JUNIT .EQ. 6)  WRITE(16, 123)TRIM(STRLINE)
  123 FORMAT(A)
  124 FORMAT(I3,2X,A)
      RETURN
      END


C----------------------------------------------------------------------
C   UMKEHR_CLOSE_OUTPUT
C   This emulates closing an output stream.

C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C
C----------------------------------------------------------------------

      SUBROUTINE UMKEHR_CLOSE_OUTPUT( JUNIT )
      IMPLICIT NONE
      INTEGER       JUNIT

      IF ((JUNIT .NE. 5) .AND. (JUNIT .NE. 6)) THEN
         CLOSE(UNIT =JUNIT)
      END IF
      RETURN
      END

C----------------------------------------------------------------------
C   UMKEHR_READ_LINE
C   Reads a line of text from the specified input. This can be replaced
C   by a C++ function that reads a line of text from an internal array
C   rather than a file.
C
C   Input Parameter
C   ---------------
C   JUNIT : The integer number of the fortran file unit
C   ALINE : The charcater array to hold the line of text
C   IEOF  : Returns 0 if ok. 1 if end of file or other error
C
C----------------------------------------------------------------------

      SUBROUTINE UMKEHR_READ_LINE( JUNIT, IEOF,ALINE )
      IMPLICIT NONE
      CHARACTER* (*) ALINE
      INTEGER        JUNIT,IEOF

      IEOF = 0
      READ (JUNIT,5600,END=900) ALINE
      RETURN
  900 IEOF = 1
      ALINE=' '
 5600 FORMAT(A)
      RETURN
      END

