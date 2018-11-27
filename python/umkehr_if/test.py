import umkehr_if as umk

def dotest():
    KBN       = 3
    inputfolder    = "./data/"
    inputfilename  = "./testdata/umknov09.jpn"
    umk.set_umkehr_inputfolder( inputfolder );
    umk.analyze_umkehr        ( inputfilename, KBN);
    l4 = umk.get_output_stream(4);
    l10 = umk.get_input_stream(10);
    return (l4,l10)
   
