# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# SuiteSparse
PKG             := suitesparse
$(PKG)_VERSION  := 3.7.0
$(PKG)_CHECKSUM := a1f57cb7f6bbea5d33911c6ca6acd77ba7dfa117
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.cise.ufl.edu/research/sparse/SuiteSparse/
$(PKG)_URL      := http://www.cise.ufl.edu/research/sparse/SuiteSparse/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas lapack

define $(PKG)_UPDATE
    wget -q -O- 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/' | \
    $(SED) -n 's,.*SuiteSparse-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # exclude demos
    find '$(1)' -name 'Makefile' \
        -exec $(SED) -i 's,( cd Demo,#( cd Demo,' {} \;

    # build all
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        CC='$(TARGET)-gcc' \
        CPLUSPLUS='$(TARGET)-g++' \
        F77='$(TARGET)-gfortran' \
        AR='$(TARGET)-ar cr' \
        RANLIB='$(TARGET)-ranlib' \
        BLAS='-lblas -lgfortran -lgfortranbegin' \
        CHOLMOD_CONFIG='-DNPARTITION'

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
