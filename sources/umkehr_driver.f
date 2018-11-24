      PROGRAM umkehr_driver
c **** open input and output data files *****
      IMPLICIT NONE
      CHARACTER*60 inputfilename
      INTEGER KBN

C      print*, 'provide the lowest SZA'
C      read(5,*) KBN

      inputfilename = '../testdata/umknov09.jpn'
      CALL DECODE_CUMKEHR_OBS( inputfilename)
      CLOSE(UNIT=10)

      KBN = 3
      print *,KBN
      CALL UMKEHR_SET_IONAMES( 10, 'fort.10')
      CALL UMKEHR( KBN)
      print*,'Finished processing test file'
      STOP
      END PROGRAM umkehr_driver
