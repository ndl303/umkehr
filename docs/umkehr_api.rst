..  _umkehr_api:

umkehr_if API
=============

A description of API functions


void clear_io_buffers();
void write_to_input_buffer (int unit, const char* line);
bool set_umkehr_inputfolder( const char* inputfolder);
const std::list<std::string>& get_output_stream( int unit);
const std::list<std::string>& get_input_stream ( int unit);
void set_umkehr_input_filename( int unit, const char*  fullname );
bool analyze_umkehr( int KBN  );
