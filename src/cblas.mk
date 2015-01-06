# This file is part of MXE.
# See index.html for further information.

PKG             := cblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := d6970cf52592ef67674a61c78bbd055a4e9d4680
$(PKG)_SUBDIR   := CBLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_URL      := http://www.netlib.org/blas/blast-forum/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/blas/blast-forum/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
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
