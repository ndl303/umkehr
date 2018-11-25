// umkehr_if.cpp : Defines the entry point for the console application.
//

#include "umkehr_if.h"
#include "umkehr_pythonif.h"

FortranUnitsArray	g_fortran_output_array;			// Array of buffers to save fortran output
FortranUnitsArray	g_fortran_input_array;			// Array of buffers used for fortran input

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

	g_fortran_output_array.Write( *JUNIT, line );
}

/*-----------------------------------------------------------------------------
 *					UMKEHR_CLOSE_OUTPUT		 2018- 11- 12*/
/** Closes an output stream. This is not used by the C++ implementation
 *	but is used in the Fortran emulation code.
**/
/*---------------------------------------------------------------------------*/

extern "C" void  UMKEHR_CLOSE_OUTPUT( int* JUNIT )
{
}

/*-----------------------------------------------------------------------------
 *					UMKEHR_READ_LINE		 2018- 11- 25*/
/** Returns the next line of text from an input strteam as a fortran
 *	string. The next input line is copied to the fotran string and is
 *	padded with spaces. The Fortran string does not require a null terminator
 **/
/*---------------------------------------------------------------------------*/

extern "C" void UMKEHR_READ_LINE( int* JUNIT, int* IEOF, char* ALINE, size_t len )
{
	bool				endoffile;
	const std::string&	line = g_fortran_output_array.GetNextReadBack( *JUNIT, &endoffile);

	*IEOF = endoffile ?  1 : 0;
	for (size_t i = 0; i < len; i++)
	{
		if (i >= line.size()) ALINE[i] = ' ';
		else                  ALINE[i] = line.at(i);                  
	}
}

/*-----------------------------------------------------------------------------
 *					set_umkehr_inputfolder		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

bool set_umkehr_inputfolder( const char* inputfolder)
{
	UMKEHR_SET_INPUTFOLDER( inputfolder, strlen(inputfolder) );						// Make sure UMKEHR can find the input files stored in the data folder in the package
	return true;
}

/*-----------------------------------------------------------------------------
 *					get_output_stream		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

const std::list<std::string>& get_output_stream( int unit)
{

	const std::list<std::string>& lines = g_fortran_output_array.Lines(unit);
	for (auto iter = lines.begin(); iter != lines.end(); iter++)
	{
		printf( "%s\n", (const char*)(iter->c_str()) );
	}
	return lines;
}


/*-----------------------------------------------------------------------------
 *					get_output_stream		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

const std::list<std::string>& get_input_stream( int unit)
{

	const std::list<std::string>& lines = g_fortran_input_array.Lines(unit);
	for (auto iter = lines.begin(); iter != lines.end(); iter++)
	{
		printf( "%s\n", (const char*)(iter->c_str()) );
	}
	return lines;
}

/*-----------------------------------------------------------------------------
 *					set_umkehr_input_filename		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

void set_umkehr_input_filename( int unit, const char*  fullname )
{
	UMKEHR_SET_IONAMES( &unit, fullname, strlen(fullname) );
}

/*-----------------------------------------------------------------------------
 *					analyze_umkehr		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

bool analyze_umkehr( const char* inputfilename, int KBN  )
{
	g_fortran_output_array.Clear();															// Clear the output array

	set_umkehr_input_filename( 10, inputfilename);
	DECODE_CUMKEHR_OBS( inputfilename, strlen(inputfilename) );								// Decode the input UMKEHR file
	printf("DONE DECODE\n");
	get_output_stream     (10);
	printf("Copying over to input\n");

	g_fortran_input_array.CopyUnitForReadBack( 10, 10, g_fortran_output_array );			// Copy Unit 10 over to unit 10 on the input array so the UMKEHR algorithm can pipe in from this unit.
	get_input_stream     (10);
	printf("Starting UMKEHR\n");
	UMKEHR( &KBN );
    return 0;
}


