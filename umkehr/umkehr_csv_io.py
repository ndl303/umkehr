from typing import List,Tuple
import woudc_umkcsv
import csv
from datetime import date,datetime
from io import StringIO

#------------------------------------------------------------------------------
#           woudc_CSV_input
#------------------------------------------------------------------------------

class  woudc_CSV_input:
    """
    Reads in a WOUDC extended CSV file. You can use method fetch_section to quickly get
    the header as a dictionary and an array of data fields.
    """

    #------------------------------------------------------------------------------
    #           __init__
    #------------------------------------------------------------------------------

    def __init__(self, filename = None):

        self.input_ecsv    : woudc_umkcsv.Reader = None           #: the extended csv reader  that reads in a file
        self.inputfilename : str                 = None           #: The name of the file read in

        if (filename is not None):
            self.load(filename)

    #------------------------------------------------------------------------------
    #           load
    #------------------------------------------------------------------------------

    def load(self, filename):

        self.input_ecsv     = woudc_umkcsv.load(filename)
        self.inputfilename  = filename


    #------------------------------------------------------------------------------
    #           fetch_N14Record
    #------------------------------------------------------------------------------

    def fetch_section(self, sectionname:str):

        alldata = []
        section = self.input_ecsv.sections[sectionname]['_raw']
        recordio = StringIO(section)
        rows     = csv.reader(recordio)
        iterator = iter(rows)
        header   = next(iterator)
        if sectionname == "TIMESTAMP2": sectionname="TIMESTAMP"     # sometimes the header record is still the section name. We need to jolt it fowards one record.
        if (len(header)==1) and (sectionname == header[0]):
            header = next(iterator)

        headerdict = {}
        for i in range(len(header)):
            headerdict[ header[i].upper() ] = i

        while True:
            try:
                data = next(iterator)
            except StopIteration:
                break  # Iterator exhausted: stop the loop
            else:
                alldata.append( data)
        return headerdict,alldata

#------------------------------------------------------------------------------
#           read_level1_umkehr_fortran_lines_from_csv
#------------------------------------------------------------------------------

def read_level1_umkehr_fortran_lines_from_csv( filename: str )->Tuple[ List[str], woudc_CSV_input] :
    """
    Reads in a WOUDC Umkehr Level 1 and encodes the N14 data in the format used by the Fortran processing.
    It returns both the list of fortran lines to be sent to the Fortran code and the Umkehr CSV reader object
    as this will be used when creating the Level 2 CSV file.

    Parameters
    ----------

    filename
        The full name of the CSV Umkehr Level 1 file.

    Returns
    -------

    A tuple. The first element is the list of lines to be sent to the Fortran code. The second element is the Umkehr
    CSV reader object for the Level 1 file. This object willbe used when writing Level 2 records to CSV.
    """

    oldlines = []

    N14 =  woudc_CSV_input( filename = filename)
#    conthdr, contdata     = N14.fetch_section("CONTENT")
#    dgenhdr,dgendata      = N14.fetch_section("DATA_GENERATION")
    plathdr, platdata     = N14.fetch_section("PLATFORM")
    insthdr, instdata     = N14.fetch_section("INSTRUMENT")
    lochdr,  locdata      = N14.fetch_section("LOCATION" )
    hdr, data             = N14.fetch_section("N14_VALUES")

#    tstmphdr, tstmpdata   = N14.fetch_section("TIMESTAMP")

    if  (instdata[0][ insthdr["NAME"]]).upper() == "DOBSON":
        IC = 4 if (instdata[0][ insthdr["MODEL"]]).upper() == "JAPANESE" else 3
    else:
        IC = -1
    ISTN = int( platdata[0][ plathdr["ID"]] )
    III  = int( instdata[0][ insthdr["NUMBER"]])
    if (III >4999) and (III < 6000):        # Japanese models have instruments between 5000 and 5999
        if (IC != 4):
            print("Instrument model number ",III, " is invalid for instrument ",instdata[0][ insthdr["NAME"]],",", instdata[0][ insthdr["MODEL"]])
        III = III - 5000

    if hdr.get("L") is None: hdr["L"] = hdr["W"]     # Patch up some of the bugs. Some files have W instead of L. Seems like W got renamed to L at some point.
    for rec in data:
        today    = datetime.strptime(rec[ hdr["DATE"] ],"%Y-%m-%d" )
        H        = int( rec[ hdr["H"] ] )
        W        = int( rec[ hdr["L"] ] )           # The old records call this field W. The WOUDC CSV calls this L
        L        = int( rec[ hdr["WLCODE"] ] )      # The old records call this L but the WOUDC CSV call this WLCode
        S        = int( rec[ hdr["OBSCODE"] ] )
        ColumnO3 = int( rec[ hdr["COLUMNO3"] ] )
        N600     = int( rec[ hdr["N_600"] ] )
        N650     = int( rec[ hdr["N_650"] ] )
        N700     = int( rec[ hdr["N_700"] ] )
        N740     = int( rec[ hdr["N_740"] ] )
        N750     = int( rec[ hdr["N_750"] ] )
        N770     = int( rec[ hdr["N_770"] ] )
        N800     = int( rec[ hdr["N_800"] ] )
        N830     = int( rec[ hdr["N_830"] ] )
        N840     = int( rec[ hdr["N_840"] ] )
        N850     = int( rec[ hdr["N_850"] ] )
        N865     = int( rec[ hdr["N_865"] ] )
        N880     = int( rec[ hdr["N_880"] ] )
        N890     = int( rec[ hdr["N_890"] ] )
        N900     = int( rec[ hdr["N_900"] ] )

        oldform ="{:02}{:03} {:02}{:02}{:02} {:1}{:1}{:1}{:1}{:3}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}{:4}".format(
                   IC,III,today.day,today.month, today.year%100, H, W,L,S,ColumnO3,
                   N600,N650,N700,N740,N750,N770,N800,N830,N840,N850,N865,N880,N890,N900,ISTN)
        oldlines.append(oldform)
    return oldlines, N14

#------------------------------------------------------------------------------
#           def _appendfields( fieldlist ):
#------------------------------------------------------------------------------

def _appendfields(fieldlist):

    line = None
    for entry in fieldlist:
        if ( line is None) : line = entry
        else:                line += ','+entry
    return line

#------------------------------------------------------------------------------
#           decode_output_line
#------------------------------------------------------------------------------

def write_level2_umkehr_fortran_lines_to_csv( outputfilename: str , outputlines:List[str],  N14: woudc_CSV_input,covariancetype:str ):
    """
    Writes the array of Fortran lines output from the UMKEHR fortran to a WOUDC Umkehr Level 2 file

    Parameters
    ----------
    outputlines
        The array of lines output by the Fortran code.
    outputfilename
        The output filename. This should  be in accordance with WOUDC filenaming piolicy
    N14
        The CSV reader holding the corresponding Level 1 CSV data file info. THis is used to create
        meta data fields in the Level 2 CSV file
    :return:
    """

    extcsv = woudc_umkcsv.Writer(template=True)
    extcsv.add_comment('This file was generated by NOAA UMKEHR processing software.')
    extcsv.add_comment('\'na\' is used where Instrument Model or Number are not available.')

    conthdr, contdata     = N14.fetch_section("CONTENT")
    dgenhdr, dgendata     = N14.fetch_section("DATA_GENERATION")
    plathdr, platdata     = N14.fetch_section("PLATFORM")
    insthdr, instdata     = N14.fetch_section("INSTRUMENT")
    lochdr,  locdata      = N14.fetch_section("LOCATION" )
    timhdr,  timedata     = N14.fetch_section("TIMESTAMP")
    try:
        tim2hdr, tim2data     = N14.fetch_section("TIMESTAMP2")     # The second timestamp is not always available
    except:
        tim2data = None

    observationdate = datetime.strptime(timedata[0][1],"%Y-%m-%d")

    extcsv.add_data('CONTENT', 'WOUDC,UmkehrN14,2.0,1')
    extcsv.add_data('DATA_GENERATION', _appendfields(dgendata[0]))
    extcsv.add_data('PLATFORM',        _appendfields(platdata[0]))
    extcsv.add_data('INSTRUMENT',      _appendfields(instdata[0]))
    extcsv.add_data('LOCATION',        _appendfields(locdata [0]))
    extcsv.add_data('TIMESTAMP',       _appendfields(timedata[0]))
    firsttime = True

    for outputline in outputlines:                              # Decode the FOrtran output line. This is very format sensitive!
        day      = int( outputline[ 0:3 ] )
        month    = int( outputline[ 3:6 ] )
        year     = int( outputline[ 6:9 ] )
        H        = int( outputline[ 10:11 ] )
        W        = int( outputline[ 11:13 ])
        OMOBS    = int( outputline[ 13:18 ] )
        OMSOL    = int( outputline[ 18:24 ] )/10.0
        LO3_10   = int( outputline[ 24:30 ] )/100.0
        LO3_09   = int( outputline[ 30:36 ] )/100.0
        LO3_08   = int( outputline[ 36:42 ] )/100.0
        LO3_07   = int( outputline[ 42:48 ] )/100.0
        LO3_06   = int( outputline[ 48:54 ] )/100.0
        LO3_05   = int( outputline[ 54:60 ] )/100.0
        LO3_04   = int( outputline[ 60:66 ] )/100.0
        LO3_03   = int( outputline[ 66:72 ] )/100.0
        LO3_02   = int( outputline[ 72:78 ] )/100.0
        LO3_01   = int( outputline[ 78:84 ] )/100.0

        ITER     = int( outputline[ 84:86 ] )
        KB       = int( outputline[ 86:88 ] )
        KE       = int( outputline[ 88:91 ] )
        try:
            DFRMS    = int( outputline[ 91:95 ] )/1000.0        # We sometimes get **** instead of a number
        except:
            DFRMS    = 9.999

        try:
            FEPS     = int( outputline[ 95:99 ] )/100.0         # We sometimes get **** instead of a number
        except:
            FEPS     = 99.99

        try:
            RMSRES   = int( outputline[ 99:104 ] )/100.0        # We sometimes get ***** instead of a number
        except:
            RMSRES   = 999.99

        ISN      = int( outputline[ 104: ]   )

        NZA         = KE
        line        = "{:4}-{:02}-{:02},{:1},{:1},{:3},{:.2f},{:.2f},{:.2f},{:.2f},{:.2f},{:.2f},{:.2f},{:.2f},{:.2f},{:.2f},{:.2f},{:1},{},{:1},{:2},{:.4f},{:.3f},{:.3f}".format(
                        observationdate.year,month,day,H,W,OMOBS,OMSOL, LO3_10,LO3_09,LO3_08,LO3_07,LO3_06,LO3_05,LO3_04,LO3_03,LO3_02,LO3_01,ITER,covariancetype,KB,NZA,DFRMS,FEPS,RMSRES)
        fieldheader = "Date,H,L,ColumnO3Obs,ColumnO3Retr,Layer10,Layer9,Layer8,Layer7,Layer6,Layer5,Layer4,Layer3,Layer2,Layer1,ITER,SX,SZA_1,nSZA,DFMRS,FEPS,RMSRES"

        extcsv.add_data('C_PROFILE', line,  field= fieldheader if firsttime else None)
        firsttime=False

    if ( tim2data is not None):
        extcsv.add_data('TIMESTAMP', _appendfields(tim2data[0]), field='UTCOffset,Date,Time', index=2)
    woudc_umkcsv.dump(extcsv, outputfilename)


if __name__ == "__main__":
    lines,N14 = convert_N14_CSV_to_80column('20091101.Dobson.Beck.119.JMA.csv')
    outputlines = ["  6 11  9 1 3  276  2742   121   247   784  2010  4126  5913  5341  3582  2804  2491 2 3 10   5  11   34 101"]
    write_level2_umkehr_fortran_lines_to_csv( outputlines, 'testlevel2.csv', N14 )
    print("Finished")
