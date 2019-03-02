# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := eigen
$(PKG)_WEBSITE  := https://eigen.tuxfamily.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.7
$(PKG)_CHECKSUM := 9f13cf90dedbe3e52a19f43000d71fdf72e986beb9a5436dddcd61ff9d77a3ce
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-323c052e1731
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://eigen.tuxfamily.org/index.php?title=Main_Page#Download' | \
    grep 'eigen/get/' | \
    $(SED) -n 's,.*eigen/get/\(3[^>]*\)\.tar.*,\1,p' | \
    head -1
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
