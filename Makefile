.SUFFIXES:
.SUFFIXES: .o .f

.f.o:
	gfortran -c -fmessage-length=0 -std=legacy -ffixed-line-length-72 -Wunused-variable -fdefault-real-8 -fdefault-double-8 -fno-automatic -c -o $@ $<


VPATH= ./:sources

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
          umkv8.o

#----------------------------------------------------------------------------
#	Create the main target (e.g.) libnovas.a
#	and then copy the jpleph binary file to the location specified by the
#	the environment variable JPLEPH.
#
#----------------------------------------------------------------------------

build: $(O_DEPENDS) 
	ar -rc libumkehr.a $(O_DEPENDS)
	ranlib -v libumkehr.a
	# mkdir -f lib
	mv libumkehr.a ./lib/libumkehr.a
	@echo "Compilation of umkehr source code complete."
	@echo "*** SUCCESS ***"


#----------------------------------------------------------------------------
#	Clean up the release in preparation for a brand new build
#----------------------------------------------------------------------------

clean:
	rm -f ./lib/libumkehr.a
	rm -f ./libumkehr.a
	rm -f *.o


