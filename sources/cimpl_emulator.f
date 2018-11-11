
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
      INTEGER        JUNIT
      CHARACTER *(*) STRLINE

      WRITE(*,*)JUNIT,' ',STRLINE
      RETURN
      END


