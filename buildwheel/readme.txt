This directory is used to build the sasktranif python wheel.

The wheel is used to install the python implementation of the pratmo interface. 

Windows
The operating system dependent wheel is built by visual studio in a subdirectory, typically VS2015\x64\
then look in the dist folder for the wheel.
 
 The following code is executed by Visual Studio Post-Build Events for the python_Sasktranif in Release mode only.
 
echo Building Python wheel
copy..\..\..\buildwheel\setup.py              ..\..\..\buildwheel\$(VSXXXX)\$(PlatformName)\setup.py
copy..\..\..\buildwheel\*.bat                 ..\..\..\buildwheel\$(VSXXXX)\$(PlatformName)\*.bat
copy ..\..\..\modules\swig\sasktranif.py      ..\..\..\buildwheel\$(VSXXXX)\$(PlatformName)\sasktranif
copy ..\..\..\modules\swig\__init__.py        ..\..\..\buildwheel\$(VSXXXX)\$(PlatformName)\sasktranif
cd ..\..\..\buildwheel\$(VSXXXX)\$(PlatformName)
makewheel

The wheel is written to directory .\buildwheel\$(VSXXXX)\$(PlatformName)\dist\*.whl 

The wheel is appplicable to the version of python used on the development environment

The wheel can be isytalled with pip,
pip install <wheel filename>

