# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pugixml
$(PKG)_WEBSITE  := https://pugixml.org/
$(PKG)_DESCR    := Light-weight, simple, and fast XML parser for C++ with XPath support
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8
$(PKG)_CHECKSUM := 8ef26a51c670fbe79a71e9af94df4884d5a4b00a2db38a0608a87c14113b2904
$(PKG)_SUBDIR   := pugixml-$($(PKG)_VERSION)
$(PKG)_FILE     := pugixml-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/zeux/pugixml/releases/download/v$($(PKG)_VERSION)/pugixml-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc


define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Libs: -lpugixml';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef
