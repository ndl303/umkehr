// umkehr_if.cpp : Defines the entry point for the console application.
//

#include "umkehr_if.h"

FortranUnitsArray	g_fortran_io_array;

/*-----------------------------------------------------------------------------
 *					trim_fortran_string		 2018- 11- 24*/
/** **/
/*---------------------------------------------------------------------------*/

const char* trim_fortran_string(  const char* str, size_t len )
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
	return buffer;
}

/*-----------------------------------------------------------------------------
 *					CONSOLEMSG		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

extern "C" void CONSOLEMSG            (const char* str, size_t len)
{
	printf( "%s\n", (const char*) trim_fortran_string(str, len) );
}

/*-----------------------------------------------------------------------------
 *					UMKEHR_WRITE_STRING		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

extern "C" void UMKEHR_WRITE_STRING( int* JUNIT, const char* str, size_t len )
{
	std::string	line( trim_fortran_string( str, len) );

	g_fortran_io_array.Write( *JUNIT, line );
}


/*-----------------------------------------------------------------------------
 *					UMKEHR_WRITE_STRING		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

extern "C" void  UMKEHR_CLOSE_OUTPUT( int* JUNIT )
{
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

