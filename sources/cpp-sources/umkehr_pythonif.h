
bool set_umkehr_inputfolder( const char* inputfolder);
const std::list<std::string>& get_output_stream( int unit);
const std::list<std::string>& get_input_stream ( int unit);
void set_umkehr_input_filename( int unit, const char*  fullname );
bool analyze_umkehr( const char* inputfilename, int KBN  );
