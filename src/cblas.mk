# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cblas
$(PKG)_WEBSITE  := http://www.netlib.org/blas/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := 0f6354fd67fabd909baf57ced2ef84e962db58fae126e4f41b21dd4fec60a2a3
$(PKG)_SUBDIR   := CBLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_URL      := http://www.netlib.org/blas/blast-forum/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftp.eq.uc.pt/software/math/netlib/blas/blast-forum/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openblas

$(PKG)_MESSAGE  :=*** cblas has been replaced by openblas ***

define $(PKG)_UPDATE
    echo 'Warning: cblas has been replaced by openblas' >&2;
    echo $(cblas_VERSION)
endef

define $(PKG)_DISABLED_BUILD
    $(SED) -i 's, make , $(MAKE) ,g' '$(1)/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        CBDIR='$(1)' \
        CBLIB='$(1)/lib/libcblas.a' \
        CC='$(TARGET)-gcc' \
        FC='$(TARGET)-gfortran' \
        ARCH='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib' \
        alllib

    $(INSTALL) -d                               '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/lib/libcblas.a'      '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d                               '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/include/cblas.h'     '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/include/cblas_f77.h' '$(PREFIX)/$(TARGET)/include/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(1)/examples/cblas_example1.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lcblas -lblas -lgfortran -lquadmath

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(1)/examples/cblas_example2.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-F77.exe' \
        -lcblas -lblas -lgfortran -lquadmath -DADD_
endef
