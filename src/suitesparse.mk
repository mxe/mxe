# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := suitesparse
$(PKG)_WEBSITE  := http://faculty.cse.tamu.edu/davis/suitesparse.html
$(PKG)_DESCR    := SuiteSparse
$(PKG)_VERSION  := 4.5.6
$(PKG)_CHECKSUM := de5fb496bdc029e55955e05d918a1862a177805fbbd5b957e8b5ce6632f6c77e
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://faculty.cse.tamu.edu/davis/SuiteSparse/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/SuiteSparse/$($(PKG)_FILE)
$(PKG)_DEPS     := cc intel-tbb metis openblas

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://faculty.cse.tamu.edu/davis/suitesparse.html' | \
    $(SED) -n 's,.*SuiteSparse-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

$(PKG)_MAKE_OPTS = \
    UNAME=Windows \
    AR='$(TARGET)-ar' \
    CC='$(TARGET)-gcc' \
    CXX='$(TARGET)-g++' \
    F77='$(TARGET)-gfortran' \
    RANLIB='$(TARGET)-ranlib' \
    BLAS="`'$(TARGET)-pkg-config' --libs openblas`" \
    LAPACK="`'$(TARGET)-pkg-config' --libs openblas`" \
    MY_METIS_LIB="`'$(TARGET)-pkg-config' --libs metis`" \
    TBB="`'$(TARGET)-pkg-config' --libs intel-tbb`" \
    SPQR_CONFIG="-DHAVE_TBB"

define $(PKG)_PC_TEST
    # create pkg-config file for includes and base deps
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: suitesparseconfig'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: SuiteSparse includes and deps'; \
     echo 'Requires: intel-tbb openblas metis'; \
     echo 'Libs: -lsuitesparseconfig'; \
     echo 'Cflags: -I"$(PREFIX)/$(TARGET)/include/suitesparse"'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/suitesparseconfig.pc'

    '$(TARGET)-g++' \
        -W -Wall \
        '$(SOURCE_DIR)/SPQR/Demo/qrdemo.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lspqr -lcholmod -lcolamd -lccolamd -lcamd -lamd \
        `'$(TARGET)-pkg-config' suitesparseconfig --cflags --libs `

    # batch file to run test program
    cp '$(SOURCE_DIR)/SPQR/Matrix/a2.mtx' '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-matrix.txt'
    (printf 'test-$(PKG).exe < test-$(PKG)-matrix.txt\r\n'; \
    ) > '$(PREFIX)/$(TARGET)/bin/test-$(PKG).bat'
endef

define $(PKG)_BUILD_STATIC
    # build libraries
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' \
        $($(PKG)_MAKE_OPTS) \
        static

    # install library files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    find '$(SOURCE_DIR)' -name 'lib*.a' \
        -exec $(INSTALL) -m644 {} '$(PREFIX)/$(TARGET)/lib/' \;

    # install headers
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install \
        $($(PKG)_MAKE_OPTS) \
        INSTALL_INCLUDE='$(PREFIX)/$(TARGET)/include/suitesparse'

    # pc and test
    $($(PKG)_PC_TEST)
endef

define $(PKG)_BUILD_SHARED
    # build and install libraries and headers
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' \
        $($(PKG)_MAKE_OPTS) \
        library
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install \
        $($(PKG)_MAKE_OPTS) \
        INSTALL_INCLUDE='$(PREFIX)/$(TARGET)/include/suitesparse' \
        INSTALL_LIB='$(PREFIX)/$(TARGET)/lib' \
        INSTALL_SO='$(PREFIX)/$(TARGET)/bin'

    # pc and test
    $($(PKG)_PC_TEST)
endef
