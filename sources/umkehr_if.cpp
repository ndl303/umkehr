// umkehr_if.cpp : Defines the entry point for the console application.
//

#include "umkehr_if.h"
#include <string>
#define UMKEHR					umkehr_						// C++ calls this fortran function to execute the primary UMKEHR analysis
#define UMKEHR_WRITE_STRING		umkehr_write_string_		// Fortran calls this C++ function to write output data on a given unit. It is called during execution of subroutine UMKEHR.
#define CONSOLEMSG				consolemsg_					// Fortran calls this C++ function to writye a log message to the console
#define UMKEHR_SET_INPUTFOLDER	umkehr_set_input_folder_	// C++ calls this fortran function to set the input folder for the UMKEHR input files
#define UMKEHR_SET_IONAMES      umkehr_set_ionames_			// C++ calls this fortran function to the name of one of the input files

extern "C" void UMKEHR( int* KBN );
extern "C" void UMKEHR_SET_INPUTFOLDER( const char* str, size_t len );
extern "C" void UMKEHR_SET_IONAMES    ( int* JUNIT,  const char* str, size_t len );

/*-----------------------------------------------------------------------------
 *					CONSOLEMSG		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

extern "C" void CONSOLEMSG            (const char* str, size_t len)
{
	static char buffer[6000];
	bool		iswhite = true;

	strncpy_s( buffer, 6000, str, len);
	buffer[len] = '\0';
	while (iswhite && (len > 0))
	{
		len--;
		iswhite = buffer[len] == ' ';
		if (iswhite) buffer[len] = '\0';
	}
	printf( "CONSOLE: %s\n", (const char*) buffer);
}

/*-----------------------------------------------------------------------------
 *					UMKEHR_WRITE_STRING		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

extern "C" void UMKEHR_WRITE_STRING( int* JUNIT, const char* str, size_t len )
{
	static char buffer[6000];
	bool		iswhite = true;
	strncpy_s( buffer, 6000, str, len);
	buffer[len] = '\0';
	while (iswhite && (len > 0))
	{
		len--;
		iswhite = buffer[len] == ' ';
		if (iswhite) buffer[len] = '\0';
	}
	printf( "%3d %5d %s\n", (int)*JUNIT, (int)strlen(buffer), (const char*) buffer);
}

/*-----------------------------------------------------------------------------
 *					main		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

int main()
{
	int KBN       = 3;
	int inputunit = 10;
	const char*	name = "test.prn";
	size_t  len = strlen(name);

	printf("Starting UP C++ interface test\n");
	UMKEHR_SET_IONAMES( &inputunit, name, len);
	UMKEHR( &KBN );
    return 0;
}

