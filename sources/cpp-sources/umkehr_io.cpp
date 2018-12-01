#include "umkehr_if.h"


/*-----------------------------------------------------------------------------
 *					FortranUnitBuffer::GetNextReadBack		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

const std::string& FortranUnitBuffer::GetNextReadBack()
{
	static std::string empty;
	bool				ok;

	ok = (m_iterator != m_lines.end());
	return  ok ? *m_iterator++: empty;
}


/*-----------------------------------------------------------------------------
 *					FortranUnitBuffer::StartReadBack		 2018- 12- 1*/
/** **/
/*---------------------------------------------------------------------------*/

bool FortranUnitBuffer::StartReadBack()
{
	m_iterator = m_lines.begin(); 
	return true;
}

/*-----------------------------------------------------------------------------
 *					FortranUnitsArray::Write		 2018- 11- 24*/
/** **/
/*---------------------------------------------------------------------------*/

bool FortranUnitsArray::Write( int unit, const std::string& str)
{
	std::shared_ptr<FortranUnitBuffer> buffer = Buffer(unit, true);
	bool                               ok     = buffer.get() != nullptr;

	ok = ok && buffer->AddLine(str);
	return ok;
}

/*-----------------------------------------------------------------------------
 *					FortranUnitsArray::StartReadBack		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

bool FortranUnitsArray::StartReadBack( int unit )
{
	std::shared_ptr<FortranUnitBuffer> buffer = Buffer(unit, false);
	bool                               ok     = buffer.get() != nullptr;

	ok = ok && buffer->StartReadBack();
	return ok;
}


/*-----------------------------------------------------------------------------
 *					FortranUnitsArray::GetNextReadBack		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

const std::string& FortranUnitsArray::GetNextReadBack( int unit, bool* endoffile)
{
	static std::string empty; 
	std::shared_ptr<FortranUnitBuffer> buffer = Buffer(unit, false);
	bool                               ok     = buffer.get() != nullptr;

	ok = ok && !buffer->EndOfReadBack();
	*endoffile = !ok;
	return  ok ? buffer->GetNextReadBack(): empty;
}


/*-----------------------------------------------------------------------------
 *					FortranUnitsArray::Lines		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

const std::list< std::string>&	FortranUnitsArray::Lines( int unit)
{
	std::shared_ptr<FortranUnitBuffer> buffer = Buffer(unit, false);
	bool                               ok     = buffer.get() != nullptr;
	static std::list< std::string> empty;

	if (!ok) return empty;
	return buffer->Lines();
}
/*-----------------------------------------------------------------------------
 *					FortranUnitsArray::CopyUnitForReadBack		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

bool FortranUnitsArray::CopyUnitForReadBack	( int outputunit, int inputunit, FortranUnitsArray& other)
{
	std::shared_ptr<FortranUnitBuffer> buffer = other.Buffer(outputunit, false);
	bool                               ok     = buffer.get() != nullptr;

	auto val = m_units.insert( value_type(inputunit, buffer  ));
	ok = ok && val.second;
	ok = ok && buffer->StartReadBack();
	return ok;
}

/*-----------------------------------------------------------------------------
 *					FortranUnitsArray::Buffer		 2018- 11- 25*/
/** **/
/*---------------------------------------------------------------------------*/

std::shared_ptr<FortranUnitBuffer> FortranUnitsArray::Buffer( int unit, bool autoinsert )
{
	auto iter = m_units.find( unit );
	bool ok   = true;
	std::shared_ptr<FortranUnitBuffer>	buffer;

	ok = (iter != m_units.end());
	if (!ok && autoinsert)
	{
		auto val = m_units.insert( value_type(unit, std::shared_ptr<FortranUnitBuffer>( new FortranUnitBuffer)  ));
		iter = val.first;
		ok   = val.second;
	}
	if (ok) buffer = (iter->second);
	if (!ok)
	{
		printf("FortranUnitsArray::Buffer, the requested unit (%d) does not exist\n", (int)unit);
		fflush(stdout);
	}
	return buffer;
}