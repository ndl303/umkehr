import os.path
import os
from .umkehr_if import set_umkehr_inputfolder

inputfolder,name = os.path.split( __file__)
datafolder = inputfolder + os.sep+'data'+os.sep
set_umkehr_inputfolder( datafolder )



