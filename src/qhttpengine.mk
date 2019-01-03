# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qhttpengine
$(PKG)_WEBSITE  := https://github.com/nitroshare/qhttpengine
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := 6505cf889909dc29bab4069116656e7ca5a9e879f04935139439c5691a76c55e
$(PKG)_GH_CONF  := nitroshare/qhttpengine/tags
$(PKG)_DEPS     := cc qtbase

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++11 \
        '$(SOURCE_DIR)/examples/auth/server.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
