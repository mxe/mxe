# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pugixml
$(PKG)_WEBSITE  := https://pugixml.org/
$(PKG)_DESCR    := Light-weight, simple, and fast XML parser for C++ with XPath support
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8
$(PKG)_CHECKSUM := 9823684a9600e9ab6d1bc7685d01d07c56f9df41ed3ebf8541aa3dfe8d4074b2
$(PKG)_GH_CONF  := zeux/pugixml/tags,v
$(PKG)_DEPS     := cc


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
