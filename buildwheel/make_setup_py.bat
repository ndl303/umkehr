
echo ***********************************************************
echo * This batch file makes a setup.py for a python wheel with:
echo * Pratmo version  = %1 
echo * Python version  = %2
echo * *********************************************************

call %3\generate_setup_py %1 %2 > %3\setup.py
echo setup.py created.
echo ***********************************************************
type %3\setup.py
echo ***********************************************************



