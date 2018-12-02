..  _installation:

Installation Of Umkehr
======================


- g++
- gfortran
- swig
- anaconda python (or similar)

problems with Fortran/gcc incompatibilities:
Internal Error:get_unit() Bad internal unit KIND

conda create -n umkehr python=3.6
conda install gcc
conda activate umkehr

./configure
make
make install

pip install umkehr_if-\*.whl


Download the package from GitHub
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

How to download

Pre-requisites
^^^^^^^^^^^^^^

A description of prerequisites

