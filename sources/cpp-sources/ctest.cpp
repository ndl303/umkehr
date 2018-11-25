

#include "umkehr_if.h"
#include "umkehr_pythonif.h"

/*-----------------------------------------------------------------------------
 *					main		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

int main()
{
	int KBN       = 3;

	const char* inputfolder    = "./data/";
	const char* inputfilename  = "./testdata/umknov09.jpn";
//	const char* outputfilename = "./testdata/umknov09_syowa.txt";

	set_umkehr_inputfolder( inputfolder );
	analyze_umkehr        ( inputfilename, KBN);
	printf("UNIT 4 output stream\n");
	get_output_stream     (4);
	printf("UNIT 10 input stream\n");
	get_input_stream      (10);
}

