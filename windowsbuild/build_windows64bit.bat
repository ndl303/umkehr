
CALL "C:\Program Files (x86)\Intel\Compiler\11.0\072\fortran\Bin\ifortvars.bat" intel64

ifort /noautomatic /dll /4L72 /double-size:64 /real-size:64 /c ..\sources\matinvn.f
ifort /noautomatic /dll /4L72 /double-size:64 /real-size:64 /c ..\sources\sasco3.f
ifort /noautomatic /dll /4L72 /double-size:64 /real-size:64 /c ..\sources\spline.f
ifort /noautomatic /dll /4L72 /double-size:64 /real-size:64 /c ..\sources\stndrd.f
ifort /noautomatic /dll /4L72 /double-size:64 /real-size:64 /c ..\sources\umkehr_interface.f
ifort /noautomatic /dll /4L72 /double-size:64 /real-size:64 /c ..\sources\umkv8.f
ifort /noautomatic /dll /4L72 /double-size:64 /real-size:64 /c ..\sources\decodev4.for





ECHO OFF
ECHO Welcome  This software will build the base libraries for the ARG
ECHO          development. I assume you have already setup the Visual Studio
ECHO          include and library paths.
ECHO
ECHO          SK_SVN_DIR\Repos_BaseCode\nxbase
ECHO          SK_SVN_DIR\Repos_BaseCode\atombase
ECHO          SK_SVN_DIR\Repos_BaseCode\lapack
ECHO          SK_SVN_DIR\Repos_skclimatology
ECHO          SK_SVN_DIR\Repos_skopticalproperties
ECHO          SK_SVN_DIR\Repos_SasktranV3
ECHO          Boost C++ libraries eg. G:\boost\VS2012\boost_1_53_0

REM ****************************************************************
REM *	Setup defaults
REM *
REM *	CFG    = the configuration to build (typically Release or Debug)
REM *	PLTFRM = the platform to build
REM ****************************************************************

SET CFG=Release
IF /i %PROCESSOR_ARCHITECTURE%==x86 (SET PLTFRM=win32) ELSE (SET PLTFRM=x64)

REM ****************************************************************
REM *	Process Command line arguments
REM *	%1 = VS2008, VS2012 or VS2015
REM *	%2 = Configuration (eg Debug, Release)
REM *	%3 = Platform ( eg x64, win32 )
REM *   %4 = rebuild (optional) 
REM ****************************************************************

SET SK_SVN_DIR="DONT USE SK_SVN_DIR DIRECTLY"
SET SK_OBJ_DIR="DONT USE SK_OBJ_DIR DIRECTLY"
ECHO "SK_SVN_DIR=%SK_SVN_DIR%"
ECHO "SK_OBJ_DIR=%SK_OBJ_DIR%"

SET VSXXXX=VS2008
SET VSXXXX=%1
SET VAR1=%2
SET VAR2=%3
SET VAR4=%4
ECHO "%VAR4%"

IF DEFINED VAR2 SET PLTFRM=%VAR2%
IF DEFINED VAR1 SET CFG=%VAR1%
REM CALL CHECKENVIROS %PLTFRM%  %VSXXXX%
REM IF ERRORLEVEL 1 (EXIT /B 1)


:BUILDVS2012
SET RB=
SET RBLD=%VAR4%
IF A%RBLD%B EQU AB GOTO BUILDVS2012A
ECHO RBLD IS DEFINED = %RBLD%
IF /i %RBLD% EQU /rebuild GOTO BUILDVS2012B
ECHO
ECHO ********* ERROR *************************************************************
ECHO * Invalid 4th Parameter. You can either leave it blank or only use /rebuild *
ECHO *****************************************************************************
ECHO
GOTO FAILEDBUILDERROR

:BUILDVS2012B
SET RB=/t:rebuild

:BUILDVS2012A

echo %CFG% |findstr /b /I "Py" >nul && (
  SET CORECFG="Release"
  SET IFCFG=%CFG%
) || (
  SET CORECFG=%CFG%
  SET IFCFG=%CFG%
)

MSBUILD %RB% /m /p:Platform=%PLTFRM% /p:Configuration=%CORECFG%  .\Repos_BaseCode\nxbase\CompilerIDE\%VSXXXX%\nxbase.sln                   &  IF ERRORLEVEL 1 (GOTO FAILEDBUILDERROR)
MSBUILD %RB% /m /p:Platform=%PLTFRM% /p:Configuration=%CORECFG%  .\Repos_BaseCode\nxhdf\CompilerIDE\%VSXXXX%\nxhdfonyx.sln                 &  IF ERRORLEVEL 1 (GOTO FAILEDBUILDERROR)
MSBUILD %RB% /m /p:Platform=%PLTFRM% /p:Configuration=%CORECFG%  .\Repos_SasktranIF\CompilerIDE\%VSXXXX%\SasktranIF\sasktranIF.sln         &  IF ERRORLEVEL 1 (GOTO FAILEDBUILDERROR)
MSBUILD %RB% /m /p:Platform=%PLTFRM% /p:Configuration=%CORECFG%  .\Repos_skclimatology\CompilerIDE\%VSXXXX%\skclimatology.sln              &  IF ERRORLEVEL 1 (GOTO FAILEDBUILDERROR)
MSBUILD %RB% /m /p:Platform=%PLTFRM% /p:Configuration=%CORECFG%  .\Repos_skopticalproperties\CompilerIDE\%VSXXXX%\skopticalproperties.sln  &  IF ERRORLEVEL 1 (GOTO FAILEDBUILDERROR)
MSBUILD %RB% /m /p:Platform=%PLTFRM% /p:Configuration=%CORECFG%  .\Repos_SasktranV3\CompilerIDE\%VSXXXX%\sasktranv301.sln                  &  IF ERRORLEVEL 1 (GOTO FAILEDBUILDERROR)
MSBUILD %RB% /m /p:Platform=%PLTFRM% /p:Configuration=%IFCFG%  .\SasktranCoreComponents_Installers\CompilerIDE\%VSXXXX%\sasktrancorecomponent_installers.sln                  &  IF ERRORLEVEL 1 (GOTO FAILEDBUILDERROR)


:SUCCESSBUILD
ECHO.
ECHO                  
ECHO                  ********        **    **
ECHO                **        **      **   ** 
ECHO                **        **      ** ** 
ECHO                **        **      *** *
ECHO                **        **      **   **
ECHO                **        **      **    **
ECHO                  ********        **     **
ECHO.
ECHO  	    The build process for the libraries worked!
EXIT /B 0

:FAILEDBUILDERROR
ECHO.
ECHO.
ECHO.
ECHO                  
ECHO              *******    **     **  **
ECHO              **       **  **   **  **
ECHO              **      **    **  **  ** 
ECHO              ****    ********  **  **
ECHO              **      **    **  **  **
ECHO              **      **    **  **  **
ECHO              **      **    **  **  ********
ECHO.
ECHO ************************** FAILURE ******************************************************
ECHO.
ECHO * The build process for the nxbase libraries failed. Thats a problem!
ECHO *
ECHO * Check 1) Make sure you have setup the x64 or win32 visual studio settings
ECHO *          for x64 /or win32 with the proper include directories and the proper
ECHO *          library directories.
ECHO *
ECHO *       2) This code does not build the fortran libraries but uses pre-compiled binaries
ECHO *          which are in the Repos_Libs repository. Make sure you have an up-to-date version.
ECHO *
ECHO ************************** FAILURE *******************************************************
EXIT /B 1
