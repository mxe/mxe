# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lapack
$(PKG)_WEBSITE  := https://www.netlib.org/lapack/
$(PKG)_DESCR    := Reference LAPACK — Linear Algebra PACKage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.0
$(PKG)_CHECKSUM := deb22cc4a6120bff72621155a9917f485f96ef8319ac074a7afbc68aab88bcf6
$(PKG)_GH_CONF  := Reference-LAPACK/lapack/tags,v
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc cblas

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DBLAS_LIBRARIES=blas \
        -DCBLAS=OFF \
        -DLAPACKE=ON
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
        `'$(TARGET)-pkg-config' lapacke cblas --cflags --libs`
endef
