import umkehr.process

inputfile  = '20091101.Dobson.Beck.119.JMA.csv'
outputfile = '20091101.Dobson.Beck.119.JMA.Level2.csv'

umkehr.process.Level1_to_Level2(inputfile,outputfile, KBN=3, verbose = True)
