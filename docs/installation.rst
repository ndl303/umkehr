..  _installation:

Installation
============

The **umkehr** python package is installed as a binary Python wheel. The binary wheel can either be downloaded as a
pre-built binary python wheel (64 bit Linux only) from the USASK-ARG website or can be built from source code. The umkehr python package is
not available for python versions prior to 3.6 as we make extensive use of the *typing* features introduced in that version.

Install The Python Wheel
------------------------

Most users will choose to install the package on their 64 bit Linux systems using out pre-built `manylinux` version.  Wheels for Python 3.6 and 3.7
(Linux 64 bit only) can be installed from the USASK-ARG server using::

    pip install --update umkehr -f https:\\arg.usask.ca\wheels

After the wheel is installed you are ready to go.  We recommend running the installation test.

Tests
-----

You can test your `umkehr` installation. A test example is installed as part of the python package::

    python
    >>> from umkehr.examples.test_umkehr import test_Level1_to_Level2
    >>> test_Level_to_Level2()

The test takes about 20 seconds and processes a month of data from SYOWA in November 2009. It reads the data in from a Level 1 CSV file
and writes out a Level 2 CSV file. The screen output is shown below::

    Read in 60 lines from Umkehr Level 1 file 20091101.Dobson.Beck.119.JMA.csv
    03119 061109 1109276  -1  -1 317 524 577 681 819 857 845 820 761 676 609 534 101
    03119 061109 1309276  -1  -1 580 702 739 823 973 143 189 225 253 238 207 166 101
    03119 061109 1409276  -1  -1 207 267 285 330 416 529 574 622 696 754 778 784 101
    03119 061109 2100261 956  90 270 469 517 616 766 826 819 802 752 670 604 529 101
    03119 061109 2300261 393 461 558 668 700 772 910  69 123 169 212 214 189 147 101
    03119 061109 2400261 111 144 193 250 267 307 379 478 520 568 642 709 740 751 101
    03119 071109 1100295  43 197 396 578 627 721 832 864 850 825 762 674 605 524 101
    03119 071109 1300295 437 516 617 728 762 835 966 119 168 208 240 227 196 149 101
    03119 071109 1400295 132 171 219 276 293 331 404 507 551 599 673 735 760 765 101
    03119 071109 2109332 135 336 583 793 845 939  21  16 995 962 893 797 725 648 101
    03119 071109 2309332 482 587 718 859 901 992 150 298 334 355 356 322 279 233 101
    03119 071109 2409332 153 204 268 343 365 414 509 635 681 730 794 843 851 843 101
    03119 111109 1100374 277 453 670 872 920   2  52  14 985 949 876 780 711 630 101
    03119 111109 1300374 556 645 769 910 952  43 191 314 336 347 341 300 261 212 101
    03119 111109 1400374 185 232 295 366 388 437 533 654 699 741 800 838 845 833 101
    03119 121109 2100377 321 522 753 952 996  64 110  78  53  14 951 865 794 718 101
    03119 121109 2300377 580 679 817 965   9 107 254 363 382 390 380 345 309 262 101
    03119 121109 2400377 200 251 319 397 420 476 579 702 744 786 838 871 876 866 101
    03119 141109 1109383 331 522 771 971  11  78 107  70  35 993 921 832 766 697 101
    03119 141109 1309383 582 683 828 980  23 116 254 356 373 382 372 332 297 253 101
    03119 141109 1409383 204 254 323 404 428 482 582 698 739 781 837 871 875 864 101
    03119 151109 1100373 314 489 735 931 974  43  85  39  10 976 904 817 760 693 101
    03119 151109 1300373 574 666 806 954 994  89 236 348 369 377 365 327 288 243 101
    03119 151109 1400373 200 246 312 390 413 466 567 692 735 780 837 871 874 859 101
    03119 151109 2100384 339 522 770 977  23  90 119  84  54  13 946 860 791 720 101
    03119 151109 2300384 586 681 826 982  28 124 270 381 402 404 391 350 312 263 101
    03119 151109 2400384 206 255 325 404 429 485 596 717 761 804 855 884 885 872 101
    03119 161109 1100377 341 522 761 948 987  53  89  54  24 985 925 843 789 726 101
    03119 161109 1300377 586 681 822 969  12 109 254 361 379 385 371 334 296 252 101
    03119 161109 1400377 202 254 322 401 427 482 586 707 748 791 842 870 871 856 101
    03119 161109 2100391 380 564 812   5  46 112 139  86  54   7 933 844 774 695 101
    03119 161109 2300391 607 703 850   1  46 140 276 378 397 400 385 346 304 257 101
    03119 161109 2400391 215 264 334 415 439 491 593 715 757 802 855 882 883 871 101
    03119 171109 2109381  -1  -1  -1  -1  -1  82 115  76  45   6 932 846 778 702 101
    03119 171109 2309381  -1  -1  -1  -1  38 128 272 377 394 400 383 345 306 261 101
    03119 171109 2409381  -1  -1  -1  -1 435 491 596 714 756 799 852 878 881 871 101
    03119 181109 1100379 337 532 765 952 994  56  90  49  20 987 919 835 771 703 101
    03119 181109 1300379 585 688 827 976  18 111 251 357 375 380 369 332 296 255 101
    03119 181109 1400379 202 255 324 404 428 478 580 705 745 786 839 869 873 860 101
    03119 181109 2100379 333 530 771 969  11  76 107  63  28 994 928 839 775 703 101
    03119 181109 2300379 585 685 826 976  20 112 254 364 381 388 378 339 306 255 101
    03119 181109 2400379 205 253 323 400 424 477 579 701 744 787 843 876 880 867 101
    03119 191109 1100341 221 392 606 819 870 958  29   0 977 944 880 795 725 658 101
    03119 191109 1300341 528 614 735 879 924  24 187 318 345 356 347 311 276 235 101
    03119 191109 1400341 173 215 278 350 374 428 534 667 714 759 819 855 864 852 101
    03119 191109 2100353 241 413 646 877 927   9  61  32   4 969 897 815 751 678 101
    03119 191109 2300353 536 623 755 909 955  51 210 336 359 370 359 324 287 241 101
    03119 191109 2400353 182 226 292 368 392 446 551 683 726 772 833 868 871 857 101
    03119 271109 1100338 168 368 591 796 846 928 988 962 930 899 843 779 728  -1 101
    03119 271109 1300338 501 602 729 873 914   3 153 280 306 317 311 276 246  -1 101
    03119 271109 1400338 162 213 277 351 372 423 518 642 688 732 789 819 821  -1 101
    03119 271109 2100312  93 261 481 684 736 836 928 920 896 859 789 707 643  -1 101
    03119 271109 2300312 462 550 668 800 840 929  80 231 264 285 290 256 223  -1 101
    03119 271109 2400312 147 189 250 319 341 388 474 596 642 691 761 802 814  -1 101
    03119 281109 1104352  -1  -1  -1  -1 830 914 970 927 901 867 808 723 652  -1 101
    03119 281109 1304352  -1  -1  -1 861 901 989 132 257 283 296 289 259 223  -1 101
    03119 281109 1404352  -1  -1  -1  -1 368 416 507 629 670 711 764 805 813  -1 101
    03119 301109 2100307  87 246 463 665 716 811 893 882 859 826 753 665 594  -1 101
    03119 301109 2300307 458 543 659 790 828 914  59 198 230 250 252 220 182  -1 101
    03119 301109 2400307 143 189 246 313 334 378 465 580 622 664 726 769 779  -1 101
    Analyzing data with the UMKEHR algorithm.
    Level 2 Fortran Output Records
      6 11  9 1 3  276  2742   121   247   784  2010  4126  5913  5341  3582  2804  2491 2 3 10   5  11   34 101
      6 11  9 2 3  261  2570   113   214   670  1883  3869  4719  4097  3508  3426  3202 2 3 10   8   7   44 101
      7 11  9 1 3  295  2886   106   186   572  1833  4076  4668  4191  4383  4667  4176 2 3 10  30  14   71 101
      7 11  9 2 3  332  3300   122   251   817  2163  4559  6948  6916  4810  3593  2818 2 3 10   8  48   28 101
     11 11  9 1 3  374  3702   116   227   725  1959  4229  6924  7984  6285  4935  3639 3 3 10   0   1   37 101
     12 11  9 2 3  377  3753   123   257   818  1949  3924  7540  9164  6394  4378  2985 2 3 10   7  63   20 101
     14 11  9 1 3  383  3815   119   242   764  1850  3752  7350  9444  6834  4701  3090 3 3 10   0   1   18 101
     15 11  9 1 3  373  3709   118   237   749  1874  3970  7405  8841  6323  4481  3096 3 3 10   0   1   18 101
     15 11  9 2 3  384  3828   123   259   836  2036  4176  7960  9409  6376  4263  2841 2 3 10  10  82   15 101
     16 11  9 1 3  377  3752   119   240   756  1833  3858  7605  9220  6432  4436  3016 3 3 10   0   1   21 101
     16 11  9 2 3  391  3890   116   231   735  1861  3902  7495  9516  6954  4868  3224 3 3 10   0   1   18 101
     17 11  9 2 3  381  3803   121   250   797  1905  3937  7983  9688  6452  4183  2709 3 5  8   1   6   19 101
     18 11  9 1 3  379  3771   118   238   750  1804  3692  7341  9312  6700  4656  3101 3 3 10   0   1   17 101
     18 11  9 2 3  379  3771   118   239   764  1890  3864  7390  9172  6587  4600  3086 3 3 10   0   1   16 101
     19 11  9 1 3  341  3405   126   268   858  2017  4237  8002  8292  4929  3099  2220 3 3 10   1  10   50 101
     19 11  9 2 3  353  3530   127   274   890  2095  4257  8105  8769  5305  3268  2206 3 3 10   1  12   33 101
     27 11  9 1 3  338  3295   113   221   697  1727  3705  7278  8258  5265  3384  2297 3 3  9   0   1   37 101
     27 11  9 2 3  312  2965   110   206   650  1749  3994  6947  6836  4188  2827  2149 3 3  9   0   1   56 101
     28 11  9 1 3  352  3303   111   210   656  1654  3553  6866  8132  5557  3754  2535 3 4  8   0   4   78 101
     30 11  9 2 3  307  2948   105   188   567  1518  3622  6708  7054  4496  3025  2198 3 3  9   0   5   41 101
    Writing 20 lines to Umkehr Level 2 file 20091101.Dobson.Beck.119.JMA.Level2.csv
    2009-11-06,1,3,276,274.20,1.21,2.47,7.84,20.10,41.26,59.13,53.41,35.82,28.04,24.91,2,U,3,10,0.0050,0.110,0.340
    2009-11-06,2,3,261,257.00,1.13,2.14,6.70,18.83,38.69,47.19,40.97,35.08,34.26,32.02,2,U,3,10,0.0080,0.070,0.440
    2009-11-07,1,3,295,288.60,1.06,1.86,5.72,18.33,40.76,46.68,41.91,43.83,46.67,41.76,2,U,3,10,0.0300,0.140,0.710
    2009-11-07,2,3,332,330.00,1.22,2.51,8.17,21.63,45.59,69.48,69.16,48.10,35.93,28.18,2,U,3,10,0.0080,0.480,0.280
    2009-11-11,1,3,374,370.20,1.16,2.27,7.25,19.59,42.29,69.24,79.84,62.85,49.35,36.39,3,U,3,10,0.0000,0.010,0.370
    2009-11-12,2,3,377,375.30,1.23,2.57,8.18,19.49,39.24,75.40,91.64,63.94,43.78,29.85,2,U,3,10,0.0070,0.630,0.200
    2009-11-14,1,3,383,381.50,1.19,2.42,7.64,18.50,37.52,73.50,94.44,68.34,47.01,30.90,3,U,3,10,0.0000,0.010,0.180
    2009-11-15,1,3,373,370.90,1.18,2.37,7.49,18.74,39.70,74.05,88.41,63.23,44.81,30.96,3,U,3,10,0.0000,0.010,0.180
    2009-11-15,2,3,384,382.80,1.23,2.59,8.36,20.36,41.76,79.60,94.09,63.76,42.63,28.41,2,U,3,10,0.0100,0.820,0.150
    2009-11-16,1,3,377,375.20,1.19,2.40,7.56,18.33,38.58,76.05,92.20,64.32,44.36,30.16,3,U,3,10,0.0000,0.010,0.210
    2009-11-16,2,3,391,389.00,1.16,2.31,7.35,18.61,39.02,74.95,95.16,69.54,48.68,32.24,3,U,3,10,0.0000,0.010,0.180
    2009-11-17,2,3,381,380.30,1.21,2.50,7.97,19.05,39.37,79.83,96.88,64.52,41.83,27.09,3,U,5, 8,0.0010,0.060,0.190
    2009-11-18,1,3,379,377.10,1.18,2.38,7.50,18.04,36.92,73.41,93.12,67.00,46.56,31.01,3,U,3,10,0.0000,0.010,0.170
    2009-11-18,2,3,379,377.10,1.18,2.39,7.64,18.90,38.64,73.90,91.72,65.87,46.00,30.86,3,U,3,10,0.0000,0.010,0.160
    2009-11-19,1,3,341,340.50,1.26,2.68,8.58,20.17,42.37,80.02,82.92,49.29,30.99,22.20,3,U,3,10,0.0010,0.100,0.500
    2009-11-19,2,3,353,353.00,1.27,2.74,8.90,20.95,42.57,81.05,87.69,53.05,32.68,22.06,3,U,3,10,0.0010,0.120,0.330
    2009-11-27,1,3,338,329.50,1.13,2.21,6.97,17.27,37.05,72.78,82.58,52.65,33.84,22.97,3,U,3,10,0.0000,0.010,0.370
    2009-11-27,2,3,312,296.50,1.10,2.06,6.50,17.49,39.94,69.47,68.36,41.88,28.27,21.49,3,U,3,10,0.0000,0.010,0.560
    2009-11-28,1,3,352,330.30,1.11,2.10,6.56,16.54,35.53,68.66,81.32,55.57,37.54,25.35,3,U,4, 9,0.0000,0.040,0.780
    2009-11-30,2,3,307,294.80,1.05,1.88,5.67,15.18,36.22,67.08,70.54,44.96,30.25,21.98,3,U,3,10,0.0000,0.050,0.410
    (umkehr) ndl303@lloyd:~/umkehr/umkehr/examples$


Installing your own wheel
-------------------------

The python wheel file is a file that looks similar to `umkehr-0.3.0-cp37-cp37m-manylinux1_x86_64.whl`. If you have this file on
your local machine (because you either built it or downloaded it) then you can install it using::

    pip install <wheel-name>

where `<wheel-name>` is the name of the wheel file that you have. You can uninstall the python package using::

    pip uninstall umkehr



Build the Python Wheel on a Linux platform
------------------------------------------

The **umkehr** python wheel can be built from source using standard linux compiler tools,

- g++
- gfortran
- swig
- python3

We recommend the `Anaconda <https://www.anaconda.com/download/>`_ distribution for python but this is not a critcal option.
The code can be built in a virtual environment. The command `python3` must run the actual version of `python` that will be used to build
the wheel as the build scripts run `python3` to find the location of python include header files and python link libraries. Note that you must use
python 3.6 or higher.

If any of these tools are not installed on your system then they can usually be installed with package managers supplied with
the operating system, e.g::

    sudo apt-get install gfortran
    sudo apt-get install swig

The source code for the ``umkehr`` python package can be retrieved from a git repository using::

    git clone git@arggit.usask.ca:Nick/umkehr.git

The process to build the wheel is a 2 step system. The following commands should be entered::

    ./configure
    make

The build process is successful if you see a big *whoo-hoo, the python wheel is built* scroll down your screen at the end of the last step.
The wheel will be in sub-directory ./wheelhouse. A file listing, `ls -al ./wheelhouse`, should reveal the wheel. It will look something like `umkehr-0.3.0-cp37-cp37m-linux_x86_64.whl`.
This wheel can be installed into your version of Python, see above.

Building the manylinux version
------------------------------

The manylinux wheel is built using a special  `docker <https://docs.docker.com/>`_ image built by the Python
`manylinux <https://github.com/pypa/manylinux>`_ project specifically for building manylinux wheels. You must
then run the docker image and use the special umkehr build script provided::

    C:> docker run  -v C:\Users\nickl\Documents\Work\software\ARG_Packages:/packages -i -t 41c74197534c /bin/bash
    > cd /packages/umkehr
    > ./build_manylinux_in_docker

At the time of writing (2018-12-05) this built Python 3.6 and 3.7 wheels.


Building the Sphinx Documentation
---------------------------------

Building the Sphinx documentation is optional. The build uses the sphinx-rtd-theme theme. This package must be installed in your version of python::

    pip install sphinx_rtd_theme

The documentation can be built by going into the ``docs`` folder and running ``make``. The HTML is output to the ``_build`` folder

Build Issues
------------

We have encountered build issues on one slightly out-of-date Ubuntu system where the system successfully built the wheel
but failed during runtime with the error::

    Internal Error:get_unit() Bad internal unit KIND

Apparently this is a not uncommon problem due to ``gfortran``/``gcc`` incompatibilities. This is not an issue in the pre-built ``manylinux`` wheel.
It will only occur if you build a wheel specific to your system on a system with incompatible ``gfortran``/``gcc``.  A simple solution which works well is to create
a virtual environment using the Anaconda ``conda`` command, install a trustworthy version of ``gcc`` and ``gfortran`` and
activate the environment before building the wheel. For example, we create a ``conda`` environment called ``umkehr`` based upon python 3.6::

    conda create -n umkehr python=3.6
    conda install gcc
    conda activate umkehr

Once the enviroment is activated, the process to build the python wheel can continue as normal and seems to build and execute properly


