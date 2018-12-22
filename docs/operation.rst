..  _operation:

umkehr: High Level Interface
============================
The high level interface provides an easy-to-use interface to the Umkehr algorithm. Its primary function is
to process WOUDC Level 1 CSV files to WOUDC Level 2 CSV files.

    - :func:`.Level1_to_Level2`
    - :func:`.change_crosssection_coef_bch`
    - :func:`.change_crosssection_coef_bcl`
    - :func:`.change_apriori_fstguess`
    - :func:`.change_umkehr_configuration_file`


Basic Example
-------------
Here is an example that shows how to use the umkehr high level interface::

    import os.path
    import os
    from umkehr.process import Level1_to_Level2

    inputdir   = "/my/user_defined/csv/level1/directory"
    outputdir  = "/my/user_defined/csv/level2/directory"
    inputfile  = inputdir  + os.sep + '20091101.Dobson.Beck.119.JMA.csv'
    outputfile = outputdir + os.sep + '20091101.Dobson.Beck.119.JMA.Level2.csv'

    Level1_to_Level2(inputfile,outputfile, KBN=3, verbose = True)

and here is a second, more complex, example that processes a selection of files. This script has been used to process
over 10,000 WOUDC Level 1 CSV files stored in one folder::

    import os
    import os.path
    import glob
    import umkehr.process


    def process_umkehr( filespec : str):

        files = glob.glob( filespec )
        nfiles = len(files)
        numbad = 0
        print("Processing ", nfiles, " files")
        for level1inputfilename in files:
            basename,ext = os.path.splitext(level1inputfilename )
            dirname,name = os.path.split( basename )
            outputname = dirname + os.sep + 'Level2'
            os.path.normpath(outputname)
            try:
                os.mkdir( outputname)
            except:
                pass
            outputname += os.sep + name + '.Level2' + ext
            if not os.path.exists(outputname):
                try:
                    umkehr.process.Level1_to_Level2(level1inputfilename, outputname, KBN=3, verbose=True )
                except Exception as err:
                    numbad = numbad + 1
                    print("Error processing <",level1inputfilename,"> Error =",err)
        print("Files processed = ", nfiles)
        print("num bad    = ", numbad)

    process_umkehr( r'E:\woudc\level1\*.csv')

Changing Input Files
--------------------
The high level interface provides a few methods to change the input files used by the Fortran code. It is possible with
:func:`.change_umkehr_configuration_file` to change any of the input files used by the Fortran code while another 3 methods
allow for explicit changes to 3 specific files.

See :ref:`umkehr_inputs` for a list and description of files used by the Fortran code. It is only possible to change files
that are input to the Fortran and are not read from Python buffers. Users are entirley responsible for ensuring that the
replacement file is compatible with the underlying Fortran code. A simple test is to check against the original
Fortran code: if it works with the original Fortran code it should work with the Python interface.

..  warning::

    Note that changing the input files should be performed before calling :func:`.Level1_to_Level2`. It is not possible
    to guarantee that changes to input files after the first call will have any effect what-so-ever as the underlying Fortran code
    initializes and caches many of its internal variables on the first call and only the first call.

Functions
----------

.. module::`umkehr.process`

.. function:: change_crosssection_coef_bch(fullfilename: str)

    Changes the file used for the Bass-Paur cross-sections file `coef_dobch.dat`. It must have the same format
    as the default version of `coef_dobch.dat`. This is an expert mode.

    :param str fullfilename: The full path name of the new configuration file.

.. function:: change_crosssection_coef_bcl( fullfilename: str )

    Changes the file used for the Bass-Paur cross-sections file `coef_dobcl.dat`. It must have the same format
    as the default version of `coef_dobcl.dat`. This is an expert mode.

    :param str fullfilename: The full path name of the new configuration file.

.. function:: change_apriori_fstguess( fullfilename : str )

    Changes the file used for UMKEHR apriori. It must have the same format
    as the default apriori file, `fstguess.99b`. This is an expert mode.

    :param str fullfilename: The full path name of the new configuration file.

.. function:: change_umkehr_configuration_file( fortranunit : int, fullfilename : str)

    Changes the file used for any of the UMKEHR input configuration files. This
    assumes you know what you are doing as you must know the internal formats
    used by the Fortran code etc.

    :param int fortranunit: The fortran unit used for the configuration file in the original `umkv8.f` fortran code
    :param str fullfilename: The full path name of the new configuration file.

..  function:: Level1_to_Level2(  level1inputfilename : str, level2outputfilename : str, KBN=3, verbose=True)

    Processes an Umkehr Level 1 file and writes the output to a Level 2 file.

    :param str level1inputfilename:
        The fullname of the level 1 umkehr input file. If the file extension is '.csv' then file is assumed to be
        a WOUDC extended CSV file. Otherwise it is assumed to be an original 80 column format Level 1 file.
    :param str level2outputfilename:
        The fullname of the Level 2 umkehr outpout file. If the file extension is '.csv' then file will be
        written as a WOUDC extended CSV file. Otherwise it is written in the same format as the original umkv8.f program.
    :param int KBN:
        The index of the lowest solar zenith angle. This is the same number as entered when prompted by the original umkv8.f program.
        The default value is 3.
    :param bool verbose:
        If True then print messages will processing the Umkehr data files. Default is True
