// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once
#include <stdio.h>
#include <string.h>
#include <list>
#include <map>
#include <string>

#define DECODE_CUMKEHR_OBS		decode_cumkehr_obs_
#define UMKEHR					umkehr_						// C++ calls this fortran function to execute the primary UMKEHR analysis
#define UMKEHR_WRITE_STRING		umkehr_write_string_		// Fortran calls this C++ function to write output data on a given unit. It is called during execution of subroutine UMKEHR.
#define CONSOLEMSG				consolemsg_					// Fortran calls this C++ function to writye a log message to the console
#define UMKEHR_SET_INPUTFOLDER	umkehr_set_input_folder_	// C++ calls this fortran function to set the input folder for the UMKEHR input files
#define UMKEHR_SET_IONAMES      umkehr_set_ionames_			// C++ calls this fortran function to the name of one of the input files

extern "C" void DECODE_CUMKEHR_OBS    ( const char* station_inputfilename, size_t len);
extern "C" void UMKEHR                ( int* KBN );
extern "C" void UMKEHR_SET_INPUTFOLDER( const char* str, size_t len );
extern "C" void UMKEHR_SET_IONAMES    ( int* JUNIT,  const char* str, size_t len );



/*-----------------------------------------------------------------------------
 *					FortranUnitBuffer		 2018- 11- 24*/
/** **/
/*---------------------------------------------------------------------------*/

class FortranUnitBuffer
{
	private:
		std::list< std::string>	m_lines;

	public:
								FortranUnitBuffer()				 { }
		bool					AddLine( const std::string& str) { m_lines.push_back( str ); return true; }
};



/*-----------------------------------------------------------------------------
 *					FortranUnitsArray		 2018- 11- 24*/
/** **/
/*---------------------------------------------------------------------------*/

class FortranUnitsArray
{
	private:
				std::map< int, FortranUnitBuffer>				m_units;
		typedef std::map< int, FortranUnitBuffer>::value_type	value_type;

	public:
								FortranUnitsArray()	{ }
		bool					Write( int unit, const std::string& str);
};




// TODO: reference additional headers your program requires here
