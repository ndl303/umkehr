ECHO OFF
REM ----------------------------------------------------------------------------------------
REM 			Builds the _umkehr_if.pyd on Windows 64 bit.
REM 
REM   THIS SCRIPT SHOULD BE RUN FROM THE "PGI CMD" console so the PGI Fortran compiler (18.10) is properly enabled.
REM 
REM 1) Before calling this script you fire up the Visual Studio 2017 project and build the
REM    C++ interface for the correct version of Python.
REM 
REM 2) After compiling the C++ and SWIG code then you can compile and build the DLL with the 
REM    PGI fortran tools. The fortran needs to do this to link and initialize the proper
REM    fortran libraries
REM -----------------------------------------------------------------------------------------
REM 
REM CALL "C:\PROGRA~1\PGI\win64\18.10\pgi_dos.bat"
ECHO ON

pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -c ..\sources\matinvn.f   -o obj\matinvn.obj
pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -c ..\sources\sasco3.f    -o obj\sasco3.obj
pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -c ..\sources\spline.f    -o obj\spline.obj
pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -c ..\sources\stndrd.f    -o obj\stndrd.obj
pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -c ..\sources\umkehr_interface.f -o obj\umkehr_interface.obj
pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -c ..\sources\umkv8.f            -o obj\umkv8.obj
pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -c ..\sources\decodev4.for       -o obj\decodev4.obj
REM pgfortran -fast -i4 -r8 -Mfixed -Mr8 -Mr8intrinsics -Mnomain -Msave -Bdynamic -Mmakedll -Xlinker /VERBOSE:Lib  -L C:\Users\nickl\Anaconda3\libs -o _umkehr_if.pyd obj\matinvn.obj obj\sasco3.obj obj\spline.obj obj\stndrd.obj obj\umkehr_interface.obj obj\umkv8.obj obj\decodev4.obj  obj\umkehr_if_wrap.obj obj\umkehr_if.obj obj\umkehr_io.obj

ar -rv ../umkehr_codelib.lib obj\matinvn.obj obj\sasco3.obj obj\spline.obj obj\stndrd.obj obj\umkehr_interface.obj obj\umkv8.obj obj\decodev4.obj obj\umkehr_if.obj obj\umkehr_io.obj 

ECHO OFF
ECHO                  
ECHO                  ********        **    **
ECHO                **        **      **   ** 
ECHO                **        **      ** ** 
ECHO                **        **      *** *
ECHO                **        **      **   **
ECHO                **        **      **    **
ECHO                  ********        **     **
ECHO ON
ECHO  	    The build process for the libraries worked!
EXIT /B 0

