# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tinyxml2
$(PKG)_WEBSITE  := http://grinninglizard.com/tinyxml2/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.0.0
$(PKG)_CHECKSUM := 9444ba6322267110b4aca61cbe37d5dcab040344b5c97d0b36c119aa61319b0f
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
