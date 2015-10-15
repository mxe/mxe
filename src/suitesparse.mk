# This file is part of MXE.
# See index.html for further information.

PKG             := suitesparse
$(PKG)_VERSION  := 4.2.1
$(PKG)_CHECKSUM := e8023850bc30742e20a3623fabda02421cb5774b980e3e7c9c6d9e7e864946bd
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://faculty.cse.tamu.edu/davis/SuiteSparse/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/SuiteSparse/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://faculty.cse.tamu.edu/davis/suitesparse.html' | \
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
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib' \
        BLAS='-lblas -lgfortran -lgfortranbegin -lquadmath' \
        CHOLMOD_CONFIG='-DNPARTITION'

    # install library files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    find '$(1)' -name '*.a' \
        -exec $(INSTALL) -m644 {} '$(PREFIX)/$(TARGET)/lib/' \;

    # install include files
    $(INSTALL) -d                                '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/SuiteSparse_config/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/AMD/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/BTF/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CAMD/Include/'*.h     '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CCOLAMD/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CHOLMOD/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/COLAMD/Include/'*.h   '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CSparse/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CXSparse/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/KLU/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/LDL/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/SPQR/Include/'*       '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/UMFPACK/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
endef

$(PKG)_BUILD_SHARED =
