      PROGRAM umkehr_driver
c **** open input and output data files *****
      IMPLICIT NONE
      CHARACTER*60 inputfilename
      CHARACTER*60 outputfilename
      CHARACTER*60 intermediatename
      INTEGER KBN

C      print*, 'provide the lowest SZA'
C      read(5,*) KBN

      inputfilename    = './testdata/umknov09.jpn'
      intermediatename = './testdata/umknov09_intermediate.prn'
      outputfilename   = './testdata/umknov09_syowa.txt'

      WRITE(*,*)'Started converting station file', inputfilename
      OPEN( UNIT=10, file = intermediatename, status = 'unknown')

      CALL UMKEHR_SET_INPUTFOLDER('./data/' )
      CALL DECODE_CUMKEHR_OBS( inputfilename)
      WRITE(*,*) 'Written converted file to  ', intermediatename
      WRITE(*,*) 'Starting UMKEHR analysis'

      KBN = 3
      open( unit = 4, file=outputfilename, status = 'unknown')
      CALL UMKEHR_SET_IONAMES    ( 10, intermediatename)
      CALL UMKEHR( KBN)
      WRITE(*,*)'Finished UMKEHR Analysis ->', outputfilename
      STOP
      END PROGRAM umkehr_driver
