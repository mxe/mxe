# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cblas
$(PKG)_WEBSITE  := https://www.netlib.org/blas/
$(PKG)_DESCR    := C interface to Reference BLAS
$(PKG)_IGNORE    = $(lapack_IGNORE)
$(PKG)_VERSION   = $(lapack_VERSION)
$(PKG)_CHECKSUM  = $(lapack_CHECKSUM)
$(PKG)_SUBDIR    = $(lapack_SUBDIR)
$(PKG)_FILE      = $(lapack_FILE)
$(PKG)_URL       = $(lapack_URL)
$(PKG)_DEPS     := cc blas

define $(PKG)_UPDATE
    echo $(lapack_VERSION)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DBLAS_LIBRARIES=blas \
        -DCBLAS=ON \
        -DLAPACKE=OFF
    $(MAKE) -C '$(BUILD_DIR)/CBLAS' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)/CBLAS' -j 1 install

    '$(TARGET)-gfortran' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/CBLAS/examples/cblas_example1.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`

    # if blas routines are used directly, add to pkg-config call
    '$(TARGET)-gfortran' \
        -W -Wall -Werror -ansi -pedantic \
        '$(SOURCE_DIR)/CBLAS/examples/cblas_example2.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-F77.exe' \
        `'$(TARGET)-pkg-config' $(PKG) blas --cflags --libs`
endef
