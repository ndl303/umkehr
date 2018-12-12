import os
#import versioneer
from setuptools import setup
from setuptools import find_packages
from setuptools.dist import Distribution
from distutils.core import Extension


extension_module = Extension(
     name              = 'umkehr_if._umkehr_if',
     sources           =['sources/cpp-sources/umkehr_if_wrap.cxx'],
     include_dirs      =['/usr/include'],
     library_dirs      =['./'],
     libraries         =['umkehr_codelib', 'gfortran'],
     extra_compile_args=['-std=c++11', '-fvisibility=hidden','-fPIC'],
     extra_link_args   =[]
)

setup(
    name                 = 'umkehr',
    version              = "0.4.0",
#   version=versioneer.get_version(),
#   cmdclass=versioneer.get_cmdclass(),
    description          = 'UMKEHR Fortran Interface Library',
    license              = 'MIT',
    author               = 'Nick Lloyd',
    author_email         = 'nicklloyd5577@gmail.com',
    packages             = find_packages(),
    package_data         = {'umkehr_if': [ 
                                           'data/coef_dobch.dat', 
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
                             'umkehr': ['examples/20091101.Dobson.Beck.119.JMA.csv']
                           },
    install_requires     = [],
    ext_modules          = [extension_module],
    include_package_data = True,
    classifiers          = ['Development Status :: 4 - Beta',                   # How mature is this project? Common values are
                                                                                #   3 - Alpha
                                                                                #   4 - Beta
                                                                                #   5 - Production/Stable
                            'Intended Audience :: Developers',                  # Indicate who your project is intended for
                            'Topic :: Software Development',  
                            'Operating System :: POSIX :: Linux',
                            'License :: OSI Approved :: MIT License',           # Pick your license as you wish (should match "license" above)
                            'Programming Language :: Python :: 3',              # Specify the Python versions you support here. In particular, ensure
                           ]
)
