# UMKEHR

Copyright 2018 NOAA

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial 
portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT 
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO 
EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.

This software contains third party run-time libraries in folder *pgi_redistributables*. You are strictly prohibited by the third party from further distribution of any files in this folder.

# Overview #
This is the UMKEHR retrieval code provided to the WOUDC in January 2019. It is a shallow python wrapper around Fortran code that executes the Umkehr ozone retrieval algorithm described in *Petropavlovskikh, I., Bhartia, P. K. and DeLuisi, J.*: [New Umkehr ozone profile retrieval algorithm optimized for climatological studies](https://doi.org/10.1029/2005GL023323 ), *JGR 2005*. 

This package can be installed as a binary Python wheel on most 64 bit Linux systems. The binary wheel used for installation can either be downloaded as a pre-built binary python wheel (64 bit Linux only, manylinux1 compatible) or can be built from the source code in this repository. The umkehr python package is not supported for python versions prior to 3.6 as we make extensive use of the *typing* features introduced in that version.

# Install The Python Wheel #

Most users will choose to install the python package on to their 64 bit Linux system using out pre-built ``manylinux`` version.  Wheels for Python 3.6 and 3.7 (Linux 64 bit only) can be installed using

    pip install umkehr -f https:\\arg.usask.ca\wheels

After the wheel is installed you are ready to go!  We recommend running the installation test outlined below.

If you want to build the wheel from source for your Linux box then you can perform the following steps:

    ./configure
    make

If the build is successful the you will see a big *whoo-hoo, the python wheel is built* scroll down your screen at the end of the last step.
The python wheel will be in sub-directory ./wheelhouse. A file listing, ``ls -al ./wheelhouse``, should reveal the wheel and it will look something like ``umkehr-0.4.0-cp37-cp37m-linux_x86_64.whl``. This wheel can be installed into your version of Python. More details on the build and its pre-requisites
can be found at the [documentation server](https://arg.usask.ca/docs/umkehr/)


# Test #


You can test your ``umkehr`` installation. A test example is installed as part of the python package::

    python
    >>> from umkehr.examples.test_umkehr import test_Level1_to_Level2
    >>> test_Level_to_Level2()

The test takes about 5 seconds and processes a month of data from SYOWA in November 2009. It reads the data in from a Level 1 CSV file
and writes out a Level 2 CSV file. 

# API Documentation #
The Umkehr API is documented at the [documentation server](https://arg.usask.ca/docs/umkehr/).


