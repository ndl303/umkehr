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
#include <memory>

#define DECODE_CUMKEHR_OBS		decode_cumkehr_obs_
#define UMKEHR					umkehr_						// C++ calls this fortran function to execute the primary UMKEHR analysis
#define UMKEHR_SET_INPUTFOLDER	umkehr_set_inputfolder_		// C++ calls this fortran function to set the input folder for the UMKEHR input files
#define UMKEHR_SET_IONAMES      umkehr_set_ionames_			// C++ calls this fortran function to the name of one of the input files

#define UMKEHR_WRITE_STRING		umkehr_write_string_		// Fortran calls this C++ function to write output data on a given unit. It is called during execution of subroutine UMKEHR.
#define UMKEHR_CLOSE_OUTPUT		umkehr_close_output_		// Fortran calls this C++ function to close a given output stream (generally does nothing for C++ as Fortran output is internally cached in memory)
#define CONSOLEMSG				consolemsg_					// Fortran calls this C++ function to writye a log message to the console
#define UMKEHR_READ_LINE		umkehr_read_line_			// Fortran calls this C++ function to reads a line of text from an input stream.

extern "C" void DECODE_CUMKEHR_OBS    ( );
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
		std::list< std::string>				m_lines;
		std::list< std::string>::iterator	m_iterator;

	public:
										FortranUnitBuffer	()							{ }
		bool							AddLine				( const std::string& str)	{ m_lines.push_back( str ); return true; }
		bool							StartReadBack		();
		bool							EndOfReadBack		()							{ return (m_iterator == m_lines.end());}
		const std::list< std::string>&	Lines				()							{ return m_lines;}
		const std::string&				GetNextReadBack		();
		void							Clear				() { m_lines.clear(); }
};


/*-----------------------------------------------------------------------------
 *					FortranUnitsArray		 2018- 11- 24*/
/** **/
/*---------------------------------------------------------------------------*/

class FortranUnitsArray
{
	private:
				std::map< int, std::shared_ptr<FortranUnitBuffer> >				m_units;
		typedef std::map< int, std::shared_ptr<FortranUnitBuffer> >::value_type	value_type;

	public:
												FortranUnitsArray	()	{ }
		std::shared_ptr<FortranUnitBuffer>		Buffer				( int unit, bool autoinsert );
		bool									Write				( int unit, const std::string& str);
		const std::list< std::string>&			Lines				( int unit);
		bool									StartReadBack		( int unit );
		const std::string&						GetNextReadBack		( int unit, bool* endoffile);
		bool									CopyUnitForReadBack	( int outputunit, int inputunit, FortranUnitsArray& other);
		void									Clear				() {m_units.clear();}
};
