.SUFFIXES:
.SUFFIXES: .o .f .for .cpp

.f.o:
	gfortran -fmessage-length=0 -fvisibility=hidden -shared -std=legacy -fpic -ffixed-line-length-72 -Wunused-variable -fdefault-real-8 -fdefault-double-8 -fno-automatic -c -o $@ $<
.for.o:
	gfortran -fmessage-length=0 -fvisibility=hidden -shared -std=legacy -fpic -ffixed-line-length-72 -Wunused-variable -fdefault-real-8 -fdefault-double-8 -fno-automatic -c -o $@ $<
.cpp.o:
	g++ -O3 -std=c++11 -fvisibility=hidden -fPIC -I./ -I C:/msys64/mingw64/include/python3.7m -c -o $@ $<

VPATH= ./:\
       sources:\
       sources/stand-alone-driver:\
       sources/cpp-sources

.PHONY: build
.PHONY: install
.PHONY: test
.PHONY: clean

#----------------------------------------------------------------------------
#	define the dependencies
#----------------------------------------------------------------------------

O_DEPENDS=matinvn.o\
          sasco3.o\
          spline.o\
          stndrd.o\
          umkehr_interface.o\
          umkv8.o\
          decodev4.o
          
CPP_DEPENDS=umkehr_if.o\
	umkehr_io.o

STAND_ALONE=cimpl_emulator.o\
	umkehr_driver.o

#----------------------------------------------------------------------------
#	Create the main target (e.g.) libnovas.a
#	and then copy the jpleph binary file to the location specified by the
#	the environment variable JPLEPH.
#
#----------------------------------------------------------------------------

build: $(O_DEPENDS) $(CPP_DEPENDS)
	pushd ./sources/cpp-sources; swig -c++ -python -py3 -naturalvar umkehr_if.i; popd
	mv -f ./sources/cpp-sources/umkehr_if.py ./python/umkehr_if/umkehr_if.py 
	g++ -O3 -std=c++11 -fvisibility=hidden -fPIC -I./ -I C:/msys64/mingw64/include/python3.7m -c -o umkehr_if_wrap.o ./sources/cpp-sources/umkehr_if_wrap.cxx
	g++ -shared -o umkehr_if/_umkehr_if.pyd umkehr_if_wrap.o $(O_DEPENDS) $(CPP_DEPENDS) -LC:/msys64/mingw64/lib -lpython3.7m.dll -lgfortran  -lm
	rm -f *.o
	@echo "Build of umkehr_if python interface complete."
	@echo "*** SUCCESS ***"

ctest: $(O_DEPENDS) $(CPP_DEPENDS) ctest.o
	g++ -o umkehr_testc ctest.o $(O_DEPENDS) $(CPP_DEPENDS) -lgfortran  -lm

standalone: $(O_DEPENDS) $(STAND_ALONE)
	gfortran -std=legacy -o umkehr_program  $(STAND_ALONE) $(O_DEPENDS)
	@echo "Compilation of umkehr stand-alone program is complete."
	@echo "*** SUCCESS ***"

#----------------------------------------------------------------------------
#	Clean up the release in preparation for a brand new build
#----------------------------------------------------------------------------

clean:
	rm -f ._umkehr_if.pyd
	rm -f *.o



