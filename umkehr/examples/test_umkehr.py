import os.path
import os
from ..process import Level1_to_Level2

def test_Level1_to_Level2():
    dirname = os.path.dirname(__file__)
    inputfile  = dirname + os.sep + '20091101.Dobson.Beck.119.JMA.csv'
    outputfile = '20091101.Dobson.Beck.119.JMA.Level2.csv'

    Level1_to_Level2(inputfile,outputfile, KBN=3, verbose = True)
