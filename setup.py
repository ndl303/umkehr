import os
#import versioneer
from setuptools import setup
from setuptools import find_packages
from setuptools.dist import Distribution
from distutils.core import Extension

class BinaryDistribution(Distribution):
    def is_pure(self):
        return False

    def has_ext_modules(self):
        return True


setup(
    name                 = 'umkehr_if',
    version              = "0.1.0",
#   version=versioneer.get_version(),
#   cmdclass=versioneer.get_cmdclass(),
    description          = 'UMKEHR Fortran Interface Library',
    license              = 'MIT',
    author               = 'Nick Lloyd',
    author_email         = 'nicklloyd5577@gmail.coma',
    packages             = find_packages(),
    package_data         = {'umkehr_if': [ '_umkehr_if.pyd',
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
                                           'data/totoz_press.dat']
                           },
    install_requires     = [],
    include_package_data = True,
    distclass            = BinaryDistribution,
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

