# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qca
$(PKG)_WEBSITE  := https://userbase.kde.org/QCA
$(PKG)_DESCR    := Qt Cryptographic Architecture
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3
$(PKG)_CHECKSUM := a5135ffb0250a40e9c361eb10cd3fe28293f0cf4e5c69d3761481eafd7968067
$(PKG)_GH_CONF  := KDE/qca/tags,v
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTS=OFF \
        -DBUILD_TOOLS=OFF \
        -DUSE_RELATIVE_PATHS=OFF \
        -DBUILD_PLUGINS="auto" \
        -DINSTAL_PKGCONFIG=ON \
        -DQCA_MAN_INSTALL_DIR="$(BUILD_DIR)/null"
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # build test as qmake project
    mkdir '$(BUILD_DIR).test-qmake'
    cd '$(BUILD_DIR).test-qmake' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PWD)/src/qca-test.pro'
    $(MAKE) -C '$(BUILD_DIR).test-qmake' -j 1
    $(INSTALL) -m755 '$(BUILD_DIR).test-qmake/$(BUILD_TYPE)/test-qca-qmake.exe' '$(PREFIX)/$(TARGET)/bin/'

    # build test as cmake project
    mkdir '$(BUILD_DIR).test-cmake'
    cd '$(BUILD_DIR).test-cmake' && $(TARGET)-cmake \
        -DPKG=$(PKG) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(BUILD_DIR).test-cmake' -j 1 install VERBOSE=ON

    # build test manually
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=gnu++11 \
        '$(PWD)/src/qca-test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-pkgconfig.exe' \
        $(if $(BUILD_STATIC), -L'$(PREFIX)/$(TARGET)/qt5/plugins/crypto' -lqca-ossl) \
        `'$(TARGET)-pkg-config' qca2-qt5 --cflags --libs`
endef

$(PKG)_BUILD_STATIC =
