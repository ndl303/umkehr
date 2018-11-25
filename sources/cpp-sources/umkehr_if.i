/* File :umkehr.i */
%module umkehr_if

%{
#define SWIG_FILE_WITH_INIT
#include <string>
#include <list>
#include "umkehr_pythonif.h"
%}

%include "std_string.i"
%include "std_list.i"
%template(StringList) std::list<std::string>;

%include "umkehr_pythonif.h"
