..  _umkehr_api:

umkehr_if: Low Level Interface
===============================
The low level API is called by the High Level API. It is expected that most users will not need to use the Low Level Interface.
The interafce does provide access to output and input streams that may be useful for diagnbostic work. It also allows users
to change the location of the Fortran input files.

    - clear_io_buffers
    - write_to_input_buffer
    - set_umkehr_inputfolder
    - :ref:`get_output_stream`
    - :ref:`get_input_stream`
    - :ref:`set_umkehr_input_filename`




clear_io_buffers
----------------
Internal use only: Clears all of the internal buffers used by Python::

    def  umkehr_if.umkehr_if.clear_io_buffers()

write_to_input_buffer
---------------------
Advanced usage only. Writes a string to the the internal fortran unit cache. May be useful if the FORTRAN input file format changes::

    def  umkehr_if.umkehr_if.write_to_input_buffer (unit : int , line: str);

set_umkehr_inputfolder
----------------------
Advaced usage only. Sets the input folder for the default input files. This is set by the module to point to the installed package location.
It can be overridden by the user if you wish to change the directory location of the default input files. Note that
(i) this folder must be terminated by a directory separator and (ii) this folder is not used for input files that have
been set by a call to method set_umkehr_input_filename::

    set_umkehr_inputfolder( inputfolder: str )->bool:

..  _get_output_stream:

get_output_stream
-----------------
General use. This provides a method to retrieve the output written by the Fortran code to output units. All valid Fortran output units
are listed in :ref:`umkehr_inputs`. The method returns a list of strings that represent the output from the last call to
analyze_umkeher or :ref:`Level1_to_Level2`::

    def umkehr_if.umkehr_if.get_output_stream( int unit) ->List[str] :

Example
~~~~~~~
An example showing the usage of get_output_stream::


    >>> import umkehr_if
    >>> from umkehr.process import Level1_to_Level2
    >>>
    >>> inputfile  = '20091101.Dobson.Beck.119.JMA.csv'
    >>> outputfile = '20091101.Dobson.Beck.119.JMA.Level2.csv'
    >>> Level1_to_Level2(inputfile,outputfile, KBN=3, verbose = True)
    >>>
    >>> lines = umkehr_if.umkehr_if.get_output_stream(14)                       # Get the output lines for the Aveagring Kernel output stream, Fortran Unit 14
    >>> for l in lines:                                                         # For each line on output Unit 14
    >>> ... print(l)                                                            # print the line
    >>>
    ...

..  _get_input_stream:

get_input_stream
----------------
General use. This provides a method to retrieve input streams to the Fortran code from Python. May be useful for
diagnostic work to ensure that inputs to the Fortran were as expected. The method returns a list of strings that
represent the input streams to the Fortran call generated during the last call to analyze_umkeher or :ref:`Level1_to_Level2`::

    def umkehr_if.umkehr_if.get_input_stream( unit: int) ->List[str]

Usage of the function is similar to usage of :ref:`get_output_stream`.

..  _set_umkehr_input_filename:

set_umkehr_input_filename
-------------------------
Allows users to set the full pathname of any of the input files used by Fortran. Its use is identical to
:ref:`change_umkehr_configuration_file`::

    def  umkehr_if.umkehr_if.set_umkehr_input_filename(  unit: str, fullname:str );

analyze_umkehr
--------------
Internal usage only: Invokes the UMKEHR algorihm. It is called by :ref:`Level1_to_Level2`::

    def umkehr_if.umkehr_if.analyze_umkehr( KBN : int )->bool:


