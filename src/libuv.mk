# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libuv
$(PKG)_WEBSITE  := https://libuv.org
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.23.1
$(PKG)_CHECKSUM := c3386003522502d712010b852008b22b37f827e207e184e3d53f0431389299c3
$(PKG)_GH_CONF  := libuv/libuv/tags, v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && sh autogen.sh
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --libs`
endef
