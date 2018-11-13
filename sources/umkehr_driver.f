      PROGRAM umkehr_driver
c **** open input and output data files *****
      IMPLICIT NONE
      CHARACTER*60 ft10
      INTEGER KBN

      print*, 'provide the lowest SZA'
C      read(5,*) KBN
      KBN = 3
      print *,KBN
      print*,'   enter name of input file from decode:  '
      ft10='test.prn'
C      read*,ft10
      print*,ft10
      CALL UMKEHR_SET_IONAMES( 10, ft10)
      CALL UMKEHR( KBN)
      print*,'Finished processing test file'
      STOP
      END PROGRAM umkehr_driver
