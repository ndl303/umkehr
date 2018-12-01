import umkehr_if.umkehr_if as umk

def dotest():
    KBN       = 3
    inputfolder    = "./umkehr_if/data/"
    inputfilename  = "./umkehr_if/testdata/umknov09.jpn"

    f = open(inputfilename,'rt')
    lines = f.readlines()
    f.close()

    umk.clear_io_buffers()
    for l in lines:
        al = l.strip()
        print(al)
        umk.write_to_input_buffer(12,al)
    umk.set_umkehr_inputfolder( inputfolder )

    print("Into UMKEHR")
    umk.analyze_umkehr( KBN)
    print("Out of UMKEHR")
    
    print("Data stream 10")
    l10 = umk.get_input_stream(10)
    for l in l10: print(l)
    
    l4 = umk.get_output_stream(4)
    print("Data stream 4");
    for l in l4: print(l)
    

dotest()

