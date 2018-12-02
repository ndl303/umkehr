from typing import List,Tuple,Any
import os.path
import umkehr_if.umkehr_if as umkfortran
from .umkehr_csv_io import read_level1_umkehr_fortran_lines_from_csv, write_level2_umkehr_fortran_lines_to_csv

#------------------------------------------------------------------------------
#           _is_csv_file
#------------------------------------------------------------------------------

def _is_csv_file( inputfile : str ):
    """
    Returns True if the file extension is ".csv". Case insensitive.
    """
    name,ext = os.path.splitext( inputfile)
    iscsv = (ext.lower() == '.csv')
    return iscsv

#------------------------------------------------------------------------------
#           _read_lines_from_input_file
#------------------------------------------------------------------------------

def _read_lines_from_input_file( inputfilename : str) ->Tuple[ List[str], Any]:

    if _is_csv_file(inputfilename):
        lines,N14 = read_level1_umkehr_fortran_lines_from_csv(inputfilename)
    else:
        N14 = None
        with open(inputfilename,'rt') as f:
            lines = f.readlines()
    return lines,N14

#------------------------------------------------------------------------------
#           _read_lines_from_input_file
#------------------------------------------------------------------------------

def _write_lines_to_output_file( outputfilename : str, lines: List[str], N14: Any):

    ok = False
    if _is_csv_file(outputfilename):
        ok = N14 is not None
        if ok:
            write_level2_umkehr_fortran_lines_to_csv( outputfilename, lines, N14 )
        else:
            print('Umkehr. Cannot write level 2 records to a CSV file without a valid Level 1 CSV object. ')
    else:
        with open(outputfilename,'wt') as f:
            f.writelines(lines)
    return lines,N14

#------------------------------------------------------------------------------
#           change_crosssection_bch
#------------------------------------------------------------------------------

def change_crosssection_coef_bch( fullfilename ):
    """
    Changes the file used for the Bass-Paur cross-sections file coef_dobch.dat. It must have the same format
    as the default coef_dobch.dat. This change will stay in effect until called again.
    This is an expert mode.

    Parameters
    ----------
    fullfilename
        The full path name of the new configuration file.
    """

    umkfortran.set_umkehr_input_filename( 97, fullfilename )

#------------------------------------------------------------------------------
#           change_crosssection_bcl
#------------------------------------------------------------------------------

def change_crosssection_coef_bcl( fullfilename ):
    """
    Changes the file used for the Bass-Paur cross-sections file coef_dobcl.dat. It must have the same format
    as the default coef_dobcl.dat. This change will stay in effect until called again.
    This is an expert mode.

    Parameters
    ----------
    fullfilename
        The full path name of the new configuration file.
    """

    umkfortran.set_umkehr_input_filename( 98, fullfilename )

#------------------------------------------------------------------------------
#           change_apriori_fstguess
#------------------------------------------------------------------------------

def change_apriori_fstguess( fullfilename ):
    """
    Changes the file used for UMKEHR apriori. It must have the same format
    as the default apriori, fstguess.99b This change will stay in effect until called again.
    This is an expert mode.

    Parameters
    ----------
    fullfilename
        The full path name of the new configuration file.
    """
    umkfortran.set_umkehr_input_filename( 9, fullfilename )

#------------------------------------------------------------------------------
#           change_umkehr_configuration_file
#------------------------------------------------------------------------------

def change_umkehr_configuration_file( fortranunit : int, fullfilename : str):
    """
    Changes the file used for any of the UMKEHR input configuration files. This
    assumes you know what you are doing as you must know the internal formats
    used bythe Fortran code etc. This change will stay in effect until called again

    Parameters
    ----------
    fortranunit
        The fortran unit used for the configuration file in the original umkv8.f fortran code
    fullfilename
        The full path name of the new configuration file.
    """
    umkfortran.set_umkehr_input_filename( fortranunit, fullfilename )

#------------------------------------------------------------------------------
#           Level1_to_Level2
#------------------------------------------------------------------------------

def Level1_to_Level2(  level1inputfilename : str, level2outputfilename : str, KBN=3, verbose=True):
    """
    Processes an Umkehr Level 1 file and writes the output to a Level 2 file.

    Parameters
    ----------
    level1inputfilename
        The fullname of the level 1 umkehr input file. If the file extension is '.csv' then file is assumed to be
        a WOUDC extended CSV file. Otherwise it is assumed to be an original 80 column format Level 1 file.
    level2outputfilename
        The fullname of the Level 2 umkehr outpout file. If the file extension is '.csv' then file will be
        written as a WOUDC extended CSV file. Otherwise it is written in the same format as the original umkv8.f program.
    KBN
       The index of the lowest solar zenith angle. This is the same number as entered when prompted by the original umkv8.f program.
       The defaulkt is 3.
    verbose
        If True then print messages will processing the Umkehr data files. Default is True
    """


    lines,N14  =  _read_lines_from_input_file( level1inputfilename )              # Fetch the data lines from the

    if (verbose): print('Read in {} lines from Umkehr Level 1 file {}'.format(len(lines), level1inputfilename) )

    umkfortran.clear_io_buffers()                                           # Clear the internal fortran/C++ internal buffers
    for l in lines:                                                         # Write the Level 1 lines to the inut buffer. This emulates Fortran Unit 12
        al = l.strip()
        if verbose: print(al)
        umkfortran.write_to_input_buffer(12,al)

    if verbose: print('Analyzing data with the UMKEHR algorithm.')

    umkfortran.analyze_umkehr( KBN)                                         # Do the UMKEHR analysis.

    L4 = umkfortran.get_output_stream(4)                                    # Get the output stream from output stream emulating Fortran UNit 4
    if verbose:
        print("Level 2 Fortran Output Records")
        for l in L4: print(l)

    if (verbose): print('Writing {} lines to Umkehr Level 2 file {}'.format(len(L4), level2outputfilename))
    _write_lines_to_output_file( level2outputfilename, L4, N14)                   # Write the Level 2 records to the Umkehr Level 2 file.




