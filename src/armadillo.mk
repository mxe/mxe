# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := armadillo
$(PKG)_WEBSITE  := https://arma.sourceforge.io/
$(PKG)_DESCR    := Armadillo C++ linear algebra library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 12.0.1
$(PKG)_CHECKSUM := 230a5c75daad52dc47e1adce8f5a50f9aa4e4354e0f1bb18ea84efa2e70e20df
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/arma/$($(PKG)_FILE)
$(PKG)_DEPS     := cc hdf5 openblas lapack

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/arma/files/' | \
    $(SED) -n 's,.*/armadillo-\([0-9.]*\)[.]tar.*".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DARMA_HDF5_INCLUDE_DIR=$(PREFIX)/$(TARGET)/include \
        -DDETECT_HDF5=OFF \
        -DARMA_USE_WRAPPER=ON \
        -DBUILD_SMOKE_TEST=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires: hdf5 openblas'; \
     echo 'Libs: -larmadillo'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -fopenmp \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs` -lgomp
endef
