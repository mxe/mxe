# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qca
$(PKG)_WEBSITE  := https://userbase.kde.org/QCA
$(PKG)_DESCR    := Qt Cryptographic Architecture
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.3
$(PKG)_CHECKSUM := a5135ffb0250a40e9c361eb10cd3fe28293f0cf4e5c69d3761481eafd7968067
$(PKG)_GH_CONF  := KDE/qca,v
$(PKG)_DEPS     := gcc qtbase

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

    $(if $(BUILD_SHARED), \
        mkdir '$(BUILD_DIR)/test-qca'
        cd '$(BUILD_DIR)/test-qca' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake' '$(PWD)/src/qca-test.pro'
        $(MAKE) -C '$(BUILD_DIR)/test-qca' -j $(JOBS) $(BUILD_TYPE)
        $(INSTALL) -m755 '$(BUILD_DIR)/test-qca/$(BUILD_TYPE)/test-qca5.exe' '$(PREFIX)/$(TARGET)/bin/')

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror \
        '$(SOURCE_DIR)/examples/base64test/base64test.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' qca2-qt5 --cflags --libs`
endef

