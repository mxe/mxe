# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := muparserx
$(PKG)_WEBSITE  := https://beltoforion.de/article.php?a=muparserx
$(PKG)_DESCR    := muParserX
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.7
$(PKG)_CHECKSUM := dd3c68da70a7177224fba015de8a948f2c8e6940d3c6ecde1a87d87ed97d6edf
$(PKG)_GH_CONF  := beltoforion/muparserx/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_EXAMPLES=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
