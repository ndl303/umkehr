

#include "umkehr_if.h"
#include "umkehr_pythonif.h"

/*-----------------------------------------------------------------------------
 *					main		 2018- 11- 12*/
/** **/
/*---------------------------------------------------------------------------*/

int main()
{
	int KBN       = 3;

	const char* inputfolder    = "./umkehr_if/data/";
	const char* inputfilename  = "./umkehr_if/testdata/umknov09.jpn";
//	const char* outputfilename = "./testdata/umknov09_syowa.txt";
	char		aline[200];
	bool		ok;
	FILE*		f;
	
	clear_io_buffers();
	
	f = fopen( inputfilename, "rt");
	do
	{
		ok = fgets( aline, 199, f) != NULL;
		if (ok) 
		{
			printf("%s",aline);
			write_to_input_buffer (12, aline);
		}
	}
	while (ok);
	printf("\n");
	fclose(f);

	set_umkehr_inputfolder( inputfolder );
	analyze_umkehr        ( KBN);

	printf("UNIT 4 output stream\n");
	const std::list<std::string>& profiletext =  get_output_stream     (4);
	for (auto iter = profiletext.begin(); iter != profiletext.end(); iter++)
	{
		printf("%s\n", (const char*)iter->c_str());
	}
	printf("UNIT 10 input stream\n");
	const std::list<std::string>& inputtext =  get_output_stream     (10);
	for (auto iter = inputtext.begin(); iter != inputtext.end(); iter++)
	{
		printf("%s\n", (const char*)iter->c_str());
	}

}

