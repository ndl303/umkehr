
SET PYTHON_VERSION=%2
SET PRATMO_VERSION=%1

echo import os
echo from setuptools import setup
echo from setuptools import find_packages
echo from setuptools.dist import Distribution
echo from distutils.core import Extension
echo class BinaryDistribution(Distribution):
echo     def is_pure(self):
echo        return False
echo     def has_ext_modules(self):
echo         return True
echo setup(
echo     name                 = 'pratmo',
echo     version              = "%PRATMO_VERSION%",
echo     description          = 'Pratmo Box ModelInterface Library',
echo     license              = 'MIT',
echo     packages             = find_packages(),
echo     package_data         = {'pratmo': ['_pratmo.pyd', 'blaslapack.dll', 'wiscombemie_intel.dll', 'netlib.dll'],}, 
echo     data_files           = [('share/usask-arg/package_install', ['pratmo/pratmo.installcomponents'])], 
echo     install_requires     = ['sasktranif'],
echo     include_package_data = True,
echo     distclass            = BinaryDistribution,
echo     classifiers          = [
echo 				# How mature is this project? Common values are
echo 				#   3 - Alpha
echo 				#   4 - Beta
echo 				#   5 - Production/Stable
echo 				'Development Status :: 4 - Beta',  
echo 				# Indicate who your project is intended for
echo 				'Intended Audience :: Developers',
echo 				'Topic :: Software Development',  
echo 				'Operating System :: Microsoft :: Windows',
echo 				# Pick your license as you wish (should match "license" above)
echo 				 'License :: OSI Approved :: MIT License', 
echo 				# Specify the Python versions you support here. In particular, ensure
echo 				# that you indicate whether you support Python 2, Python 3 or both.
echo 				'Programming Language :: Python :: 3',
echo 				'Programming Language :: Python :: %PYTHON_VERSION%',
echo         		   ]
echo )
echo.

