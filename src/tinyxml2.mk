# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tinyxml2
$(PKG)_WEBSITE  := http://grinninglizard.com/tinyxml2/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.1
$(PKG)_CHECKSUM := a381729e32b6c2916a23544c04f342682d38b3f6e6c0cad3c25e900c3a7ef1a6
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
