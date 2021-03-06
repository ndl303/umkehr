import os
import sys
#import versioneer
from setuptools import setup
from setuptools import find_packages
from setuptools.dist import Distribution
from distutils.core import Extension

package_data         = {'umkehr_if': [   'data/coef_dobch.dat', 
                                         'data/coef_dobcl.dat',
                                         'data/decodev4.inp',
                                         'data/fstguess.99b',
                                         'data/mk2v4cum.inp',
                                         'data/nrl.dat',
                                         'data/phprofil.dat',
                                         'data/refractn.dat',
                                         'data/stdjacmsc.dat',
                                         'data/stdmscdobc_depol_top5.dat',
                                         'data/std_pfl.asc',
                                         'data/stnindex.dat',
                                         'data/totoz_press.dat'],
                         'woudc_umkcsv': ['table_configuration.csv'],
                         'umkehr'      : ['examples/20091101.Dobson.Beck.119.JMA.csv']
                        }


if sys.platform =='win32':
     data_files = [ ('',['pgi_redistributables/pgf90rtl.dll',
                         'pgi_redistributables/pgf90.dll',
                         'pgi_redistributables/pgf902.dll',
                         'pgi_redistributables/pgftnrtl.dll',
                         'pgi_redistributables/pgc14.dll',
                         'pgi_redistributables/pgmath.dll',
                         'pgi_redistributables/pgc.dll',
                         'pgi_redistributables/pgmisc.dll',
                         'pgi_redistributables/pgf90_rpm1.dll'  ])]
#     package_data['umkehr_if'].append( 'pgf90rtl.dll')
#     package_data['umkehr_if'].append( 'pgf90.dll')
#     package_data['umkehr_if'].append( 'pgf902.dll')
#     package_data['umkehr_if'].append( 'pgftnrtl.dll')
#     package_data['umkehr_if'].append( 'pgc14.dll')
#     package_data['umkehr_if'].append( 'pgmath.dll' )
#     package_data['umkehr_if'].append( 'pgc.dll' )
#     package_data['umkehr_if'].append( 'pgmisc.dll' )
#     package_data['umkehr_if'].append( 'pgf90_rpm1.dll')
     include_dirs      =[]
     library_dirs      =['.\\', r'C:\Program Files\PGI\win64\18.10\lib']
     libraries         =['umkehr_codelib', 'pgf90rtl', 'pgf90', 'pgftnrtl', 'pgc14', 'pgmath']
     extra_compile_args=[]
else:
     include_dirs      =['/usr/include']
     library_dirs      =['./']
     libraries         =['umkehr_codelib', 'gfortran']
     extra_compile_args=['-std=c++11', '-fvisibility=hidden','-fPIC']
     data_files        =[]


extension_module = Extension(
     name              = 'umkehr_if._umkehr_if',
     sources           =['sources/cpp-sources/umkehr_if_wrap.cxx', 'sources/cpp-sources/umkehr_if.cpp', 'sources/cpp-sources/umkehr_io.cpp'],
     include_dirs      =include_dirs,
     library_dirs      =library_dirs,
     libraries         =libraries,
     extra_compile_args=extra_compile_args,
     extra_link_args   =[]
)

setup(
    name                 = 'umkehr',
    version              = "0.6.0",
#   version=versioneer.get_version(),
#   cmdclass=versioneer.get_cmdclass(),
    description          = 'UMKEHR Fortran Interface Library',
    license              = 'MIT',
    author               = 'Nick Lloyd',
    author_email         = 'nicklloyd5577@gmail.com',
    packages             = find_packages(),
    package_data         = package_data,
    data_files           = data_files,
    install_requires     = ['typing'],
    ext_modules          = [extension_module],
    include_package_data = True
)

