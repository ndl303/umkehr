#include "umkehr_if.h"

extern "C" void DECODE_CUMKEHR_OBS    ( const char* station_inputfilename, size_t len)
{
	printf("Calling DECODE_CUMKEHR_OBS with file %s\n", (const char*)station_inputfilename);
}
extern "C" void UMKEHR                ( int* KBN )
{
	printf("Calling UMKEHR with SZA angle %d\n", (int)(*KBN) );
}
extern "C" void UMKEHR_SET_INPUTFOLDER( const char* str, size_t len )
{
	printf("Calling UMKEHR_SET_INPUTFOLDER with folder %s\n", (const char*)str);
}
extern "C" void UMKEHR_SET_IONAMES    ( int* JUNIT,  const char* str, size_t len )
{
	printf("Calling UMKEHR_SET_IONAMES with unit = %d, ioname=%s\n", (int)*JUNIT, (const char*)str);

}
