# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tinyxml2
$(PKG)_WEBSITE  := http://grinninglizard.com/tinyxml2/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.0
$(PKG)_CHECKSUM := fa0d1c745d65d4d833e62cb183e23c2034dc7a35ec1a4977e808bdebb9b4fe60
$(PKG)_GH_CONF  := leethomason/tinyxml2/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -ansi -pedantic \
        '$(SOURCE_DIR)/xmltest.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
