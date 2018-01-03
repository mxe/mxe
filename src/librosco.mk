# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librosco
$(PKG)_WEBSITE  := https://github.com/colinbourassa/librosco/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.11
$(PKG)_CHECKSUM := 48bb2d07c2575f39bdb6cf022889f20bd855eb9100bb19d4e2536a771198e3a4
$(PKG)_GH_CONF  := colinbourassa/librosco/tags,,,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DENABLE_DOC_INSTALL=off \
        -DENABLE_TESTAPP_INSTALL=off \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' $(1)/src/readmems.c \
        -o '$(PREFIX)/$(TARGET)/bin/test-librosco.exe' \
            `'$(TARGET)-pkg-config' --libs librosco`
endef
