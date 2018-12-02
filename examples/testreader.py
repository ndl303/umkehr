from typing import List,Tuple
from umkehr.umkehr_csv_io import read_level1_umkehr_fortran_lines_from_csv, write_level2_umkehr_fortran_lines_to_csv


lines,N14 = read_level1_umkehr_fortran_lines_from_csv('20091101.Dobson.Beck.119.JMA.csv')

outputlines = ["  6 11  9 1 3  276  2742   121   247   784  2010  4126  5913  5341  3582  2804  2491 2 3 10   5  11   34 101"]
write_level2_umkehr_fortran_lines_to_csv( outputlines, N14 )
print("Finished")
