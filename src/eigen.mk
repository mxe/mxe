# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := eigen
$(PKG)_WEBSITE  := https://eigen.tuxfamily.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.1
$(PKG)_CHECKSUM := e4de6b08f33fd8b8985d2f204381408c660bffa6170ac65b68ae1bd3cd575c0a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gitlab.com/libeigen/$(PKG)/-/archive/$($(PKG)_VERSION)/eigen-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.com/libeigen/eigen/-/tags' | \
    $(SED) -n 's,.*archive/\([0-9\.]*\)/eigen-.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # remove previous install
    rm -rf "$(PREFIX)/$(TARGET)/*/eigen3"
    rm -rf "$(PREFIX)/$(TARGET)/*/pkgconfig/eigen3.pc"

    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DEIGEN_BUILD_PKGCONFIG=ON \
        -DPKGCONFIG_INSTALL_DIR='$(PREFIX)/$(TARGET)/lib/pkgconfig' \
        -DBUILD_TESTING=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' -W -Wall '$(TEST_FILE)' -o \
        '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' --cflags --libs eigen3`
endef
