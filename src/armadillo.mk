# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := armadillo
$(PKG)_WEBSITE  := https://arma.sourceforge.io/
$(PKG)_DESCR    := Armadillo C++ linear algebra library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.200.2
$(PKG)_CHECKSUM := 63845e36235f2bd78b4f6890fe5013b6ce51a4e92e3176b20bbc6631b340050a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/arma/$($(PKG)_FILE)
$(PKG)_DEPS     := cc hdf5 openblas

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/arma/files/' | \
    $(SED) -n 's,.*/armadillo-\([0-9.]*\)[.]tar.*".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DDETECT_HDF5=ON \
        -DARMA_USE_WRAPPER=ON
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
        -W -Wall -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
