#include "umkehr_if.h"



/*-----------------------------------------------------------------------------
 *					FortranUnitsArray::Write		 2018- 11- 24*/
/** **/
/*---------------------------------------------------------------------------*/

bool FortranUnitsArray::Write( int unit, const std::string& str)
{
	auto iter = m_units.find( unit );
	bool ok   = true;

	ok = (iter != m_units.end());
	if (!ok)
	{
		auto val = m_units.insert( value_type(unit, FortranUnitBuffer()  ));
		iter = val.first;
		ok   = val.second;
	}
	ok = ok && iter->second.AddLine(str);
	return ok;
}
