# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := eigen
$(PKG)_WEBSITE  := https://eigen.tuxfamily.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := b4c198460eba6f28d34894e3a5710998818515104d6e74e5cc331ce31e46e626
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://gitlab.com/libeigen/$(PKG)/-/archive/$($(PKG)_VERSION)/eigen-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://eigen.tuxfamily.org/index.php?title=Main_Page#Download' | \
    $(SED) -nr 's/^.*eigen-([0-9]+\.[0-9]+\.[0-9]+)\.tar\.bz2.*$/\1/p' | $(SORT) -Vr | $(SED) 1q
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
