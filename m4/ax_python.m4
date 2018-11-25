# 2015-08-27 ndl303 
# This code was modified so it searches the Anaconda distribution 
# The code only supports python3 and it uses python3 to look for its configuration
# information. You may have to modify the 3 python files in this directory
# if it fails to find you python distribution files.
#
# THis macro now attempt to locate and AC_SUBST
#
#	1) PYTHON_LIB_DIR	Directory where libpython3.so is stored. Used to link sasktranif python external module
#	2) PYTHON_INCLUDE_DIR	Directory where Python.h is stored, Used to compile sasktraif python module
#	3) NUMPY_INCLUDE_DIR	Directory where numpy.h is stored, Used to compile sasktranif python module
#	
#	The code also checks for the existence of swig as this is required.
#

# ===========================================================================
#         http://www.gnu.org/software/autoconf-archive/ax_python.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_PYTHON
#
# DESCRIPTION
#
#   This macro does a complete Python development environment check.
#
#   It recurses through several python versions (from 2.1 to 2.6 in this
#   version), looking for an executable. When it finds an executable, it
#   looks to find the header files and library.
#
#   It sets PYTHON_BIN to the name of the python executable,
#   PYTHON_INCLUDE_DIR to the directory holding the header files, and
#   PYTHON_LIB to the name of the Python library.
#
#   This macro calls AC_SUBST on PYTHON_BIN (via AC_CHECK_PROG),
#   PYTHON_INCLUDE_DIR and PYTHON_LIB.
#
# LICENSE
#
#   Copyright (c) 2008 Michael Tindal
#
#   This program is free software; you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation; either version 2 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <http://www.gnu.org/licenses/>.
#
#   As a special exception, the respective Autoconf Macro's copyright owner
#   gives unlimited permission to copy, distribute and modify the configure
#   scripts that are the output of Autoconf when processing the Macro. You
#   need not follow the terms of the GNU General Public License when using
#   or distributing such scripts, even though portions of the text of the
#   Macro appear in them. The GNU General Public License (GPL) does govern
#   all other use of the material that constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the Autoconf
#   Macro released by the Autoconf Archive. When you make and distribute a
#   modified version of the Autoconf Macro, you may extend this special
#   exception to the GPL to apply to your modified version as well.

#serial 14

AC_DEFUN([AX_PYTHON],
[AC_MSG_CHECKING(for python build information)
AC_MSG_RESULT([])
AC_PATH_PROG(PYTHON_BIN, [python3])
AC_PATH_PROG(SWIG_BIN, [swig])
ax_python_bin=$PYTHON_BIN

if test x$ax_python_bin = x; then
   AC_MSG_RESULT([ERROR, Cannot find command python3 on your path])
   PYTHON_LIB_DIR=NOTFOUND
   PYTHON_INCLUDE_DIR=NOTFOUND
   PYTHON_LINK_LIB=NOTFOUND
   PYTHON_DLLEXT=NOTFOUND
else
   PYTHON_LIB_DIR=$(python3 m4/pythonprefix.py)
   PYTHON_LINK_LIB=$(python3 m4/pythonlib.py)
   PYTHON_INCLUDE_DIR=$(python3 m4/pythoninclude.py)
   PYVERSION=$(python3 m4/pythonversion.py)
   PYTHON_DLLEXT=$(python3 m4/pythonsoextension.py)
fi

if test [ $PYTHON_LIB_DIR == 'NOTFOUND' -o $PYTHON_INCLUDE_DIR == 'NOTFOUND' -o $PYTHON_LINK_LIB == 'NOTFOUND' -o PYTHON_DLLEXT == 'NOTFOUND' ]; then
   AC_MSG_RESULT([  results of the Python check:])
   AC_MSG_RESULT([    Python executable    : $ax_python_bin])
   AC_MSG_RESULT([    Library Dir          : $PYTHON_LIB_DIR])
   AC_MSG_RESULT([    Library Name         : $PYTHON_LINK_LIB])
   AC_MSG_RESULT([    Shareable object ext : $PYTHON_DLLEXT])
   AC_MSG_RESULT([    Python Include Dir   : $PYTHON_INCLUDE_DIR])
   AC_MSG_ERROR([***** Error in the Python configuration. If python3 is installed you may have to edit the python scripts in the m4 subdirectory to return the proper python directories])
fi

AC_MSG_RESULT([  results of the Python check:])
AC_MSG_RESULT([    Python version       : $PYVERSION])
AC_MSG_RESULT([    Python executable    : $ax_python_bin])
AC_MSG_RESULT([    Library Dir          : $PYTHON_LIB_DIR])
AC_MSG_RESULT([    Library Name         : $PYTHON_LINK_LIB])
AC_MSG_RESULT([    Shareable object ext : $PYTHON_DLLEXT])
AC_MSG_RESULT([    Python Include Dir: $PYTHON_INCLUDE_DIR])

if test [x$SWIG_BIN == x]; then
   AC_MSG_ERROR([***** Error **** swig is not installed or not available. Please install swig for this user, eg sudo apt-get install swig])
fi

AC_SUBST(PYTHON_INCLUDE_DIR)
AC_SUBST(PYTHON_LIB_DIR)
AC_SUBST(PYTHON_LINK_LIB)
AC_SUBST(PYTHON_DLLEXT)
AC_SUBST(PYVERSION)

])dnl
