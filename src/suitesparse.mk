# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SuiteSparse
PKG             := suitesparse
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := 6de027d48a573659b40ddf57c10e32b39ab034c6
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.cise.ufl.edu/
$(PKG)_URL      := http://www.cise.ufl.edu/research/sparse/SuiteSparse/SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc metis lapack

define $(PKG)_UPDATE
    wget -q -O- 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/' | \
    $(SED) -n 's,.*SuiteSparse-\([0-9]\.[0-9]\.[0-9]\)\.tar.*,\1,ip' | \
    head -1
endef

define $(PKG)_BUILD
    
    # If not building metis in it's makefile, then
    # build it here since the config seems to expect it
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,metis)
    $(SED) -i 's,cc,$(TARGET)-gcc,'        $(1)/$(metis_SUBDIR)/Makefile.in
    $(SED) -i 's,ar ,$(TARGET)-ar ,'       $(1)/$(metis_SUBDIR)/Makefile.in
    $(SED) -i 's,ranlib,$(TARGET)-ranlib,' $(1)/$(metis_SUBDIR)/Makefile.in
    $(MAKE) -C '$(1)/$(metis_SUBDIR)/Lib' -j '$(JOBS)'

    # Otherwise hack the config so it can find metis
    #$(SED) -i 's,\(METIS_PATH = \)\(.    $(INSTALL) -m664 '$(1)/.    $(INSTALL) -m664 '$(1)/metis-4.0\),\1'$(PREFIX)/$(TARGET)/include/metis',' $(1)/UFconfig/UFconfig.mk
    #$(SED) -i 's,\(METIS = \)\(.    $(INSTALL) -m664 '$(1)/.    $(INSTALL) -m664 '$(1)/metis-4.0/libmetis.a\),\1'$(PREFIX)/$(TARGET)/lib/libmetis.a',' $(1)/UFconfig/UFconfig.mk
    
    # use cross tools
    $(SED) -i 's,cc,$(TARGET)-gcc,'        $(1)/UFconfig/UFconfig.mk
    $(SED) -i 's,g++,$(TARGET)-g++,'       $(1)/UFconfig/UFconfig.mk
    $(SED) -i 's,f77,$(TARGET)-gfortran,'  $(1)/UFconfig/UFconfig.mk
    $(SED) -i 's,ar ,$(TARGET)-ar ,'       $(1)/UFconfig/UFconfig.mk
    $(SED) -i 's,ranlib,$(TARGET)-ranlib,' $(1)/UFconfig/UFconfig.mk

    # gfortran does not need libg2c 
    $(SED) -i 's,-lblas -lgfortran -lgfortranbegin -lg2c,-lblas -lgfortran -lgfortranbegin,' $(1)/UFconfig/UFconfig.mk
    
    # Missing _drand48 and _srand48 cause problems in demos 	
    #$(TARGET)-gcc -c $(1)/CHOLMOD/MATLAB/Windows/rand48.c -o $(1)/CHOLMOD/Lib/rand48.o 
    #$(SED) -i 's,libcholmod.a: $$(OBJ),libcholmod.a: $$(OBJ) rand48.o,' $(1)/CHOLMOD/Lib/Makefile
    #$(SED) -i 's,$$(AR) libcholmod.a $$(OBJ),$$(AR) libcholmod.a $$(OBJ) rand48.o,' $(1)/CHOLMOD/Lib/Makefile
    # Here we choose to exclude the demos from building in order to avoid the _rand48 problems
    $(SED) -i 's,( cd Demo ; $$(MAKE) ),#( cd Demo ; $$(MAKE) ),' $(1)/CHOLMOD/Makefile
    $(SED) -i 's,( cd Demo ; $$(MAKE) ),#( cd Demo ; $$(MAKE) ),' $(1)/SPQR/Makefile

    # Built all
    $(MAKE) -C '$(1)' -j '$(JOBS)'

    # Install library files 
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    for i in `cd $(1) && find . -name *.a`; do \
    	$(INSTALL) -m664 '$(1)/'$$i '$(PREFIX)/$(TARGET)/lib/' ; \
    done;

    # Install include files 
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/AMD/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/BTF/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/CAMD/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/CCOLAMD/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/CHOLMOD/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/COLAMD/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/CXSparse/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/KLU/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/LDL/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/SPQR/Include/'* '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/UFconfig/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m664 '$(1)/UMFPACK/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'

endef


