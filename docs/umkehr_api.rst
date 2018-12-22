..  _umkehr_api:

umkehr_if: Low Level Interface
===============================
The low level API is called by the High Level API. It is expected that most users will not need to use the Low Level Interface.
The interafce does provide access to output and input streams that may be useful for diagnbostic work. It also allows users
to change the location of the Fortran input files.

    - clear_io_buffers
    - write_to_input_buffer
    - set_umkehr_inputfolder
    - :func:`.get_output_stream`
    - :func:`.get_input_stream`
    - :func:`.set_umkehr_input_filename`


.. function:: umkehr_if.umkehr_if.clear_io_buffers()

    Internal use only: Clears all of the internal buffers used by Python.

.. function:: umkehr_if.umkehr_if.write_to_input_buffer (unit : int , line: str);

    Advanced usage only. Writes a string to the the internal fortran unit cache. May
    be useful if the FORTRAN input file format changes.

    :param init unit: the fortran I/O unit
    :param str line: the line of text to write

..  function:: umkehr_if.umkehr_if.set_umkehr_inputfolder( inputfolder: str )->bool:

    Advaced usage only. Sets the input folder for the default input files. This is set by the module to point to the
    installed package location. It can be overridden by the user if you wish to change the directory location of the default input files.

    :param str inputfolder:
        The full name of the new inpout folder. This folder must be terminated by a directory separator. Note that
        this folder is not used for input files that have been set by a call to :func:`.set_umkehr_input_filename`.

..  function:: umkehr_if.umkehr_if.get_output_stream( int unit) ->List[str]

    General use. This provides a method to retrieve the output written by the Fortran code to any of the output units.
    All valid Fortran output units are listed in :ref:`umkehr_inputs`. The method returns a list of strings that
    represent the output from the last call to analyze_umkeher or :func:`.Level1_to_Level2`

    :param str inputfolder: The full name of the new input folder

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

.. function:: umkehr_if.umkehr_if.get_input_stream( unit: int) ->List[str]

    General use. This provides a method to retrieve input streams to the Fortran code from Python. May be useful for
    diagnostic work to ensure that inputs to the Fortran were as expected. The method returns a list of strings that
    represent the input streams to the Fortran call generated during the last call to analyze_umkeher or
    :func:`.Level1_to_Level2`.  Usage of the function is similar to usage of :func:`.get_output_stream`.

    :param int unit: the unit number of the Fortran input stream.


..  function:: umkehr_if.umkehr_if.set_umkehr_input_filename(  unit: int, fullname:str )

    Allows users to set the full pathname of any specific input files used by Fortran. Its use is identical to
    :func:`.change_umkehr_configuration_file`

    :param int unit: The fortran input unit number.
    :param str fullname: The full filename to be used for inpout on this Fortran unit.

..  function:: umkehr_if.umkehr_if.analyze_umkehr( KBN : int )->bool

    Internal usage only: Invokes the UMKEHR algorihm. It is called by :func:`.Level1_to_Level2`




