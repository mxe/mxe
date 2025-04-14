# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lapack
$(PKG)_WEBSITE  := https://www.netlib.org/lapack/
$(PKG)_DESCR    := Reference LAPACK — Linear Algebra PACKage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.12.1
$(PKG)_CHECKSUM := 2ca6407a001a474d4d4d35f3a61550156050c48016d949f0da0529c0aa052422
$(PKG)_GH_CONF  := Reference-LAPACK/lapack/tags,v
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc openblas

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --trace-expand '$(SOURCE_DIR)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DBLAS_LIBRARIES="`'$(TARGET)-pkg-config' --libs openblas`"  \
        -DCBLAS=OFF \
        -DLAPACKE=ON \
        -DTEST_FORTRAN_COMPILER:BOOL=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # if blas/cblas routines are used directly, add to pkg-config call
    '$(TARGET)-gfortran' \
        -W -Wall -Werror -pedantic \
        '$(PWD)/src/$(PKG)-test.f' -o '$(PREFIX)/$(TARGET)/bin/test-lapack.exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`

    '$(TARGET)-gfortran' \
        -W -Wall -Werror -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-lapacke.exe' \
        `'$(TARGET)-pkg-config' lapacke --cflags --libs`
endef
