# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cblas
$(PKG)_WEBSITE  := http://www.netlib.org/blas/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.0
$(PKG)_CHECKSUM := a8ce4930cfc695a7c09118060f5f2aa3601130e5265b2f4572c0984d5f282e49
$(PKG)_SUBDIR   := lapack-release-lapack-$($(PKG)_VERSION)
$(PKG)_FILE     := lapack-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Reference-LAPACK/lapack-release/archive/lapack-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc blas

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DCBLAS=ON
    $(MAKE) -C '$(BUILD_DIR)/CBLAS' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/CBLAS/examples/cblas_example1.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lcblas -lblas -lgfortran -lquadmath

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/CBLAS/examples/cblas_example2.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-F77.exe' \
        -lcblas -lblas -lgfortran -lquadmath -DADD_
endef
