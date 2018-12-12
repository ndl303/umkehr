// umkehr_if.cpp : Defines the entry point for the console application.
//

#include "umkehr_if.h"
#include "umkehr_pythonif.h"

FortranUnitsArray	g_fortran_output_array;			// Array of buffers to save fortran output
FortranUnitsArray	g_fortran_input_array;			// Array of buffers used for fortran input


/*-----------------------------------------------------------------------------
 *					reset_io_buffers		 2018- 11- 30*/
/** Reset all of the internal buffers so they are empty
**/
/*---------------------------------------------------------------------------*/

void clear_io_buffers()
{
	g_fortran_output_array.Clear();
	g_fortran_input_array.Clear();
	fflush(stdout);

}

/*-----------------------------------------------------------------------------
 *					trim_fortran_string		 2018- 11- 24*/
/** **/
/*---------------------------------------------------------------------------*/

const char* trim_fortran_string(  const char* str, size_t len )
{
	static char buffer[6000];
	bool		iswhite = true;

	if (len > 6000) len = 6000;
	strncpy( buffer, str, len);
	len--;
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
	printf( "CONSOLEMSG: %s\n", (const char*) trim_fortran_string(str, len) );
	fflush(stdout);
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
/** Returns the next line of text from an input stream as a fortran
 *	string. The next input line is copied to the fotran string and is
 *	padded with spaces. The Fortran string does not require a null terminator
 **/
/*---------------------------------------------------------------------------*/

extern "C" void UMKEHR_READ_LINE( int* JUNIT, int* IEOF, char* ALINE, size_t len )
{
	bool				endoffile;
	const std::string&	line = g_fortran_input_array.GetNextReadBack( *JUNIT, &endoffile);

	*IEOF = endoffile ?  1 : 0;

	for (size_t i = 0; i < len; i++)
	{
		if (i >= line.size()) ALINE[i] = ' ';
		else                  ALINE[i] = line.at(i);
	}
}


/*-----------------------------------------------------------------------------
 *					write_to_internal_input_buffer		 2018- 11- 30*/
/** Used by Python to write to an internal buffer in the output array**/
/*---------------------------------------------------------------------------*/

void write_to_input_buffer (int unit, const char* line)
{
	g_fortran_input_array.Write( unit, std::string(line) );
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
	return lines;
}


/*-----------------------------------------------------------------------------
 *					get_output_stream		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

const std::list<std::string>& get_input_stream( int unit)
{

	const std::list<std::string>& lines = g_fortran_input_array.Lines(unit);
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

bool analyze_umkehr( int KBN  )
{
	g_fortran_output_array.Clear();															// Clear the output array
	g_fortran_input_array.StartReadBack(12);												// Prepare to start reading on unit 12
	DECODE_CUMKEHR_OBS( );																	// Decode the input UMKEHR file
	get_output_stream     (10);
	g_fortran_input_array.CopyUnitForReadBack( 10, 10, g_fortran_output_array );			// Copy Unit 10 over to unit 10 on the input array so the UMKEHR algorithm can pipe in from this unit.
	get_input_stream     (10);
	UMKEHR( &KBN );
    return 0;
}


