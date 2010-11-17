# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SuiteSparse
PKG             := suitesparse
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := 6de027d48a573659b40ddf57c10e32b39ab034c6
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.cise.ufl.edu/research/sparse/SuiteSparse/
$(PKG)_URL      := http://www.cise.ufl.edu/research/sparse/SuiteSparse/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc metis blas lapack

define $(PKG)_UPDATE
    wget -q -O- 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/' | \
    $(SED) -n 's,.*SuiteSparse-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # set path to metis
    $(SED) -i 's,METIS_PATH =.*,METIS_PATH = $(PREFIX)/$(TARGET)/include/metis,' '$(1)/UFconfig/UFconfig.mk'
    $(SED) -i 's,METIS =.*,METIS = $(PREFIX)/$(TARGET)/lib/libmetis.a,'          '$(1)/UFconfig/UFconfig.mk'

    # use cross tools
    $(SED) -i 's,cc,$(TARGET)-gcc,'        '$(1)/UFconfig/UFconfig.mk'
    $(SED) -i 's,g++,$(TARGET)-g++,'       '$(1)/UFconfig/UFconfig.mk'
    $(SED) -i 's,f77,$(TARGET)-gfortran,'  '$(1)/UFconfig/UFconfig.mk'
    $(SED) -i 's,ar ,$(TARGET)-ar ,'       '$(1)/UFconfig/UFconfig.mk'
    $(SED) -i 's,ranlib,$(TARGET)-ranlib,' '$(1)/UFconfig/UFconfig.mk'

    # gfortran does not need libg2c
    $(SED) -i 's,-lg2c,,' '$(1)/UFconfig/UFconfig.mk'

    # exclude demos
    find '$(1)' -name 'Makefile' \
        -exec $(SED) -i 's,( cd Demo,#( cd Demo,' {} \;

    # build all
    $(MAKE) -C '$(1)' -j '$(JOBS)'

    # install library files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    find '$(1)' -name '*.a' \
        -exec $(INSTALL) -m644 {} '$(PREFIX)/$(TARGET)/lib/' \;

    # install include files
    $(INSTALL) -d                                '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/AMD/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/BTF/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CAMD/Include/'*.h     '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CCOLAMD/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CHOLMOD/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/COLAMD/Include/'*.h   '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CXSparse/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/KLU/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/LDL/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/SPQR/Include/'*       '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/UFconfig/'*.h         '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/UMFPACK/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
endef
